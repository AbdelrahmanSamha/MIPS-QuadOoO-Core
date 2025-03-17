module RAT(
    clk,
    reset,
    //decode stage access
    read_index0,
    read_index1,
    read_index2,
    read_index3,
    read_index4,
    read_index5,
    read_index6,
    read_index7,
    read_index8,
    read_index9,
    read_index10,
    read_index11,
	 
    read_data0,
    read_data1,
    read_data2,
    read_data3,
    read_data4,
    read_data5,
    read_data6,
    read_data7,
    read_data8,
    read_data9,
    read_data10,
    read_data11,
	 
	 //rename stage access
	 
	 write_index0,
    write_index1,
    write_index2,
    write_index3,
 
    write_data0,
    write_data1,
    write_data2,
    write_data3,
	 
	 write_en_way0,
	 write_en_way1,
	 write_en_way2,
	 write_en_way3,
	 
	 Branch_Miss,
	 MT_in0,MT_in1,MT_in2,MT_in3,MT_in4,MT_in5,MT_in6,MT_in7,MT_in8,MT_in9,
	 
	 fs_read_index_jr, // input from fetch stage 
	 valid_index_fs_in, // input from fetch stage 
	 
	 read_data_jr,  // output to prf as index
	 valid_index_out_rat, // output to prf 
		mt_stall					
);	
	
    input clk;
    input reset;
    input Branch_Miss;
	 input mt_stall;
	 input write_en_way0, write_en_way1, write_en_way2, write_en_way3;
	 
    input [4:0] read_index0, read_index1, read_index2, read_index3, read_index4, read_index5,
                read_index6, read_index7, read_index8, read_index9, read_index10, read_index11; // 12 read indices, each 5 bits

    input [4:0] write_index0, write_index1, write_index2, write_index3; // 4 write indices, each 5 bits
    input [5:0] write_data0, write_data1, write_data2, write_data3; // 4 write data values, each 6 bits
	 input [10:0]MT_in0,MT_in1,MT_in2,MT_in3,MT_in4,MT_in5,MT_in6,MT_in7,MT_in8,MT_in9;
	 
	 input valid_index_fs_in;
	 input [4:0] fs_read_index_jr;
	 
	 output [5:0] read_data_jr;  
	 output valid_index_out_rat;
	 
    output [5:0] read_data0, read_data1, read_data2, read_data3, read_data4, read_data5,
                 read_data6, read_data7, read_data8, read_data9, read_data10, read_data11; // 12 read data outputs, each 6 bits

    reg [5:0] rat [31:0];                // 32 entries, each 6 bits wide

    // Asynchronous reads
    assign read_data0 = rat[read_index0];
    assign read_data1 = rat[read_index1];
    assign read_data2 = rat[read_index2];
    assign read_data3 = rat[read_index3];
    assign read_data4 = rat[read_index4];
    assign read_data5 = rat[read_index5];
    assign read_data6 = rat[read_index6];
    assign read_data7 = rat[read_index7];
    assign read_data8 = rat[read_index8];
    assign read_data9 = rat[read_index9];
    assign read_data10 = rat[read_index10];
    assign read_data11 = rat[read_index11];
    
	 //assign read_data_jr = rat[fs_read_index_jr];

    // Synchronous writes
    always @(posedge clk or posedge reset) begin
        if (reset) begin
					// Reset all entries to 0
				rat[0]  <= 6'b0;	
				rat[1]  <= 6'd1;
				rat[2]  <= 6'd2;
				rat[3]  <= 6'd3;
				rat[4]  <= 6'd4;
				rat[5]  <= 6'd5;
				rat[6]  <= 6'd6;
				rat[7]  <= 6'd7;
				rat[8]  <= 6'd8;
				rat[9]  <= 6'd9;
				rat[10] <= 6'd10;
				rat[11] <= 6'd11;
				rat[12] <= 6'd12;
				rat[13] <= 6'd13;
				rat[14] <= 6'd14;
				rat[15] <= 6'd15;
				rat[16] <= 6'd16;
				rat[17] <= 6'd17;
				rat[18] <= 6'd18;
				rat[19] <= 6'd19;
				rat[20] <= 6'd20;
				rat[21] <= 6'd21;
				rat[22] <= 6'd22;
				rat[23] <= 6'd23;
				rat[24] <= 6'd24;
				rat[25] <= 6'd25;
				rat[26] <= 6'd26;
				rat[27] <= 6'd27;
				rat[28] <= 6'd28;
				rat[29] <= 6'd29;
				rat[30] <= 6'd30;
				rat[31] <= 6'd31;
			end 
			else if(Branch_Miss)begin
				rat[MT_in0[10:6]] <= MT_in0[5:0];
				rat[MT_in1[10:6]] <= MT_in1[5:0];
				rat[MT_in2[10:6]] <= MT_in2[5:0];
				rat[MT_in3[10:6]] <= MT_in3[5:0];
				rat[MT_in4[10:6]] <= MT_in4[5:0];
				rat[MT_in5[10:6]] <= MT_in5[5:0];
				rat[MT_in6[10:6]] <= MT_in6[5:0];
				rat[MT_in7[10:6]] <= MT_in7[5:0];
				rat[MT_in8[10:6]] <= MT_in8[5:0];
				rat[MT_in9[10:6]] <= MT_in9[5:0];	
			end
			else begin
				
				if (write_en_way0 & !mt_stall) rat[write_index0] <= write_data0;
				if (write_en_way1 & !mt_stall) rat[write_index1] <= write_data1;
            if (write_en_way2 & !mt_stall) rat[write_index2] <= write_data2;
            if (write_en_way3 & !mt_stall) rat[write_index3] <= write_data3;
            
			end
	 end
	 
	 
	 reg [4:0] reg_fs_read_index_jr;
	 reg [4:0] reg_reg_fs_read_index_jr;
	 reg reg_valid_index_fs;
	 reg reg_reg_valid_index_fs;
	 /*********************/
	 
	 
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			reg_fs_read_index_jr <= 5'b0;
			reg_valid_index_fs <= 1'b0;
		end
		else begin 
			reg_fs_read_index_jr <= fs_read_index_jr;
			reg_valid_index_fs <= valid_index_fs_in;
		end
	end
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			reg_reg_fs_read_index_jr <= 5'b0;
			reg_reg_valid_index_fs <= 1'b0;
		end
		else begin 
		  reg_reg_fs_read_index_jr <= reg_fs_read_index_jr;
		  reg_reg_valid_index_fs <= reg_valid_index_fs;
		end
	end
	 
