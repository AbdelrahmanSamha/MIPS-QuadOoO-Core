

//test all cases for the case
module reservation_station_lw_sw (
    input clk,
    input reset,
    input [40:0] inst0_in, inst1_in, inst2_in, inst3_in,  // Incoming instructions
    input we0, we1, we2, we3,    // Write enable signals
	 //input [3:0] status, 
	 output reg [3:0] currentstatus,//////******************these two must be configured in the code
	 input [3:0] LoadStore_updated_status,//////*********
	 output [36:0] inst0_out, inst1_out, inst2_out, inst3_out,   // Instruction storage
	 output  stall,              // Stall signal
	 input ROB_stall,
	 input [6:0] BIDs_flush
);


	
	/*the assembly of the incoming instruciton
	[40:36] ROB 5bits
	[35:34] BID 2bits
	[33:28] opcode 6bits
	[27:22] Rt 6 bits 
	[21:16] rs 6 bits 
	[15:0] imm or 
	
	we dont need all of these for the load and store operations we only need : 
	
	ROB, 2lsb bits of opcode, Rs, Rt, and imm value total of 37bits
	
	[36:32] ROB
	[31:30] bid
	[29:28] operation (2bits lsb of the opcode) -> #10 for store, 01 for load#
	[27:22] Rt
	[21:16] Rs
	[15:0] immediate 
	*/
	
	
	/*
	wire [34:0] inst0, inst1, inst2, inst3;

	*/
/*
	reg [3:0] status ;
	reg [3:0] valid;         // currentstatus bits (0 = occupied, 1 = empty)
*/	
	
	wire[36:0]inst0, inst1, inst2, inst3;
		
	assign inst0 = {inst0_in[40:36], inst0_in[35:34], inst0_in[29:28], inst0_in[27:22], inst0_in[21:16],inst0_in[15:0]};
	assign inst1 = {inst1_in[40:36], inst1_in[35:34], inst1_in[29:28], inst1_in[27:22], inst1_in[21:16],inst1_in[15:0]};
	assign inst2 = {inst2_in[40:36], inst2_in[35:34], inst2_in[29:28], inst2_in[27:22], inst2_in[21:16],inst2_in[15:0]};
	assign inst3 = {inst3_in[40:36], inst3_in[35:34], inst3_in[29:28], inst3_in[27:22], inst3_in[21:16],inst3_in[15:0]};
	
	
  	reg [36:0] inst_array [3:0];
	
	wire [2:0] write_count;
    
	assign write_count = we0 + we1 + we2 + we3; // Count incoming currentstatus writes
	
	wire [2:0] LoadStore_updated_status_count;
   
	assign LoadStore_updated_status_count = (LoadStore_updated_status[0] | currentstatus[0]) +
														 (LoadStore_updated_status[1] | currentstatus[1]) +
														 (LoadStore_updated_status[2] | currentstatus[2]) + 
														 (LoadStore_updated_status[3] | currentstatus[3]); // Count incoming currentstatus writes
									
	
	assign stall = (write_count > LoadStore_updated_status_count) ? 1'b1 : 1'b0;
	
	// stall whrn equal 
	
	wire WriteEn0_ls,WriteEn1_ls, WriteEn2_ls,WriteEn3_ls;
	assign WriteEn0_ls =  (stall | ROB_stall)? 1'b0 : we0;
	assign WriteEn1_ls =  (stall | ROB_stall)? 1'b0 : we1;
	assign WriteEn2_ls =  (stall | ROB_stall)? 1'b0 : we2;
	assign WriteEn3_ls =  (stall | ROB_stall)? 1'b0 : we3;
	
	assign inst0_out = inst_array[0];
	assign inst1_out = inst_array[1];
	assign inst2_out = inst_array[2];
	assign inst3_out = inst_array[3];
	

	    always @(posedge clk or posedge  reset) begin
        if (reset) begin
            inst_array[0] = 37'b0;
            inst_array[1] = 37'b0;
            inst_array[2] = 37'b0;
            inst_array[3] = 37'b0;
            currentstatus[0] = 1'b1;
            currentstatus[1] = 1'b1;
            currentstatus[2] = 1'b1;
            currentstatus[3] = 1'b1;
        end else begin
		  
		  /*************************/
		  /*************************/
		
		  //----test all cases-----//		
		  
		  /*************************/
		  /*************************/
		  
		  
		  		  
		  
		  
			if (BIDs_flush[6] && BIDs_flush[inst_array[0][31:30]]) inst_array[0][31:30] = BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[inst_array[1][31:30]]) inst_array[1][31:30] = BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[inst_array[2][31:30]]) inst_array[2][31:30] = BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[inst_array[3][31:30]]) inst_array[3][31:30] = BIDs_flush[5:4];
		
		  
		  
		  
		  
		  
		     currentstatus[3] = LoadStore_updated_status[3] | 
                            LoadStore_updated_status[2] | 
                            LoadStore_updated_status[1] | 
                            LoadStore_updated_status[0];
		  
		  
		   currentstatus[2] = (LoadStore_updated_status[2] & LoadStore_updated_status[3]) |
									(LoadStore_updated_status[1] & LoadStore_updated_status[3]) |
									(LoadStore_updated_status[1] & LoadStore_updated_status[2]) |
									(LoadStore_updated_status[0] & LoadStore_updated_status[3]) |
									(LoadStore_updated_status[0] & LoadStore_updated_status[2]) |
									(LoadStore_updated_status[0] & LoadStore_updated_status[1]);


		  
		  
		  
		  	currentstatus[1] = (LoadStore_updated_status[2] & LoadStore_updated_status[1] & LoadStore_updated_status[0]) |
						 	 (LoadStore_updated_status[3] & LoadStore_updated_status[1] & LoadStore_updated_status[0]) |
						    (LoadStore_updated_status[3] & LoadStore_updated_status[2] & LoadStore_updated_status[0]) |
						  	 (LoadStore_updated_status[3] & LoadStore_updated_status[2] & LoadStore_updated_status[1]) ;
		  
		     currentstatus[0] = LoadStore_updated_status[3] & LoadStore_updated_status[2] &
                            LoadStore_updated_status[1] & LoadStore_updated_status[0];
		  
		  /*
		  
		  
		  	case (LoadStore_updated_status)
            4'b0000: currentstatus = 4'b0000;
            4'b0001: currentstatus = 4'b1000;
            4'b0010: currentstatus = 4'b1000;
            4'b0011: currentstatus = 4'b1100;
            4'b0100: currentstatus = 4'b1000;
            4'b0101: currentstatus = 4'b1100;
            4'b0110: currentstatus = 4'b1100;
            4'b0111: currentstatus = 4'b1110;
            4'b1000: currentstatus = 4'b1000;
            4'b1001: currentstatus = 4'b1100;
            4'b1010: currentstatus = 4'b1100;
            4'b1011: currentstatus = 4'b1110;
            4'b1100: currentstatus = 4'b1100;
            4'b1101: currentstatus = 4'b1110;
            4'b1110: currentstatus = 4'b1110;
            4'b1111: currentstatus = 4'b1111;
            default: currentstatus = 4'b0000; // Default case
        endcase
		  */
		  
		  
		  
		  
		  
		  			//currentstatus = currentstatus |  LoadStore_updated_status;  
		    // Bit 3: Set if any input bit is 1.
