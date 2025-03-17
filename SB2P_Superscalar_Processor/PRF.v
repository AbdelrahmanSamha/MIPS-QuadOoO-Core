module PRF(
	input clk,reset,

  input [32:0] ALU0writedata,ALU1writedata,ALU2writedata,LSU0writedata,LSU1writedata,//data to be written execute stage
  input [5:0]  WriteAddress0,WriteAddress1,WriteAddress2,WriteAddress4,WriteAddress5 , // address to write to execute stage 
  input [63:0] recovery_mt,
  input [63:0] current_state_frpool,
  input hit, is_branch_ES,
    
  // scheduling stage inputs are indicies
  input  [5:0] ReadAddress_Alu0_s1,ReadAddress_Alu0_s2, ReadAddress_Alu1_s1,ReadAddress_Alu1_s2,
  input  [5:0] ReadAddress_Alu2_s1,ReadAddress_Alu2_s2,
  input  [5:0] ReadAddress_Bu_s1,ReadAddress_Bu_s2, 
  input  [5:0] ReadAddress_Lsu0_Rt, ReadAddress_Lsu0_Rs, ReadAddress_Lsu1_Rt, ReadAddress_Lsu1_Rs, // Address to be read from 
  input [5:0]RA_V0, RA_V1, RA_V2, RA_V3, RA_V4, RA_V5, RA_V6, RA_V7, RA_V8, RA_V9, RA_V10, RA_V11, RA_V12, RA_V13, RA_V14, RA_V15, RA_V16, RA_V17, RA_V18, RA_V19, RA_V20, RA_V21, RA_V22, RA_V23, RA_V24, RA_V25, RA_V26, RA_V27,
  //this output is to the schedule stage
  
  //========COMMIT STAGE indecies to commit==========//
  input [5:0] commit_index0, commit_index1, commit_index2, commit_index3,
  
  //========reservation station valid bits==========//
  output reg RA_V0_out, RA_V1_out, RA_V2_out, RA_V3_out, RA_V4_out, RA_V5_out, RA_V6_out, RA_V7_out, RA_V8_out, RA_V9_out,RA_V10_out, RA_V11_out, RA_V12_out, RA_V13_out, RA_V14_out, RA_V15_out, RA_V16_out, RA_V17_out, RA_V18_out, RA_V19_out, RA_V20_out, RA_V21_out, RA_V22_out, RA_V23_out, RA_V24_out, RA_V25_out, RA_V26_out, RA_V27_out,
  
  //========read stage outputs======================//
  output reg [31:0] Alu0_s1,Alu0_s2,Alu1_s1,Alu1_s2,Alu2_s1,Alu2_s2,Bu_s1,Bu_s2,Lsu0_Rt,Lsu0_Rs,Lsu1_Rt,Lsu1_Rs,  //  Data to be read from 
  
  //========COMMITED VALUES=========================//
  output reg [31:0] commit_value0, commit_value1, commit_value2, commit_value3,
	
   input 		all_done, 
	input 		PNR0, PNR1, PNR2, PNR3,
	input [5:0] return_stale0, return_stale1, return_stale2, return_stale3,
     
   input [5:0] jr_index_fs,
	input valid_index_rat_in,
	
	output [10:0] jr_address_prf,
	output valid_index_prf_out
	
  );
	reg [32:0] PRF_reg [63:0];

	
	
	wire [63:0] status_xor;

	
	//recovery ... ~a & b 
	assign status_xor = (recovery_mt ^ current_state_frpool);//a

	reg [9:0] jr_address;
   reg jr_valid;
 
