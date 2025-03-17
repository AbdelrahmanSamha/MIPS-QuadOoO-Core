module IDID2 (
    input clk, rst,
	input	write_on_rd0_in,write_on_rd1_in,write_on_rd2_in,write_on_rd3_in,
	input match0_rd1_in, match0_rd2_in, match0_rd3_in, match0_rs1a_in, match0_rs1b_in,
			match0_rs2a_in, match0_rs2b_in, match0_rs3a_in, match0_rs3b_in,
			match1_rd2_in, match1_rd3_in, match1_rs2a_in, match1_rs2b_in, match1_rs3a_in, match1_rs3b_in,
			match2_rd3_in, match2_rs3a_in, match2_rs3b_in,
			
	input [3:0] valid_word_in,
	input is_branch3_in,is_branch2_in,is_branch1_in,is_branch0_in,
	input [4:0] rd0_in, rd1_in, rd2_in, rd3_in,
	input [17:0] inst0_in, inst1_in, inst2_in, inst3_in,
	input partofbranch0in,partofbranch1in,partofbranch2in,partofbranch3in,
	input [1:0] BID0in,BID1in,BID2in,BID3in,
	input [5:0] control_decode_0, control_decode_1, control_decode_2, control_decode_3,
	input [15:0] imm0_decode, imm1_decode, imm2_decode, imm3_decode,
	
	input stall_branch_priority_table,
	input stall_reservation_station_LS,
	input stall_reservation_station,
	input ROB_stall,
	input flush_branch_Miss,
	input mt_stall, 
	input stall_frpools,
	output reg is_branch3_out,is_branch2_out,is_branch1_out,is_branch0_out,
	output reg [3:0] valid_word_out,
	output reg match0_rd1_out, match0_rd2_out, match0_rd3_out, match0_rs1a_out, match0_rs1b_out,
				  match0_rs2a_out, match0_rs2b_out, match0_rs3a_out, match0_rs3b_out,
				  match1_rd2_out, match1_rd3_out, match1_rs2a_out, match1_rs2b_out, match1_rs3a_out, match1_rs3b_out,
              match2_rd3_out, match2_rs3a_out, match2_rs3b_out,
	output reg [4:0] rd0_out, rd1_out, rd2_out, rd3_out,
   output reg [17:0] inst0_out, inst1_out, inst2_out, inst3_out,
	output reg write_on_rd0_out,write_on_rd1_out,write_on_rd2_out,write_on_rd3_out,
	output reg  partofbranch0out,partofbranch1out,partofbranch2out, partofbranch3out,
	output reg [1:0] BID0out,BID1out,BID2out,BID3out,
	output reg [5:0] control_decode_out0, control_decode_out1, control_decode_out2, control_decode_out3,
	output reg [15:0] imm0_decode_out, imm1_decode_out, imm2_decode_out,imm3_decode_out
	 
);
	 