/*	 
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			read_data_jr <= 6'b0;
			valid_index_out_rat <=1'b0;
		end
		else begin 
			read_data_jr <= rat[reg_reg_fs_read_index_jr];
			valid_index_out_rat <= reg_reg_valid_index_fs;
		end
	end
	 
	 */
	 
	 		assign read_data_jr = rat[reg_reg_fs_read_index_jr];
			assign valid_index_out_rat = reg_reg_valid_index_fs;
	 
	 
/***********************/ 
	 
	 
/*	 
	 
	 
	   // Added tasks for monitoring


    reg [4:0] write_indices [0:3]; // Array to store write indices
	 reg [5:0] write_data [0:3];    // Array to store write data
	 reg [3:0] write_en;            // Array to store write enables
	 
	 task print_RAT;
    integer j;
    begin
        $display("\n----------------------------------------------------");
        $display("Register Alias Table (RAT) Contents:");
        $display("Index (5-bit) | Data (6-bit)");
        $display("----------------------------------------------------");

        if (Branch_Miss) begin
            // Display the 10 changes from MT recovery
            for (j = 0; j < 32; j = j + 1) begin
                if ((MT_in0[10:6] == j) || (MT_in1[10:6] == j) || 
                    (MT_in2[10:6] == j) || (MT_in3[10:6] == j) || 
                    (MT_in4[10:6] == j) || (MT_in5[10:6] == j) || 
                    (MT_in6[10:6] == j) || (MT_in7[10:6] == j) || 
                    (MT_in8[10:6] == j) || (MT_in9[10:6] == j)) begin
                    $display("%d         | %d <==== recovering to %d", j[4:0], rat[j],
                        (MT_in0[10:6] == j) ? MT_in0[5:0] :
                        (MT_in1[10:6] == j) ? MT_in1[5:0] :
                        (MT_in2[10:6] == j) ? MT_in2[5:0] :
                        (MT_in3[10:6] == j) ? MT_in3[5:0] :
                        (MT_in4[10:6] == j) ? MT_in4[5:0] :
                        (MT_in5[10:6] == j) ? MT_in5[5:0] :
                        (MT_in6[10:6] == j) ? MT_in6[5:0] :
                        (MT_in7[10:6] == j) ? MT_in7[5:0] :
                        (MT_in8[10:6] == j) ? MT_in8[5:0] :
                        MT_in9[5:0]);
                end else begin
                    $display("%d         | %d", j[4:0], rat[j]);
                end
            end
        end else begin
            // Normal write operation
            for (j = 0; j < 32; j = j + 1) begin
                if ((write_en[0] && write_indices[0] == j) ||
                    (write_en[1] && write_indices[1] == j) ||
                    (write_en[2] && write_indices[2] == j) ||
                    (write_en[3] && write_indices[3] == j)) begin
                    $display("%d         | %d <==== changing to %d", j[4:0], rat[j], 
                        (write_en[0] && write_indices[0] == j) ? write_data[0] :
                        (write_en[1] && write_indices[1] == j) ? write_data[1] :
                        (write_en[2] && write_indices[2] == j) ? write_data[2] :
                        write_data[3]);
                end else begin
                    $display("%d         | %d", j[4:0], rat[j]);
                end
            end
        end
        $display("----------------------------------------------------\n");
    end
endtask
	 
	 // Capture write indices and data during write operations
	 always @(*) begin
		 if (write_en_way0 || write_en_way1 || write_en_way2 || write_en_way3) begin
			 write_en = {write_en_way3, write_en_way2, write_en_way1, write_en_way0};
			 write_indices[0] = write_index0;
			 write_indices[1] = write_index1;
			 write_indices[2] = write_index2;
			 write_indices[3] = write_index3;
			 write_data[0] = write_data0;
			 write_data[1] = write_data1;
			 write_data[2] = write_data2;
			 write_data[3] = write_data3;
		 end else begin
			 write_en = 4'b0000; // Clear write enables if no write operation
		 end
	 end

 
    task print_WriteOperation;
        begin
            $display("New_Cycle \n");
				$display("\nWrite Operation Detected:");
            if (Branch_Miss)begin 
					$display("Recover from MTs");
					$display("Write IndexMT: %d | Written Data: %d", MT_in0[10:6], MT_in0[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in1[10:6], MT_in1[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in2[10:6], MT_in2[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in3[10:6], MT_in3[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in4[10:6], MT_in4[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in5[10:6], MT_in5[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in6[10:6], MT_in6[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in7[10:6], MT_in7[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in8[10:6], MT_in8[5:0]);
					$display("Write IndexMT: %d | Written Data: %d", MT_in9[10:6], MT_in9[5:0]);
				
				end
				else begin 
				if (write_en_way0) $display("Write Index: %d | Written Data: %d", write_index0, write_data0);
            if (write_en_way1) $display("Write Index: %d | Written Data: %d", write_index1, write_data1);
            if (write_en_way2) $display("Write Index: %d | Written Data: %d", write_index2, write_data2);
            if (write_en_way3) $display("Write Index: %d | Written Data: %d", write_index3, write_data3);
            end
        end
    endtask
*/

	 reg [4:0] write_indices [0:3]; // Array to store write indices
	 reg [5:0] write_data [0:3];    // Array to store write data
	 reg [3:0] write_en;            // Array to store write enables