always @(posedge clk,posedge reset)begin :PRF_section
		integer i;
    if (reset) begin
			for (i = 0; i < 64; i = i + 1) begin
				PRF_reg[i] <= (i < 32) ? {1'b1, 32'b0} : {1'b0, 32'b0};
			end
		end
		else begin
			// recovery
			if (is_branch_ES & !hit) begin 
					PRF_reg[0][32]  <= (~status_xor[0])  & PRF_reg[0][32];  
					PRF_reg[1][32]  <= (~status_xor[1])  & PRF_reg[1][32];  
					PRF_reg[2][32]  <= (~status_xor[2])  & PRF_reg[2][32];  
					PRF_reg[3][32]  <= (~status_xor[3])  & PRF_reg[3][32];  
					PRF_reg[4][32]  <= (~status_xor[4])  & PRF_reg[4][32];  
					PRF_reg[5][32]  <= (~status_xor[5])  & PRF_reg[5][32];  
					PRF_reg[6][32]  <= (~status_xor[6])  & PRF_reg[6][32];  
					PRF_reg[7][32]  <= (~status_xor[7])  & PRF_reg[7][32];  
					PRF_reg[8][32]  <= (~status_xor[8])  & PRF_reg[8][32];  
					PRF_reg[9][32]  <= (~status_xor[9])  & PRF_reg[9][32];  
					PRF_reg[10][32] <= (~status_xor[10]) & PRF_reg[10][32];  
					PRF_reg[11][32] <= (~status_xor[11]) & PRF_reg[11][32];  
					PRF_reg[12][32] <= (~status_xor[12]) & PRF_reg[12][32];  
					PRF_reg[13][32] <= (~status_xor[13]) & PRF_reg[13][32];  
					PRF_reg[14][32] <= (~status_xor[14]) & PRF_reg[14][32];  
					PRF_reg[15][32] <= (~status_xor[15]) & PRF_reg[15][32];  
					PRF_reg[16][32] <= (~status_xor[16]) & PRF_reg[16][32];  
					PRF_reg[17][32] <= (~status_xor[17]) & PRF_reg[17][32];  
					PRF_reg[18][32] <= (~status_xor[18]) & PRF_reg[18][32];  
					PRF_reg[19][32] <= (~status_xor[19]) & PRF_reg[19][32];  
					PRF_reg[20][32] <= (~status_xor[20]) & PRF_reg[20][32];  
					PRF_reg[21][32] <= (~status_xor[21]) & PRF_reg[21][32];  
					PRF_reg[22][32] <= (~status_xor[22]) & PRF_reg[22][32];  
					PRF_reg[23][32] <= (~status_xor[23]) & PRF_reg[23][32];  
					PRF_reg[24][32] <= (~status_xor[24]) & PRF_reg[24][32];  
					PRF_reg[25][32] <= (~status_xor[25]) & PRF_reg[25][32];  
					PRF_reg[26][32] <= (~status_xor[26]) & PRF_reg[26][32];  
					PRF_reg[27][32] <= (~status_xor[27]) & PRF_reg[27][32];  
					PRF_reg[28][32] <= (~status_xor[28]) & PRF_reg[28][32];  
					PRF_reg[29][32] <= (~status_xor[29]) & PRF_reg[29][32];  
					PRF_reg[30][32] <= (~status_xor[30]) & PRF_reg[30][32];  
					PRF_reg[31][32] <= (~status_xor[31]) & PRF_reg[31][32];  
					PRF_reg[32][32] <= (~status_xor[32]) & PRF_reg[32][32];  
					PRF_reg[33][32] <= (~status_xor[33]) & PRF_reg[33][32];  
					PRF_reg[34][32] <= (~status_xor[34]) & PRF_reg[34][32];  
					PRF_reg[35][32] <= (~status_xor[35]) & PRF_reg[35][32];  
					PRF_reg[36][32] <= (~status_xor[36]) & PRF_reg[36][32];  
					PRF_reg[37][32] <= (~status_xor[37]) & PRF_reg[37][32];  
					PRF_reg[38][32] <= (~status_xor[38]) & PRF_reg[38][32];  
					PRF_reg[39][32] <= (~status_xor[39]) & PRF_reg[39][32];  
					PRF_reg[40][32] <= (~status_xor[40]) & PRF_reg[40][32];  
					PRF_reg[41][32] <= (~status_xor[41]) & PRF_reg[41][32];  
					PRF_reg[42][32] <= (~status_xor[42]) & PRF_reg[42][32];  
					PRF_reg[43][32] <= (~status_xor[43]) & PRF_reg[43][32];  
					PRF_reg[44][32] <= (~status_xor[44]) & PRF_reg[44][32];  
					PRF_reg[45][32] <= (~status_xor[45]) & PRF_reg[45][32];  
					PRF_reg[46][32] <= (~status_xor[46]) & PRF_reg[46][32];  
					PRF_reg[47][32] <= (~status_xor[47]) & PRF_reg[47][32];  
					PRF_reg[48][32] <= (~status_xor[48]) & PRF_reg[48][32];  
					PRF_reg[49][32] <= (~status_xor[49]) & PRF_reg[49][32];  
					PRF_reg[50][32] <= (~status_xor[50]) & PRF_reg[50][32];  
					PRF_reg[51][32] <= (~status_xor[51]) & PRF_reg[51][32];  
					PRF_reg[52][32] <= (~status_xor[52]) & PRF_reg[52][32];  
					PRF_reg[53][32] <= (~status_xor[53]) & PRF_reg[53][32];  
					PRF_reg[54][32] <= (~status_xor[54]) & PRF_reg[54][32];  
					PRF_reg[55][32] <= (~status_xor[55]) & PRF_reg[55][32];  
					PRF_reg[56][32] <= (~status_xor[56]) & PRF_reg[56][32];  
					PRF_reg[57][32] <= (~status_xor[57]) & PRF_reg[57][32];  
					PRF_reg[58][32] <= (~status_xor[58]) & PRF_reg[58][32];  
					PRF_reg[59][32] <= (~status_xor[59]) & PRF_reg[59][32];  
					PRF_reg[60][32] <= (~status_xor[60]) & PRF_reg[60][32];  
					PRF_reg[61][32] <= (~status_xor[61]) & PRF_reg[61][32];  
					PRF_reg[62][32] <= (~status_xor[62]) & PRF_reg[62][32];  
					PRF_reg[63][32] <= (~status_xor[63]) & PRF_reg[63][32];  
			end
			if(ALU0writedata[32])begin
				PRF_reg[WriteAddress0] <= ALU0writedata;
			end
			if(ALU1writedata[32])begin
				PRF_reg[WriteAddress1] <= ALU1writedata;
			end
			if(ALU2writedata[32])begin
				PRF_reg[WriteAddress2] <= ALU2writedata;
			end
			
			if(LSU0writedata[32])begin
				PRF_reg[WriteAddress4] <= LSU0writedata;
			end
			if(LSU1writedata[32])begin
				PRF_reg[WriteAddress5] <= LSU1writedata;
				
			// stales must be retured to be invalid in the PRF so that no other instrucitons assume them as their source...	
			end
			if(all_done)begin 
				if(PNR0) PRF_reg[return_stale0][32] <= 1'b0;
				if(PNR1) PRF_reg[return_stale1][32] <= 1'b0; 
				if(PNR2) PRF_reg[return_stale2][32] <= 1'b0; 
				if(PNR3) PRF_reg[return_stale3][32] <= 1'b0;
			end 

		end	
	end
	
	
  always@(*)begin
			 Alu0_s1 =  PRF_reg[ReadAddress_Alu0_s1][31:0];
			 Alu0_s2 =  PRF_reg[ReadAddress_Alu0_s2][31:0];
			 Alu1_s1 =  PRF_reg[ReadAddress_Alu1_s1][31:0];
			 Alu1_s2 =  PRF_reg[ReadAddress_Alu1_s2][31:0];
			 Alu2_s1 =  PRF_reg[ReadAddress_Alu2_s1][31:0];
			 Alu2_s2 =  PRF_reg[ReadAddress_Alu2_s2][31:0];
			 Bu_s1   =  PRF_reg[ReadAddress_Bu_s1][31:0];
			 Bu_s2   =  PRF_reg[ReadAddress_Bu_s2][31:0];
			 Lsu0_Rt =  PRF_reg[ReadAddress_Lsu0_Rt][31:0];
			 Lsu0_Rs =  PRF_reg[ReadAddress_Lsu0_Rs][31:0];
			 Lsu1_Rt =  PRF_reg[ReadAddress_Lsu1_Rt][31:0];
			 Lsu1_Rs =  PRF_reg[ReadAddress_Lsu1_Rs][31:0];
			 
			 RA_V0_out  = PRF_reg[RA_V0][32];
			 RA_V1_out  = PRF_reg[RA_V1][32];
			 RA_V2_out  = PRF_reg[RA_V2][32];
			 RA_V3_out  = PRF_reg[RA_V3][32];
			 RA_V4_out  = PRF_reg[RA_V4][32];
			 RA_V5_out  = PRF_reg[RA_V5][32];
			 RA_V6_out  = PRF_reg[RA_V6][32];
			 RA_V7_out  = PRF_reg[RA_V7][32];
			 RA_V8_out  = PRF_reg[RA_V8][32];
			 RA_V9_out  = PRF_reg[RA_V9][32];
			 RA_V10_out = PRF_reg[RA_V10][32];
			 RA_V11_out = PRF_reg[RA_V11][32];
			 RA_V12_out = PRF_reg[RA_V12][32];
			 RA_V13_out = PRF_reg[RA_V13][32];
			 RA_V14_out = PRF_reg[RA_V14][32];
			 RA_V15_out = PRF_reg[RA_V15][32];
			 RA_V16_out = PRF_reg[RA_V16][32];
			 RA_V17_out = PRF_reg[RA_V17][32];
			 RA_V18_out = PRF_reg[RA_V18][32];
			 RA_V19_out = PRF_reg[RA_V19][32];
			 RA_V20_out = PRF_reg[RA_V20][32];
			 RA_V21_out = PRF_reg[RA_V21][32];
			 RA_V22_out = PRF_reg[RA_V22][32];
			 RA_V23_out = PRF_reg[RA_V23][32];
			 RA_V24_out = PRF_reg[RA_V24][32];
			 RA_V25_out = PRF_reg[RA_V25][32];
			 RA_V26_out = PRF_reg[RA_V26][32];
			 RA_V27_out = PRF_reg[RA_V27][32];
			 
			 
			 commit_value0 = PRF_reg[commit_index0][31:0];
			 commit_value1 = PRF_reg[commit_index1][31:0];
			 commit_value2 = PRF_reg[commit_index2][31:0];
			 commit_value3 = PRF_reg[commit_index3][31:0];
			 
			 jr_address =  PRF_reg[jr_index_fs][9:0];
			 
			 jr_valid = PRF_reg[jr_index_fs][32];
			 

  end

  assign jr_address_prf = {jr_valid, jr_address};
  assign valid_index_prf_out = (valid_index_rat_in) ? 1'b1 : 1'b0; 
  
endmodule