always@(posedge clk or posedge rst)begin 
	if (rst) begin 
		inst0_out <= 18'b0;
		
		match0_rd1_out <= 1'b0;
		match0_rd2_out <= 1'b0;
		match0_rd3_out <= 1'b0;
		match0_rs1a_out <= 1'b0;
		match0_rs1b_out <= 1'b0;		
		match0_rs2a_out <= 1'b0;
		match0_rs2b_out <= 1'b0;
		match0_rs3a_out <= 1'b0;
		match0_rs3b_out <= 1'b0;
		partofbranch0out <=1'b0;
		rd0_out <= 5'b0;
		write_on_rd0_out <= 1'b0;
		
		BID0out <= 2'b00;
		is_branch0_out <= 1'b0;
		
		control_decode_out0 <= 1'b0;
		imm0_decode_out <= 1'b0;

	end
	else if(flush_branch_Miss)begin
		inst0_out <= 18'b0;
		
		match0_rd1_out <= 1'b0;
		match0_rd2_out <= 1'b0;
		match0_rd3_out <= 1'b0;
		match0_rs1a_out <= 1'b0;
		match0_rs1b_out <= 1'b0;		
		match0_rs2a_out <= 1'b0;
		match0_rs2b_out <= 1'b0;
		match0_rs3a_out <= 1'b0;
		match0_rs3b_out <= 1'b0;
		partofbranch0out <=1'b0;
		rd0_out <= 5'b0;
		write_on_rd0_out <= 1'b0;
		
		BID0out <= 2'b00;
		is_branch0_out <= 1'b0;
		
		control_decode_out0 <= 1'b0;
		imm0_decode_out <= 1'b0;
	
	end
	else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS | mt_stall)begin
		inst0_out<=inst0_out;
		
		match0_rd3_out <= match0_rd3_out;
		match0_rd2_out <= match0_rd2_out;
		match0_rd1_out <= match0_rd1_out;		
		
		match0_rs3b_out <= match0_rs3b_out;		
		match0_rs3a_out <= match0_rs3a_out;		
		match0_rs2a_out <= match0_rs2a_out;	
		
		match0_rs2b_out <= match0_rs2b_out;		
		match0_rs1b_out <= match0_rs1b_out;		
		match0_rs1a_out <= match0_rs1a_out;
		
		
		rd0_out <= rd0_out;
      write_on_rd0_out <= write_on_rd0_out;
		
		BID0out <= BID0out;
		partofbranch0out <=partofbranch0out;
		
		is_branch0_out <= is_branch0_out;

		control_decode_out0 <= control_decode_out0;
		imm0_decode_out <= imm0_decode_out;
	end	
		
	else if(stall_branch_priority_table | stall_frpools)begin
		inst0_out <= 18'b0;
		
		match0_rd1_out <= 1'b0;
		match0_rd2_out <= 1'b0;
		match0_rd3_out <= 1'b0;
		match0_rs1a_out <= 1'b0;
		match0_rs1b_out <= 1'b0;		
		match0_rs2a_out <= 1'b0;
		match0_rs2b_out <= 1'b0;
		match0_rs3a_out <= 1'b0;
		match0_rs3b_out <= 1'b0;
		partofbranch0out <=1'b0;
		rd0_out <= 5'b0;
		write_on_rd0_out <= 1'b0;
		
		BID0out <= 2'b00;
		is_branch0_out <= 1'b0;
		
		control_decode_out0 <= 1'b0;
		imm0_decode_out <= 1'b0;


	end
	else begin
		inst0_out<=inst0_in;
		
		match0_rd3_out <= match0_rd3_in;
		match0_rd2_out <= match0_rd2_in;
		match0_rd1_out <= match0_rd1_in;		
		match0_rs3b_out <= match0_rs3b_in;		
		match0_rs3a_out <= match0_rs3a_in;		
		match0_rs2a_out <= match0_rs2a_in;		
		match0_rs2b_out <= match0_rs2b_in;		
		match0_rs1b_out <= match0_rs1b_in;		
		match0_rs1a_out <= match0_rs1a_in;
		
		rd0_out <= rd0_in;
      write_on_rd0_out <= write_on_rd0_in;
		
		BID0out <= BID0in;
		partofbranch0out <=partofbranch0in;
		
		is_branch0_out <= is_branch0_in;

		control_decode_out0 <= control_decode_0;
		imm0_decode_out <= imm0_decode;
	end
end 