task print_RAT(input integer file);
    integer j;
    begin
        $fwrite(file, "\n----------------------------------------------------\n");
        $fwrite(file, "Register Alias Table (RAT) Contents:\n");
        $fwrite(file, "Index (5-bit) | Data (6-bit)\n");
        $fwrite(file, "----------------------------------------------------\n");

        if (Branch_Miss) begin
            // Display the 10 changes from MT recovery
            for (j = 0; j < 32; j = j + 1) begin
                if ((MT_in0[10:6] == j) || (MT_in1[10:6] == j) || 
                    (MT_in2[10:6] == j) || (MT_in3[10:6] == j) || 
                    (MT_in4[10:6] == j) || (MT_in5[10:6] == j) || 
                    (MT_in6[10:6] == j) || (MT_in7[10:6] == j) || 
                    (MT_in8[10:6] == j) || (MT_in9[10:6] == j)) begin
                    $fwrite(file, "%d         | %d <==== recovering to %d\n", j[4:0], rat[j],
                        (MT_in0[10:6] == j) ? MT_in0[5:0] :
                        (MT_in1[10:6] == j) ? MT_in1[5:0] :
                        (MT_in2[10:6] == j) ? MT_in2[5:0] :
                        (MT_in3[10:6] == j) ? MT_in3[5:0] :
                        (MT_in4[10:6] == j) ? MT_in4[5:0] :
                        (MT_in5[10:6] == j) ? MT_in5[5:0] :
                        (MT_in6[10:6] == j) ? MT_in6[5:0] :
                        (MT_in7[10:6] == j) ? MT_in7[5:0] :
                        (MT_in8[10:6] == j) ? MT_in8[5:0] :
                        MT_in9[5:0]);
                end else begin
                    $fwrite(file, "%d         | %d\n", j[4:0], rat[j]);
                end
            end
        end else begin
            // Normal write operation
            for (j = 0; j < 32; j = j + 1) begin
                if ((write_en[0] && write_indices[0] == j) ||
                    (write_en[1] && write_indices[1] == j) ||
                    (write_en[2] && write_indices[2] == j) ||
                    (write_en[3] && write_indices[3] == j)) begin
                    $fwrite(file, "%d         | %d <==== changing to %d\n", j[4:0], rat[j], 
                        (write_en[0] && write_indices[0] == j) ? write_data[0] :
                        (write_en[1] && write_indices[1] == j) ? write_data[1] :
                        (write_en[2] && write_indices[2] == j) ? write_data[2] :
                        write_data[3]);
                end else begin
                    $fwrite(file, "%d         | %d\n", j[4:0], rat[j]);
                end
            end
        end
        $fwrite(file, "----------------------------------------------------\n\n");
    end