/*
   currentstatus[3] = 		 LoadStore_updated_status[3] | 
                            LoadStore_updated_status[2] | 
                            LoadStore_updated_status[1] | 
                            LoadStore_updated_status[0];
									 
									 
	 
									 
*/
  // Bit 2: Derived from analyzing when the second bit is 1.
  /* currentstatus[2] = (LoadStore_updated_status[3] & LoadStore_updated_status[2]) |
                            (LoadStore_updated_status[1] & (LoadStore_updated_status[3] ^ LoadStore_updated_status[2])) |
                            ((~LoadStore_updated_status[3]) & LoadStore_updated_status[2] & LoadStore_updated_status[0]) |
                            ((~LoadStore_updated_status[3]) & (~LoadStore_updated_status[2]) & 
                             LoadStore_updated_status[1] & LoadStore_updated_status[0]);
*//*
 currentstatus[2] = (LoadStore_updated_status[2] & LoadStore_updated_status[3]) | 
                (LoadStore_updated_status[1] & LoadStore_updated_status[3]) | 
                (LoadStore_updated_status[1] & LoadStore_updated_status[2]) | 
                (LoadStore_updated_status[0] & LoadStore_updated_status[2]) | 
                (LoadStore_updated_status[0] & LoadStore_updated_status[1]);
*/

  // Bit 1: 1 only for the cases where the output should be either 1110 or 1111.
   /*currentstatus[1] = (LoadStore_updated_status[3] & LoadStore_updated_status[2] &
                             (LoadStore_updated_status[1] | LoadStore_updated_status[0])) |
                            ((LoadStore_updated_status[3] ^ LoadStore_updated_status[2]) &
                             LoadStore_updated_status[1] & LoadStore_updated_status[0]);
	*/