always@(posedge clk or posedge rst)begin 
	if (rst) begin 
		inst1_out <= 18'b0;
		match1_rd3_out <= 1'b0;		
		match1_rd2_out <= 1'b0;		
		match1_rs3b_out <= 1'b0;		
		match1_rs3a_out <= 1'b0;		
		match1_rs2b_out <= 1'b0;		
		match1_rs2a_out <= 1'b0;
		partofbranch1out <=1'b0;
		rd1_out <= 5'b0;
      write_on_rd1_out <= 1'b0;
		
		BID1out <= 2'b00;
		
		is_branch1_out <= 1'b0;
		
		control_decode_out1 <= 1'b0;
		imm1_decode_out <= 1'b0;

	end 
	else if(flush_branch_Miss)begin
		inst1_out <= 18'b0;
		match1_rd3_out <= 1'b0;		
		match1_rd2_out <= 1'b0;		
		match1_rs3b_out <= 1'b0;		
		match1_rs3a_out <= 1'b0;		
		match1_rs2b_out <= 1'b0;		
		match1_rs2a_out <= 1'b0;
		partofbranch1out <=1'b0;
		rd1_out <= 5'b0;
      write_on_rd1_out <= 1'b0;
		
		BID1out <= 2'b00;
		
		is_branch1_out <= 1'b0;
		
		control_decode_out1 <= 1'b0;
		imm1_decode_out <= 1'b0;
	
	end
	else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS | mt_stall)begin
		 inst1_out<=inst1_out;
		
		match1_rd2_out <=  match1_rd2_out;		
		match1_rd3_out <=  match1_rd3_out;		
		match1_rs2a_out <= match1_rs2a_out;	
		
		match1_rs2b_out <= match1_rs2b_out;		
		match1_rs3a_out <= match1_rs3a_out;		
		match1_rs3b_out <= match1_rs3b_out;	
		
		rd1_out <= rd1_out;
		write_on_rd1_out <= write_on_rd1_out;
		
		BID1out <= BID1out;
		partofbranch1out <=partofbranch1out;
		
		is_branch1_out <= is_branch1_out;

		
		control_decode_out1 <= control_decode_out1;
		imm1_decode_out <= imm1_decode_out;
	end
	else if(stall_branch_priority_table | stall_frpools)begin
		inst1_out <= 18'b0;
		match1_rd3_out <= 1'b0;		
		match1_rd2_out <= 1'b0;		
		match1_rs3b_out <= 1'b0;		
		match1_rs3a_out <= 1'b0;		
		match1_rs2b_out <= 1'b0;		
		match1_rs2a_out <= 1'b0;
		partofbranch1out <=1'b0;
		rd1_out <= 5'b0;
      write_on_rd1_out <= 1'b0;
		
		BID1out <= 2'b00;
		
		is_branch1_out <= 1'b0;
		
		control_decode_out1 <= 1'b0;
		imm1_decode_out <= 1'b0;
	end
	else begin
		inst1_out<=inst1_in;
		
		match1_rd2_out <=  match1_rd2_in;		
		match1_rd3_out <=  match1_rd3_in;		
		match1_rs2a_out <= match1_rs2a_in;		
		match1_rs2b_out <= match1_rs2b_in;		
		match1_rs3a_out <= match1_rs3a_in;		
		match1_rs3b_out <= match1_rs3b_in;	
		
		rd1_out <= rd1_in;
		write_on_rd1_out <= write_on_rd1_in;
		
		BID1out <= BID1in;
		partofbranch1out <=partofbranch1in;
		
		is_branch1_out <= is_branch1_in;

		
		control_decode_out1 <= control_decode_1;
		imm1_decode_out <= imm1_decode;
		
	end
end 


always@(posedge clk or posedge rst)begin 
	if (rst) begin 
		inst2_out <= 18'b0;
		match2_rd3_out <= 1'b0;		
		match2_rs3a_out <= 1'b0;		
		match2_rs3b_out <= 1'b0;		
		partofbranch2out <=1'b0;
		rd2_out <= 5'b0;
		write_on_rd2_out <= 1'b0;
		
		BID2out <= 2'b00;
		
		is_branch2_out <= 1'b0;

		control_decode_out2 <= 1'b0;
		imm2_decode_out <= 1'b0;
		
	end 
	else if(flush_branch_Miss)begin
		inst2_out <= 18'b0;
		match2_rd3_out <= 1'b0;		
		match2_rs3a_out <= 1'b0;		
		match2_rs3b_out <= 1'b0;		
		partofbranch2out <=1'b0;
		rd2_out <= 5'b0;
		write_on_rd2_out <= 1'b0;
		
		BID2out <= 2'b00;
		
		is_branch2_out <= 1'b0;

		control_decode_out2 <= 1'b0;
		imm2_decode_out <= 1'b0;
	
	end
	else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS | mt_stall)begin
		inst2_out<=inst2_out;
		match2_rd3_out <= match2_rd3_out;		
		match2_rs3a_out <= match2_rs3a_out;		
		match2_rs3b_out <= match2_rs3b_out;		
		partofbranch2out <=partofbranch2out;
		rd2_out <= rd2_out;
		write_on_rd2_out <= write_on_rd2_out; 
		
		BID2out <= BID2out;
		
		is_branch2_out <= is_branch2_out;

		
		control_decode_out2 <= control_decode_out2;
		imm2_decode_out <= imm2_decode_out;
	end
	
	else if(stall_branch_priority_table | stall_frpools )begin
		inst2_out <= 18'b0;
		match2_rd3_out <= 1'b0;		
		match2_rs3a_out <= 1'b0;		
		match2_rs3b_out <= 1'b0;		
		partofbranch2out <=1'b0;
		rd2_out <= 5'b0;
		write_on_rd2_out <= 1'b0;
		
		BID2out <= 2'b00;
		
		is_branch2_out <= 1'b0;

		control_decode_out2 <= 1'b0;
		imm2_decode_out <= 1'b0;
	end
	else begin
		inst2_out<=inst2_in;
		match2_rd3_out <= match2_rd3_in;		
		match2_rs3a_out <= match2_rs3a_in;		
		match2_rs3b_out <= match2_rs3b_in;		
		partofbranch2out <=partofbranch2in;
		rd2_out <= rd2_in;
		write_on_rd2_out <= write_on_rd2_in; 
		
		BID2out <= BID2in;
		
		is_branch2_out <= is_branch2_in;

		
		control_decode_out2 <= control_decode_2;
		imm2_decode_out <= imm2_decode;
		
	end