endtask

always @(*) begin
		 if (write_en_way0 || write_en_way1 || write_en_way2 || write_en_way3) begin
			 write_en = {write_en_way3, write_en_way2, write_en_way1, write_en_way0};
			 write_indices[0] = write_index0;
			 write_indices[1] = write_index1;
			 write_indices[2] = write_index2;
			 write_indices[3] = write_index3;
			 write_data[0] = write_data0;
			 write_data[1] = write_data1;
			 write_data[2] = write_data2;
			 write_data[3] = write_data3;
		 end else begin
			 write_en = 4'b0000; // Clear write enables if no write operation
		 end
	 end

task print_WriteOperation(input integer file);
    begin
        $fwrite(file, "New_Cycle \n\n");
        $fwrite(file, "\nWrite Operation Detected:\n");
        if (Branch_Miss) begin
            $fwrite(file, "Recover from MTs\n");
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in0[10:6], MT_in0[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in1[10:6], MT_in1[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in2[10:6], MT_in2[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in3[10:6], MT_in3[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in4[10:6], MT_in4[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in5[10:6], MT_in5[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in6[10:6], MT_in6[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in7[10:6], MT_in7[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in8[10:6], MT_in8[5:0]);
            $fwrite(file, "Write IndexMT: %d | Written Data: %d\n", MT_in9[10:6], MT_in9[5:0]);
        end else begin
            if (write_en_way0) $fwrite(file, "Write Index: %d | Written Data: %d\n", write_index0, write_data0);
            if (write_en_way1) $fwrite(file, "Write Index: %d | Written Data: %d\n", write_index1, write_data1);
            if (write_en_way2) $fwrite(file, "Write Index: %d | Written Data: %d\n", write_index2, write_data2);
            if (write_en_way3) $fwrite(file, "Write Index: %d | Written Data: %d\n", write_index3, write_data3);
        end
    end
endtask




endmodule
