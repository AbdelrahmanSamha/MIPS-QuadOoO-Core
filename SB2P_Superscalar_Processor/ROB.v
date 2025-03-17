	module ROB(
		input               clk,
		input               rst,
		
		//==== Per-way instruction details ====//
		input               way0_Valid, way1_Valid, way2_Valid, way3_Valid,
		input               way0_sw, way1_sw, way2_sw, way3_sw,
		input               way0_branch, way1_branch, way2_branch, way3_branch,
		input        [4:0]  way0_arcreg, way1_arcreg, way2_arcreg, way3_arcreg,
		input        [5:0]  way0_physicalreg, way1_physicalreg, way2_physicalreg, way3_physicalreg,
		input        [5:0]  way0_stale, way1_stale, way2_stale, way3_stale,
		input        [1:0]  way0_bid, way1_bid, way2_bid, way3_bid,
		
		//==== Stall signals ====//
		input stall_reservation_station, stall_reservation_station_LS,mt_stall,
		
		//==== Execution unit inputs ====//
		input [4:0] ROBlsu0, ROBlsu1, ROBalu0, ROBalu1, ROBalu2, ROBbu,
		input lsu0valid, lsu1valid, alu0valid, alu1valid, alu2valid, buvalid,
		input [1:0] BID,
		input [6:0] BIDs_flush,
		input resolution,
		
		//==== Outputs ====//

		output reg  [2:0] tail,
		output all_done,
		output stall,
		output [23:0] head_bank0, head_bank1, head_bank2, head_bank3,
		output reg [4:0]  ROB_sw_commit0,ROB_sw_commit1,
		output reg PNR_sw0, PNR_sw1
		
	);
	
	//================ Entry Structure ================//
	//[valid(1)|done(1)|sw(1)|branch(1)|arcreg(5)|physicalreg(6)|stale(6)|bid(2)|exception(1)] 
	/*[23] valid
	  [22] done 
	  [21] is_sw
	  [20] is_branch
	  [19:15] arc register
	  [14:9] physical register 
	  [8:3] stale 
	  [2:1] bid 
	  [0] excpetion
	
	
	*/
	
	parameter ENTRY_WIDTH = 24;
	reg [ENTRY_WIDTH-1:0] bank0 [0:7];
	reg [ENTRY_WIDTH-1:0] bank1 [0:7];
	reg [ENTRY_WIDTH-1:0] bank2 [0:7];
	reg [ENTRY_WIDTH-1:0] bank3 [0:7];
	
	wire all_NoP ;
	assign all_NoP = !way0_Valid & !way1_Valid & !way2_Valid & !way3_Valid;
	//if there was a NoP among a batch that has at least 1 instruction, then this NoP instruction/s must be written as ready in the ROB when inserted from the renmae stage. 
	reg [2:0]head;
	
	wire head_notempty;
	wire full;
	assign full = ((tail == head) && head_notempty);
	assign stall = full;
	assign all_done = bank0[head][22] & bank1[head][22] & bank2[head][22] & bank3[head][22];
	
	assign head_bank0 = bank0[head];
	assign head_bank1 = bank1[head];
	assign head_bank2 = bank2[head];
	assign head_bank3 = bank3[head];
												//the head is not empty if there is a valid instruction in any bank and that instruciton is not an exception...
	assign head_notempty = ((head_bank0[23] && !head_bank0[0]) || (head_bank1[23]&& !head_bank1[0]) || (head_bank2[23]&& !head_bank2[0]) || (head_bank3[23]&& !head_bank3[0])) ;
	
	//point of no return signals indicate that we can commit this instruction. 
	always @(*) begin 
		 ROB_sw_commit0 = 5'b0;
		 ROB_sw_commit1 = 5'b0;
		 PNR_sw0 = 1'b0;
		 PNR_sw1 = 1'b0;
		 
		 if(head_bank0[21] == 1'b1) begin
			  ROB_sw_commit0 = {head, 2'b00};
			  //if the exception bit was 0 then we can commit the instruction. 
			  if (!head_bank0[0]) PNR_sw0 = 1'b1;
			  
			  if(head_bank1[21] == 1'b1) begin
					ROB_sw_commit1 = {head, 2'b01};
					if(!head_bank1[0]) PNR_sw1 = 1'b1;
			  end 
			  else if(head_bank2[21] == 1'b1) begin 
					ROB_sw_commit1 = {head, 2'b10};
					if(!head_bank2[0]) PNR_sw1 = 1'b1;  
			  end
			  else if(head_bank3[21] == 1'b1) begin 
					ROB_sw_commit1 = {head, 2'b11};
					if(!head_bank3[0]) PNR_sw1 = 1'b1; 
			  end 
		 end 
		 else if(head_bank1[21] == 1'b1) begin 
			  ROB_sw_commit0 = {head, 2'b01};
			  if(!head_bank1[0]) PNR_sw0 = 1'b1;
			  
			  if(head_bank2[21] == 1'b1) begin 
					ROB_sw_commit1 = {head, 2'b10};
					if(!head_bank2[0]) PNR_sw1 = 1'b1;
			  end
			  else if(head_bank3[21] == 1'b1) begin 
					ROB_sw_commit1 = {head, 2'b11};            
					if (!head_bank3[0]) PNR_sw1 = 1'b1;
			  end  
		 end  
		 else if(head_bank2[21] == 1'b1) begin 
			  ROB_sw_commit0 = {head, 2'b10};
			  if (!head_bank2[0]) PNR_sw0 = 1'b1;
			  
			  if(head_bank3[21] == 1'b1) begin 
					ROB_sw_commit1 = {head, 2'b11};
					if(!head_bank3[0]) PNR_sw1 = 1'b1;
			  end
		 end
		 else if(head_bank3[21] == 1'b1) begin 
			  ROB_sw_commit0 = {head, 2'b11};
			  if(!head_bank3[0]) PNR_sw0 = 1'b1;
		 end
	end
		
	
	
	integer i;
	always @(posedge clk or posedge rst) begin
		
		if (rst) begin
			for (i = 0; i < 8; i = i+1) begin
				bank0[i] <= 0;
				bank1[i] <= 0;
				bank2[i] <= 0;
				bank3[i] <= 0;
			end
			head <= 3'b0;
			tail <= 3'b0;
			
		end
		else begin
			// Temporary variables for conditional updates
			
			//============================================
			// 1. Handle Execution Unit Completions
			//============================================
			// LSU0 completion
			if (lsu0valid) begin
				case (ROBlsu0[1:0])
					2'b00: bank0[ROBlsu0[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBlsu0[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBlsu0[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBlsu0[4:2]][22] <= 1'b1;
				endcase
			end
			// LSU1 completion
			if (lsu1valid) begin
				case (ROBlsu1[1:0])
					2'b00: bank0[ROBlsu1[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBlsu1[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBlsu1[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBlsu1[4:2]][22] <= 1'b1;
				endcase
			end
			// ALU0 completion
			if (alu0valid) begin
				case (ROBalu0[1:0])
					2'b00: bank0[ROBalu0[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBalu0[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBalu0[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBalu0[4:2]][22] <= 1'b1;
				endcase
			end
			// ALU1 completion
			if (alu1valid) begin
				case (ROBalu1[1:0])
					2'b00: bank0[ROBalu1[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBalu1[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBalu1[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBalu1[4:2]][22] <= 1'b1;
				endcase
			end
			// ALU2 completion
			if (alu2valid) begin
				case (ROBalu2[1:0])
					2'b00: bank0[ROBalu2[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBalu2[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBalu2[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBalu2[4:2]][22] <= 1'b1;
				endcase
			end
			
			// Branch Unit completion
			if (buvalid) begin
				case (ROBbu[1:0])
					2'b00: bank0[ROBbu[4:2]][22] <= 1'b1;
					2'b01: bank1[ROBbu[4:2]][22] <= 1'b1;
					2'b10: bank2[ROBbu[4:2]][22] <= 1'b1;
					2'b11: bank3[ROBbu[4:2]][22] <= 1'b1;
				endcase
					// Set exception bits for all entries with matching BID
					for (i = 0; i < 8; i = i+1) begin
						// Bank 0
						if (BIDs_flush[bank0[i][2:1]])begin 
							if(!resolution) bank0[i][0] <= 1'b1;
							if(resolution)  bank0[i][2:1] <= BIDs_flush[5:4];
						end
						// Bank 1
						if (BIDs_flush[bank1[i][2:1]])begin 
							if(!resolution) bank1[i][0] <= 1'b1;
							if(resolution)  bank1[i][2:1] <= BIDs_flush[5:4];
						end
						// Bank 2
						if (BIDs_flush[bank2[i][2:1]])begin 
							if(!resolution) bank2[i][0] <= 1'b1;
							if(resolution)  bank2[i][2:1] <= BIDs_flush[5:4];
						end
						// Bank 3
						if (BIDs_flush[bank3[i][2:1]])begin 
							if(!resolution) bank3[i][0] <= 1'b1;
							if(resolution)  bank3[i][2:1] <= BIDs_flush[5:4];
						end	
					end
			end
	
			//============================================
			// 2. Handle Commitment
			//============================================
			if (all_done) begin
				bank0[head][23] <= 1'b0;
				bank1[head][23] <= 1'b0;
				bank2[head][23] <= 1'b0;
				bank3[head][23] <= 1'b0;
				bank0[head][22] <= 1'b0;
				bank1[head][22] <= 1'b0;
				bank2[head][22] <= 1'b0;
				bank3[head][22] <= 1'b0;
				head <= head + 3'b1;
			end
	
			//============================================
			// 3. Handle Branch Misprediction
			//============================================
			//the priority is for the branch miss prediction, because if there was a misprediction then whatever is in the rename stage is not valid and we dont need to write it. 
			if ( buvalid & !resolution )begin 
				if(ROBbu[1:0] == 2'b00)begin 
					tail <= ROBbu[4:2];
					bank0[ROBbu[4:2]][23]<=1'b0; bank1[ROBbu[4:2]][23]<=1'b0; bank2[ROBbu[4:2]][23]<=1'b0; bank3[ROBbu[4:2]][23]<=1'b0;
					bank0[ROBbu[4:2]][22]<=1'b0; bank1[ROBbu[4:2]][22]<=1'b0; bank2[ROBbu[4:2]][22]<=1'b0; bank3[ROBbu[4:2]][22]<=1'b0;
			
				end
							// if the branch is in bank 3 we need to make sure if there is valid instructions behind it, non valid instruction are counted as NoP, 
							//and thus if theres a NoPs in bank 0,1,2 then the tail must point to this index the branch is currently at, but if there was at least a sigle valid instruction then we need to be able to commit that instruction.
							// therfor we make the tail = the branch row + 1.
				else if ((ROBbu[1:0] == 2'b11) && ((bank0[ROBbu[4:2]][23]) || (bank1[ROBbu[4:2]][23]) || (bank2[ROBbu[4:2]][23])))begin 
						tail <= ROBbu[4:2]+ 3'b1; 
						bank0[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][23]<=1'b0;
						bank0[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][22]<=1'b0;
				end 
				else if ((ROBbu[1:0] == 2'b10) && ((bank0[ROBbu[4:2]][23]) || (bank1[ROBbu[4:2]][23])))begin 
						tail <= ROBbu[4:2]+ 3'b1; 
						bank0[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][23]<=1'b0;
						bank0[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][22]<=1'b0;
						bank3[ROBbu[4:2]][22]<=1'b1;
				end 
				else if ((ROBbu[1:0] == 2'b01) && ((bank0[ROBbu[4:2]][23])))begin 
						tail <= ROBbu[4:2]+ 3'b1; 
						bank0[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][23]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][23]<=1'b0;
						bank0[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank1[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank2[ROBbu[4:2]+ 3'b1][22]<=1'b0; bank3[ROBbu[4:2]+ 3'b1][22]<=1'b0;
					   bank2[ROBbu[4:2]][22]<=1'b1; bank3[ROBbu[4:2]][22]<=1'b1;
				end
				else begin 
						tail <= ROBbu[4:2];
						bank0[ROBbu[4:2] ][23]<=1'b0; bank1[ROBbu[4:2]][23]<=1'b0; bank2[ROBbu[4:2]][23]<=1'b0; bank3[ROBbu[4:2]][23]<=1'b0;
						bank0[ROBbu[4:2]][22]<=1'b0; bank1[ROBbu[4:2]][22]<=1'b0; bank2[ROBbu[4:2]][22]<=1'b0; bank3[ROBbu[4:2]][22]<=1'b0;
				end
			end 
	
			//============================================
			// 4. Write New Entries
			//============================================
			else if (!all_NoP && !stall_reservation_station && !stall_reservation_station_LS &&!stall && !mt_stall ) begin
				bank0[tail] <= {way0_Valid, !way0_Valid, way0_sw, way0_branch, 
							way0_arcreg, way0_physicalreg, way0_stale, way0_bid, !way0_Valid};
							
				bank1[tail] <= {way1_Valid, !way1_Valid, way1_sw, way1_branch,
							way1_arcreg, way1_physicalreg, way1_stale, way1_bid, !way1_Valid};
							
				bank2[tail] <= {way2_Valid, !way2_Valid, way2_sw, way2_branch,
							way2_arcreg, way2_physicalreg, way2_stale, way2_bid, !way2_Valid};
							
				bank3[tail] <= {way3_Valid, !way3_Valid, way3_sw, way3_branch,
							way3_arcreg, way3_physicalreg, way3_stale, way3_bid, !way3_Valid};
				tail <= tail + 3'b1;
			end
	
			 
			
		end
	end

	// Task to parse and print a single row
   /* task print_row(input [23:0] entry);
        begin
            $write("| %d | %d | %d | %d | %d | %d | %d | %d | %d |",
                entry[23], entry[22], entry[21], entry[20], entry[19:15], entry[14:9],
                entry[8:3], entry[2:1], entry[0]
            );
        end
    endtask

    // Task to print the entire ROB banks
    task print_rob;
        integer i;
        begin
            $display("\n================ ROB STATE ================\n");
            $display("Head: %d | Tail: %d | BuValid: %b | BID: %b | HIT: %b | ROBbu : %d | verfff : %b ", head, tail, buvalid, BID, resolution , ROBbu[4:2], verfff);
            $display("----------------------------------------------------------");
            $display("| Bank 0                                     | Bank 1                                   | Bank 2                                   | Bank 3           |");
            $display("----------------------------------------------------------");
				$display("  | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC");

            for (i = 0; i < 8; i = i + 1) begin
					 $write("%1d", i);
                $write("|");
                print_row(bank0[i]);
                $write("*|*");
                print_row(bank1[i]);
                $write("*|*");
                print_row(bank2[i]);
                $write("*|*");
                print_row(bank3[i]);
                $display(" |");
            end
            $display("----------------------------------------------------------\n");
        end
    endtask*/
	 
	 
	 task print_row(input integer file, input [23:0] entry);
    begin
        $fwrite(file, "| %d | %d | %d | %d | %d | %d | %d | %d | %d |",
            entry[23], entry[22], entry[21], entry[20], entry[19:15], entry[14:9],
            entry[8:3], entry[2:1], entry[0]
        );
    end
	endtask
	
	task print_rob(input integer file);
    integer i;
    begin
        $fwrite(file, "\n================ ROB STATE ================\n");
        $fwrite(file, "Head: %d | Tail: %d | BuValid: %b | BID: %b | HIT: %b | ROBbu : %d | \n",
                head, tail, buvalid, BID, resolution, ROBbu[4:2]);
        $fwrite(file, "----------------------------------------------------------\n");
        $fwrite(file, "| Bank 0                                     | Bank 1                                   | Bank 2                                   | Bank 3           |\n");
        $fwrite(file, "----------------------------------------------------------\n");
        $fwrite(file, "  | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC    | V | D | SW| BR| ARC| PHY| STA| ID|EXC\n");

        for (i = 0; i < 8; i = i + 1) begin
            $fwrite(file, "%1d", i);
            $fwrite(file, "|");
            print_row(file, bank0[i]);
            $fwrite(file, "*|*");
            print_row(file, bank1[i]);
            $fwrite(file, "*|*");
            print_row(file, bank2[i]);
            $fwrite(file, "*|*");
            print_row(file, bank3[i]);
            $fwrite(file, " |\n");
        end
        $fwrite(file, "----------------------------------------------------------\n");
    end
endtask
endmodule