end 


always@(posedge clk or posedge rst)begin 
	if (rst) begin 
		inst3_out <= 18'b0;
		
		rd3_out <= 5'b0;
		write_on_rd3_out <= 1'b0;
		
		BID3out <= 2'b00;
		partofbranch3out <=1'b0;
		
		is_branch3_out <= 1'b0; 
		
		control_decode_out3 <= 1'b0;
		imm3_decode_out <= 1'b0;
	end 
	else if(flush_branch_Miss)begin
		inst3_out <= 18'b0;
		
		rd3_out <= 5'b0;
		write_on_rd3_out <= 1'b0;
		
		BID3out <= 2'b00;
		partofbranch3out <=1'b0;
		
		is_branch3_out <= 1'b0; 
		
		control_decode_out3 <= 1'b0;
		imm3_decode_out <= 1'b0;
	end
	else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS | mt_stall)begin
		inst3_out<=inst3_out;
		partofbranch3out <=partofbranch3out;
		rd3_out <= rd3_out;
		write_on_rd3_out <= write_on_rd3_out;
		
		BID3out <= BID3out;
		
		is_branch3_out <= is_branch3_out; 

		
		control_decode_out3 <= control_decode_out3;
		imm3_decode_out <= imm3_decode_out;
	end
	
	else if(stall_branch_priority_table | stall_frpools)begin
		inst3_out <= 18'b0;
		
		rd3_out <= 5'b0;
		write_on_rd3_out <= 1'b0;
		
		BID3out <= 2'b00;
		partofbranch3out <=1'b0;
		
		is_branch3_out <= 1'b0; 
		
		control_decode_out3 <= 1'b0;
		imm3_decode_out <= 1'b0;
	
	end
	else begin 
		inst3_out<=inst3_in;
		partofbranch3out <=partofbranch3in;
		rd3_out <= rd3_in;
		write_on_rd3_out <= write_on_rd3_in;
		
		BID3out <= BID3in;
		
		is_branch3_out <= is_branch3_in; 

		
		control_decode_out3 <= control_decode_3;
		imm3_decode_out <= imm3_decode;
	end
end 
	
	
	// valid 
always@(posedge clk or posedge rst)begin 
	if (rst) begin 
		valid_word_out <= 4'b0;
	end 
	else if(flush_branch_Miss)begin
		valid_word_out <= 4'b0;	
	end
	else if(stall_reservation_station)begin
		valid_word_out <= valid_word_out;
	end 
	else if(stall_reservation_station_LS | ROB_stall | mt_stall)begin
		valid_word_out <= valid_word_out;
	end
	else if(stall_branch_priority_table | stall_frpools )begin
		valid_word_out <= 4'b0;
	end
	else begin 
		valid_word_out <= valid_word_in;
	end
end 
	
endmodule
	