/*	
	currentstatus[1] = (LoadStore_updated_status[2] & LoadStore_updated_status[1] & LoadStore_updated_status[0]) |
						 	 (LoadStore_updated_status[3] & LoadStore_updated_status[1] & LoadStore_updated_status[0]) |
						    (LoadStore_updated_status[3] & LoadStore_updated_status[2] & LoadStore_updated_status[0]) |
						  	 (LoadStore_updated_status[3] & LoadStore_updated_status[2] & LoadStore_updated_status[1]) ;
	
									  

  // Bit 0: Only set when all input bits are 1.
   currentstatus[0] = LoadStore_updated_status[3] & LoadStore_updated_status[2] &
                            LoadStore_updated_status[1] & LoadStore_updated_status[0];
*/
		  				 // --- Pop-read operation ---
		if (LoadStore_updated_status[0]) begin 
			if (LoadStore_updated_status[1]) begin
				inst_array[0] = inst_array[2];
				inst_array[1] = inst_array[3];
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else if (LoadStore_updated_status[2]) begin  	
				inst_array[0] = inst_array[1];
				inst_array[1] = inst_array[3]; 	
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else if (LoadStore_updated_status[3]) begin 
				inst_array[0] = inst_array[1];
				inst_array[1] = inst_array[2];
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else begin
				inst_array[0] = inst_array[1];
				inst_array[1] = inst_array[2];
				inst_array[2] = inst_array[3];
				inst_array[3] = 37'b0;
			end
		end else if (LoadStore_updated_status[1]) begin 
			if (LoadStore_updated_status[2]) begin 
				inst_array[1] = inst_array[3];
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else if (LoadStore_updated_status[3]) begin 
				inst_array[1] = inst_array[2];
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else begin
				inst_array[1] = inst_array[2];
				inst_array[2] = inst_array[3];
				inst_array[3] = 37'b0;
			end
		end else if (LoadStore_updated_status[2]) begin 
			if (LoadStore_updated_status[3]) begin 
				inst_array[2] = 37'b0;
				inst_array[3] = 37'b0;
			end else begin
				inst_array[2] = inst_array[3];
				inst_array[3] = 37'b0;
			end
		end else if (LoadStore_updated_status[3]) begin 
			inst_array[3] = 37'b0;
		end 
						// --- Write Operation ---
			if (WriteEn0_ls) begin
				if (currentstatus[0]) begin
					inst_array[0] = inst0; currentstatus[0] = 1'b0;
				end else if (currentstatus[1]) begin
					inst_array[1] = inst0; currentstatus[1] = 1'b0;
				end else if (currentstatus[2]) begin
					inst_array[2] = inst0; currentstatus[2] = 1'b0;
				end else if (currentstatus[3]) begin
					inst_array[3] = inst0; currentstatus[3] = 1'b0;
				end
			end

			if (WriteEn1_ls) begin
				if (currentstatus[0]) begin
					inst_array[0] = inst1; currentstatus[0] = 1'b0;
				end else if (currentstatus[1]) begin
					inst_array[1] = inst1; currentstatus[1] = 1'b0;
				end else if (currentstatus[2]) begin
					inst_array[2] = inst1; currentstatus[2] = 1'b0;
				end else if (currentstatus[3]) begin
					inst_array[3] = inst1; currentstatus[3] = 1'b0;
				end
			end

			if (WriteEn2_ls) begin
				if (currentstatus[0]) begin
					inst_array[0] = inst2; currentstatus[0] = 1'b0;
				end else if (currentstatus[1]) begin
					inst_array[1] = inst2; currentstatus[1] = 1'b0;
				end else if (currentstatus[2]) begin
					inst_array[2] = inst2; currentstatus[2] = 1'b0;
				end else if (currentstatus[3]) begin
					inst_array[3] = inst2; currentstatus[3] = 1'b0;
				end
			end

			if (WriteEn3_ls) begin
				if (currentstatus[0]) begin
					inst_array[0] = inst3; currentstatus[0] = 1'b0;
				end else if (currentstatus[1]) begin
					inst_array[1] = inst3; currentstatus[1] = 1'b0;
				end else if (currentstatus[2]) begin
					inst_array[2] = inst3; currentstatus[2] = 1'b0;
				end else if (currentstatus[3]) begin
					inst_array[3] = inst3; currentstatus[3] = 1'b0;
				end
			end
		end
	end
	

// check if working on the pos or neg clk

// 
task automatic print_RSV_LW_SW_TABLE(input integer file);
    integer i;
    reg [36:0] rsv_ins;
    reg valid;
    reg [1:0] operation;
    begin
        $fwrite(file, "currentstatus: [0]:%0d [1]:%0d [2]:%0d [3]:%0d | output_Stall: %0d\n", 
                currentstatus[0], currentstatus[1], currentstatus[2], currentstatus[3], stall);
        $fwrite(file, "-----------------------------------------------------------------\n");
		  
		  $fwrite(file, "LoadStore_updated_status: [0]:%0d [1]:%0d [2]:%0d [3]:%0d | rob Stall : %0d\n", 
					 LoadStore_updated_status[0], LoadStore_updated_status[1], LoadStore_updated_status[2], LoadStore_updated_status[3],ROB_stall);
        $fwrite(file, "-----------------------------------------------------------------\n");
		  
        $fwrite(file, "Index | ROB | BID | Op | Rt  | Rs  |  Immediate  | Valid\n");
        $fwrite(file, "-----------------------------------------------------------------\n");
        
        for (i = 0; i < 4; i = i + 1) begin
            rsv_ins = inst_array[i];
            valid = ~currentstatus[i]; // Valid = 1 if entry is occupied
            operation = rsv_ins[29:28]; // Operation type (2 bits)
            
            $fwrite(file, "%3d | %5b | %2d | %2b | %4d | %4d | %11d | %5d\n",
                i,
                rsv_ins[36:32],     // ROB
                rsv_ins[31:30],     // BID
                operation,          // Op (01=load, 10=store)
                rsv_ins[27:22],     // Rt
                rsv_ins[21:16],     // Rs
                $signed(rsv_ins[15:0]), // Immediate (signed)
                valid               // Valid flag
            );
        end
        $fwrite(file, "-----------------------------------------------------------------\n\n");
    end
endtask

endmodule