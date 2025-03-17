module rename_stage (
	rst, clk,
	//input way0 
	instruction0_18b,
		iswrite0,
		matchd0_d1, matchd0_d2, matchd0_d3,
		match0_rs1a, match0_rs1b, match0_rs2a, match0_rs2b, match0_rs3a ,match0_rs3b,
		new_allocate_rd0,
		opcode0, 
		imm0,
		ROBentry0,
		isBranch0,
		BID0,
	//input way1
	instruction1_18b,
		iswrite1,
		matchd1_d2, matchd1_d3,
		match1_rs2a, match1_rs2b, match1_rs3a, match1_rs3b,
		new_allocate_rd1,
		opcode1, 
		imm1,
		ROBentry1,
		isBranch1,
		BID1,
	//input way2
   instruction2_18b, 
		iswrite2,
		matchd2_d3,
		match2_rs3a, match2_rs3b,
		new_allocate_rd2,
		opcode2, 
		imm2,
		ROBentry2,
		isBranch2,
		BID2,
	//input way3 
	instruction3_18b,
		iswrite3,
		new_allocate_rd3,
		opcode3, 
		imm3,
		ROBentry3,
		isBranch3,
		BID3,
	//output way0
	writeEn_way0, allocate_rd0,
	
	//output way1
	allocate_rd1,
	writeEn_way1,
	
	//output way2
	allocate_rd2,
	writeEn_way2,
	
	//output way3
	allocate_rd3,
	writeEn_way3,
	
	//sorting_unit 
	valid_word,
	
	status,
	
	updated_status,
	
	write_index0, write_index1, write_index2, write_index3,
	 
   write_data0, write_data1, write_data2, write_data3,
							
	write_enable0_rsv, write_enable1_rsv , write_enable2_rsv, write_enable3_rsv,
	
	
	write_enable0_rsv_lw_sw, write_enable1_rsv_lw_sw, write_enable2_rsv_lw_sw, write_enable3_rsv_lw_sw,
	
	
	//stale physical registers
	
	stale_inst0,stale_inst1, stale_inst2, stale_inst3,
	stall,mt_stall,
	is_store0,is_store1,is_store2,is_store3, 
	
	BIDs_flush,
	
	is_branch_exe,
	
	hit,
	
	stall_frpools,
	stall_allocate_rd0, stall_allocate_rd1, stall_allocate_rd2, stall_allocate_rd3,
	ROB_stall,
	
   stall_reservation_station_LS,
	
	out0_fr_is_zero,
	out1_fr_is_zero,
	out2_fr_is_zero,
	out3_fr_is_zero,
	BID0_temp,BID1_temp,BID2_temp,BID3_temp

);

	input rst, clk;
	
	input [6:0] BIDs_flush;
	
	input mt_stall;
	input ROB_stall;
   input stall_reservation_station_LS;


	
	//way0 inputs
	input [17:0] instruction0_18b;
	input iswrite0,isBranch0, matchd0_d1, matchd0_d2, matchd0_d3, match0_rs1a, match0_rs1b, match0_rs2a, match0_rs2b, match0_rs3a ,match0_rs3b; //way0 input 
	input [5:0] opcode0;
	input[15:0] imm0;
	input [4:0]ROBentry0;
	input [1:0] BID0;
	//way1 input
	input [17:0]instruction1_18b;
	input iswrite1,isBranch1, matchd1_d2, matchd1_d3, match1_rs2a, match1_rs2b, match1_rs3a, match1_rs3b; //way1 input
	input [5:0] opcode1;
	input[15:0] imm1;
	input [4:0]ROBentry1;
	input [1:0] BID1;
	//way2 inputs
	input [17:0]instruction2_18b;
	input iswrite2,isBranch2, matchd2_d3, match2_rs3a, match2_rs3b; //way2 input 
	input [5:0]opcode2; 
	input [15:0] imm2;
	input [4:0]ROBentry2;
	input [1:0] BID2;
	
	input [17:0] instruction3_18b;
	input iswrite3,isBranch3; //way3 input
	input [5:0]opcode3; 
	input [15:0] imm3;
	input [4:0]ROBentry3;
	input [1:0] BID3;
	
	input [9:0] updated_status;
	//outputs 
	output [5:0] stale_inst0,stale_inst1, stale_inst2, stale_inst3;
	output is_store0,is_store1,is_store2,is_store3;
	

	//free list input
	input [5:0] new_allocate_rd0, new_allocate_rd1, new_allocate_rd2, new_allocate_rd3; //free list input
	//Rigester alias table writeEN signals & values
	output reg [5:0] allocate_rd0, allocate_rd1, allocate_rd2, allocate_rd3; 
	output writeEn_way0,writeEn_way1,writeEn_way2,writeEn_way3;
	
   input is_branch_exe;
	
	input hit;
	
	output stall_frpools;
	
	output wire stall_allocate_rd0, stall_allocate_rd1, stall_allocate_rd2, stall_allocate_rd3;

	input out0_fr_is_zero;
	input out1_fr_is_zero;
	input out2_fr_is_zero;
	input out3_fr_is_zero;
	
	
	assign writeEn_way0 = iswrite0 & ~(matchd0_d1 && iswrite1)  & ~(matchd0_d2 && iswrite2) & ~(matchd0_d3 && iswrite3) ;
	assign writeEn_way1 = iswrite1 & ~(matchd1_d2 && iswrite2)  & ~(matchd1_d3 && iswrite3); 
	assign writeEn_way2 = iswrite2 & ~(matchd2_d3 && iswrite3); 
	assign writeEn_way3 = iswrite3;
	
	
	wire [5:0] inst0_rd,inst0_rs1,inst0_rs2;
	wire [5:0] inst1_rd,inst1_rs1,inst1_rs2;
	wire [5:0] inst2_rd,inst2_rs1,inst2_rs2;
	wire [5:0] inst3_rd,inst3_rs1,inst3_rs2;
	
	assign inst0_rd  = instruction0_18b[17:12];
	assign inst0_rs1 = instruction0_18b[11:6];
	assign inst0_rs2 = instruction0_18b[5:0];
	
	assign inst1_rd  = instruction1_18b[17:12];
	assign inst1_rs1 = instruction1_18b[11:6];
	assign inst1_rs2 = instruction1_18b[5:0];
	
	assign inst2_rd  = instruction2_18b[17:12];
	assign inst2_rs1 = instruction2_18b[11:6];
	assign inst2_rs2 = instruction2_18b[5:0];
	
	assign inst3_rd  = instruction3_18b[17:12];
	assign inst3_rs1 = instruction3_18b[11:6];
	assign inst3_rs2 = instruction3_18b[5:0];
	
	
	
	
	
	wire [40:0] new_inst0,new_inst1,new_inst2,new_inst3;
	
	// Way 0
	wire  is_Itype0;	
	assign is_Itype0 = (opcode0[4] | isBranch0);
	assign is_store0 = (opcode0[3:0] == 4'b1110) ? 1'b1 : 1'b0;
	
	wire Pdestsel0; 
	assign Pdestsel0 = (is_store0 | isBranch0);
		
	// Way 1
	wire  is_Itype1;
	assign is_Itype1 = (opcode1[4] | isBranch1);
	assign is_store1 = (opcode1[3:0] == 4'b1110) ? 1'b1 : 1'b0;
	
	wire Pdestsel1; 
	assign Pdestsel1 = (is_store1 | isBranch1);
	
	// Way 2 
	wire  is_Itype2;
	assign is_Itype2 = (opcode2[4] | isBranch2);
	assign is_store2 = (opcode2[3:0] == 4'b1110) ? 1'b1 : 1'b0;
	
	wire Pdestsel2; 
	assign Pdestsel2 = (is_store2 | isBranch2);
	
	// Way 3
	wire  is_Itype3;
	assign is_Itype3 = (opcode3[4] | isBranch3);
	assign is_store3 = (opcode3[3:0] == 4'b1110) ? 1'b1 : 1'b0;
	
	wire Pdestsel3; 
	assign Pdestsel3 = (is_store3 | isBranch3);
	
	///////////////////////////////////////////////////////////////////////////////insutrction assembly///////////////////////////////////////////////////////
	//way0 instruction assembly 
	/*
	[40:36] ROB 5bits
	[35:34] BID 2bits
	[33:28] opcode 6bits
	[27:22] dest 6 bits 
	[21:16] rs1 6 bits //rs
	[15:0] imm or [15:10] rs2 //rt
	
	*/
	output [1:0] BID0_temp;
	
	assign BID0_temp = (BIDs_flush[6] && BIDs_flush[BID0] ) ? BIDs_flush[5:4] : BID0;
	
	
	wire [5:0] physical_destination0;
	wire [15:0] inst0_secondoperand, ins0_source2;
	assign ins0_source2 = {inst0_rs2,10'b0};
	
	mux2 #(16)  immORreg0(.in0(ins0_source2),.in1(imm0), .sel(is_Itype0),.out(inst0_secondoperand)); // selector for this is is_Itype
	
	mux2 #(6) Pdest0 (.in0(allocate_rd0),.in1(inst0_rd), .sel(Pdestsel0),.out(physical_destination0)); //selector for this is is_store||is_branch
	
	assign new_inst0 = {ROBentry0,BID0_temp,opcode0,physical_destination0,inst0_rs1,inst0_secondoperand};
	
	
	
	//way1 instruction assembly 
	
	
	output [1:0] BID1_temp;
	
	assign BID1_temp = (BIDs_flush[6] && BIDs_flush[BID1] ) ? BIDs_flush[5:4] : BID1;
	
	wire [5:0] physical_destination1, match0_rs1aOUT, match0_rs1bOUT;
	wire [15:0] inst1_secondoperand, match0_rs1b_extended;
	assign match0_rs1b_extended = {match0_rs1bOUT,10'b0};
	wire matchd0_d1_iswrite0 ;
	assign matchd0_d1_iswrite0 = iswrite0 & matchd0_d1;
	wire [5:0] dependencywithBr_Sw_way0way1;
	
	mux2 #(6) match0_rs1amux (.in0(inst1_rs1),.in1(allocate_rd0), .sel(match0_rs1a),.out(match0_rs1aOUT));
	mux2 #(6) match0_rs1bmux (.in0(inst1_rs2),.in1(allocate_rd0), .sel(match0_rs1b),.out(match0_rs1bOUT));
	
	mux2 #(6) dependencywithBr_Sw_way0way1mux (.in0(inst1_rd) , .in1(allocate_rd0), .sel(matchd0_d1_iswrite0), .out(dependencywithBr_Sw_way0way1));
	
	mux2 #(16) immORreg1 (.in0(match0_rs1b_extended),.in1(imm1), .sel(is_Itype1),.out(inst1_secondoperand));  // selector for this is is_Itype
	mux2 #(6) Pdest1 (.in0(allocate_rd1),.in1(dependencywithBr_Sw_way0way1), .sel(Pdestsel1),.out(physical_destination1)) ;//selector for this is is_store||is_branch
	
	assign new_inst1 = {ROBentry1,BID1_temp, opcode1, physical_destination1, match0_rs1aOUT, inst1_secondoperand};
	
	
	
	
	//way2 instruction assembly 
	
	output [1:0] BID2_temp;
	
	assign BID2_temp = (BIDs_flush[6] && BIDs_flush[BID2] ) ? BIDs_flush[5:4] : BID2;
	
	wire [5:0] match0_rs2aOUT, match0_rs2bOUT,match1_rs2aOUT,match1_rs2bOUT;
	wire [5:0] physical_destination2;
	
	wire [15:0] inst2_sourceoperand, match1_rs2b_extended;
	assign match1_rs2b_extended = {match1_rs2bOUT,10'b0};
	
	wire matchd0_d2_iswrite0;
	wire matchd1_d2_iswrite1;
	assign matchd0_d2_iswrite0 = iswrite0 & matchd0_d2;
	assign matchd1_d2_iswrite1 = iswrite1 & matchd1_d2;
	wire [5:0] dependencywithBr_Sw_way0way2, dependencywithBr_Sw_way1way2;
	
	mux2 #(6)  match0_rs2amux(.in0(inst2_rs1),.in1(allocate_rd0), .sel(match0_rs2a),.out(match0_rs2aOUT));
	mux2 #(6)  match0_rs2bmux(.in0(inst2_rs2),.in1(allocate_rd0), .sel(match0_rs2b),.out(match0_rs2bOUT));
	
	mux2 #(6)  match1_rs2amux (.in0(match0_rs2aOUT),.in1(allocate_rd1), .sel(match1_rs2a),.out(match1_rs2aOUT));
	mux2 #(6)  match1_rs2bmux (.in0(match0_rs2bOUT),.in1(allocate_rd1), .sel(match1_rs2b),.out(match1_rs2bOUT));
	
	mux2 #(6) dependencywithBr_Sw_way0way2mux(.in0(inst2_rd) , .in1(allocate_rd0), .sel(matchd0_d2_iswrite0), .out(dependencywithBr_Sw_way0way2));
	mux2 #(6) dependencywithBr_Sw_way1way2mux(.in0(dependencywithBr_Sw_way0way2) , .in1(allocate_rd1), .sel(matchd1_d2_iswrite1), .out(dependencywithBr_Sw_way1way2));
	
	
	mux2 #(6)  Pdest2(.in0(allocate_rd2),.in1(dependencywithBr_Sw_way1way2), .sel(Pdestsel2),.out(physical_destination2));  //selector for this is is_store||is_branch
	
	mux2 #(16)  immORreg2 (.in0(match1_rs2b_extended),.in1(imm2), .sel(is_Itype2),.out(inst2_sourceoperand)); // selector for this is is_Itype
	
	assign new_inst2 = {ROBentry2,BID2_temp ,opcode2, physical_destination2 , match1_rs2aOUT ,inst2_sourceoperand };
	
	
	
	
	//way3 instruction assmebly 
	
	output [1:0] BID3_temp;
	
	assign BID3_temp = (BIDs_flush[6] && BIDs_flush[BID3] ) ? BIDs_flush[5:4] : BID3;
	
	
	wire[5:0]match0_rs3aOUT,match0_rs3bOUT,match1_rs3aOUT,match1_rs3bOUT,match2_rs3aOUT,match2_rs3bOUT;
	wire[5:0]physical_destination3;
	wire [15:0]inst3_sourceoperand,match2_rs3b_extended;
	assign match2_rs3b_extended = {match2_rs3bOUT,10'b0};
	
	wire matchd0_d3_iswrite0;
	wire matchd1_d3_iswrite1;
	wire matchd2_d3_iswrite2; 
	assign matchd0_d3_iswrite0 = iswrite0 & matchd0_d3;
	assign matchd1_d3_iswrite1 = iswrite1 & matchd1_d3;
	assign matchd2_d3_iswrite2 = iswrite2 & matchd2_d3;
	
	wire [5:0] dependencywithBr_Sw_way0way3, dependencywithBr_Sw_way1way3, dependencywithBr_Sw_way2way3 ;
	
	mux2 #(6)  match0_rs3amux(.in0(inst3_rs1),.in1(allocate_rd0), .sel(match0_rs3a),.out(match0_rs3aOUT));
	mux2 #(6)  match0_rs3bmux(.in0(inst3_rs2),.in1(allocate_rd0), .sel(match0_rs3b),.out(match0_rs3bOUT));
	
	mux2 #(6)  match1_rs3amux(.in0(match0_rs3aOUT),.in1(allocate_rd1), .sel(match1_rs3a),.out(match1_rs3aOUT));
	mux2 #(6)  match1_rs3bmux(.in0(match0_rs3bOUT),.in1(allocate_rd1), .sel(match1_rs3b),.out(match1_rs3bOUT));
	
	mux2 #(6)  match2_rs3amux(.in0(match1_rs3aOUT),.in1(allocate_rd2), .sel(match2_rs3a),.out(match2_rs3aOUT));
	mux2 #(6)  match2_rs3bmux(.in0(match1_rs3bOUT),.in1(allocate_rd2), .sel(match2_rs3b),.out(match2_rs3bOUT));
	
	mux2 #(6) dependencywithBr_Sw_way0way3mux(.in0(inst3_rd) , .in1(allocate_rd0), .sel(matchd0_d3_iswrite0), .out(dependencywithBr_Sw_way0way3));
	mux2 #(6) dependencywithBr_Sw_way1way3mux(.in0(dependencywithBr_Sw_way0way3) , .in1(allocate_rd1), .sel(matchd1_d3_iswrite1), .out(dependencywithBr_Sw_way1way3));
	mux2 #(6) dependencywithBr_Sw_way2way3mux(.in0(dependencywithBr_Sw_way1way3) , .in1(allocate_rd2), .sel(matchd2_d3_iswrite2), .out(dependencywithBr_Sw_way2way3));
	
	mux2 #(6)  Pdest3(.in0(allocate_rd3),.in1(dependencywithBr_Sw_way2way3), .sel(Pdestsel3),.out(physical_destination3));	  //selector for this is is_store||is_branch
	mux2 #(16) immORreg3 (.in0(match2_rs3b_extended),.in1(imm3), .sel(is_Itype3),.out(inst3_sourceoperand));  // selector for this is is_Itype
	
	
	assign new_inst3 = {ROBentry3, BID3_temp,opcode3,physical_destination3,match2_rs3aOUT,inst3_sourceoperand};
	
	
	
	wire [5:0] matchd0_d2OUT;
	
	//way0 stale
	assign stale_inst0 = inst0_rd;
	//way1 stale
	mux2 #(6) matchd0_d1mux (.in0(inst1_rd),.in1(allocate_rd0), .sel(matchd0_d1),.out(stale_inst1));
	
	//way2 stale
	mux2 #(6) matchd0_d2mux (.in0(inst2_rd),.in1(allocate_rd0), .sel(matchd0_d2),.out(matchd0_d2OUT));
	mux2 #(6) matchd1_d2mux (.in0(matchd0_d2OUT),.in1(allocate_rd1), .sel(matchd1_d2),.out(stale_inst2));
	
	//way3 stale 
	wire [5:0] matchd0_d3OUT,matchd1_d3OUT;
	mux2 #(6)  matchd0_d3mux (.in0(inst3_rd),.in1(allocate_rd0), .sel(matchd0_d3),.out(matchd0_d3OUT));
	mux2 #(6)  matchd1_d3mux (.in0(matchd0_d3OUT),.in1(allocate_rd1), .sel(matchd1_d3),.out(matchd1_d3OUT));
	mux2 #(6)  matchd2_d3mux (.in0(matchd1_d3OUT),.in1(allocate_rd2), .sel(matchd2_d3),.out(stale_inst3));
	
	
	
	//////////////////////////////////EHAB 
	
	// sorting_unit
	
	input [3:0] valid_word;
	
	input [9:0] status;
	
	wire [1:0] sel0, sel1, sel2,sel3;
	 
	wire in_zero_enc10_0 ,in_zero_enc10_1, in_zero_enc10_2 , in_zero_enc10_3;

	wire in_zero_enc4_0 ,in_zero_enc4_1, in_zero_enc4_2 , in_zero_enc4_3;

	output stall;
	
	output [3:0] write_index0, write_index1, write_index2, write_index3;
	 
   output [40:0] write_data0, write_data1, write_data2, write_data3;
							
	output write_enable0_rsv, write_enable1_rsv , write_enable2_rsv, write_enable3_rsv;
	
	output write_enable0_rsv_lw_sw, write_enable1_rsv_lw_sw, write_enable2_rsv_lw_sw, write_enable3_rsv_lw_sw;
	
	wire [9:0] status_rename;
							  
	//assign status_rename = status | updated_status;
	// sorting_unit
	
	priority_encoders_4in encoder_4in(
    .in(valid_word),   // 4-bit input
    .pos0(sel0),
	 .pos1(sel1), 
	 .pos2(sel2), 
	 .pos3(sel3),
	 .in_zero_enc4_0(in_zero_enc4_0),
	 .in_zero_enc4_1(in_zero_enc4_1),
	 .in_zero_enc4_2(in_zero_enc4_2),
	 .in_zero_enc4_3(in_zero_enc4_3) 
);

	
	priority_encoders_10in encoder_10in(
    .in(status),   // 10-bit input
    .pos0(write_index0),
	 .pos1(write_index1), 
	 .pos2(write_index2), 
	 .pos3(write_index3),
	 .in_zero_enc10_0(in_zero_enc10_0),
	 .in_zero_enc10_1(in_zero_enc10_1), 
	 .in_zero_enc10_2(in_zero_enc10_2),
	 .in_zero_enc10_3(in_zero_enc10_3)
);


		
	// stall signal 
	wire [5:0] sw_inst = 6'h1e; // inst_type = 00  
	wire [5:0] lw_inst = 6'h1d; // inst_type = 00

	
	assign stall = ((!in_zero_enc4_0 & in_zero_enc10_0) |  
						(!in_zero_enc4_1 & in_zero_enc10_1) |
						(!in_zero_enc4_2 & in_zero_enc10_2) |
						(!in_zero_enc4_3 & in_zero_enc10_3)) ? 1'b1 : 1'b0;// check 1'b1 : 1'b0;
	
	
wire [5:0] opcode_write_data0, opcode_write_data1, opcode_write_data2,opcode_write_data3;

assign opcode_write_data0 = write_data0[33:28];
assign opcode_write_data1 = write_data1[33:28];
assign opcode_write_data2 = write_data2[33:28];
assign opcode_write_data3 = write_data3[33:28];


	
	
	 assign write_enable0_rsv = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data0 == sw_inst | opcode_write_data0 == lw_inst) ? 1'b0 : ~(in_zero_enc4_0);
 	 assign write_enable1_rsv = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data1 == sw_inst | opcode_write_data1 == lw_inst) ? 1'b0 : ~(in_zero_enc4_1);
	 assign write_enable2_rsv = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data2 == sw_inst | opcode_write_data2 == lw_inst) ? 1'b0 : ~(in_zero_enc4_2);
	 assign write_enable3_rsv = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data3 == sw_inst | opcode_write_data3 == lw_inst) ? 1'b0 : ~(in_zero_enc4_3);
	
		
	mux4 #(41) mux0(.in0(new_inst0),.in1(new_inst1),.in2(new_inst2),.in3(new_inst3),.sel(sel0),.out(write_data0));
	
	mux4 #(41) mux1(.in0(new_inst0),.in1(new_inst1),.in2(new_inst2),.in3(new_inst3),.sel(sel1),.out(write_data1));
	
	mux4 #(41) mux2(.in0(new_inst0),.in1(new_inst1),.in2(new_inst2),.in3(new_inst3),.sel(sel2),.out(write_data2));
	
	mux4 #(41) mux3(.in0(new_inst0),.in1(new_inst1),.in2(new_inst2),.in3(new_inst3),.sel(sel3),.out(write_data3));
	

	
	
	// sorting_lw_sw
	assign write_enable0_rsv_lw_sw = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data0 == sw_inst | opcode_write_data0 == lw_inst) ? ~(in_zero_enc4_0) : 1'b0 ;
	assign write_enable1_rsv_lw_sw = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data1 == sw_inst | opcode_write_data1 == lw_inst) ? ~(in_zero_enc4_1) : 1'b0 ;
	assign write_enable2_rsv_lw_sw = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data2 == sw_inst | opcode_write_data2 == lw_inst) ? ~(in_zero_enc4_2) : 1'b0 ;
	assign write_enable3_rsv_lw_sw = (stall || mt_stall || (!hit && is_branch_exe)) ? 1'b0 : (opcode_write_data3 == sw_inst | opcode_write_data3 == lw_inst) ? ~(in_zero_enc4_3) : 1'b0 ;
	
	

	
	
	// Stall the FRPools if either the new allocation or the allocated register has a value of zero,
	// indicating that no free physical registers are available in one or more FRPools.
	// The stall signal will remain active until all FRPools can provide a free register,
	// ensuring that no instruction incorrectly uses a physical register with a value of zero.
	// flush the idid2 pipe ... stall ifid pipe
		
	
	
	
		assign stall_frpools =  (stall_allocate_rd0 | stall_allocate_rd1 | stall_allocate_rd2 | stall_allocate_rd3) ? 1'b1 : 1'b0; 
				

					
		assign stall_allocate_rd0 = ((out0_fr_is_zero)) ? 1'b1 : 1'b0;
		assign stall_allocate_rd1 = ((out1_fr_is_zero)) ? 1'b1 : 1'b0; 
		assign stall_allocate_rd2 = ((out2_fr_is_zero)) ? 1'b1 : 1'b0; 
		assign stall_allocate_rd3 = ((out3_fr_is_zero)) ? 1'b1 : 1'b0; 
		 
		 
		 
//**** Note: "stall" is the same as "stall_reservation_station" ****
		
	
		//mt_stall
		///////////////////////////////////////////////////////////////////ALLOCATE DEST REGISTERS///////////////////////////////////////////////////////////

	always @(posedge clk or posedge rst) begin
		if (rst) begin
				allocate_rd0 <= 6'd32;
		end
		else if ((!iswrite0 && stall_allocate_rd0) | stall | ROB_stall | mt_stall | stall_reservation_station_LS | (!hit && is_branch_exe) ) begin 
				allocate_rd0 <= allocate_rd0;
		end 
		else if (iswrite0 | (allocate_rd0 == 6'b0) ) begin
					allocate_rd0 <= new_allocate_rd0;
		end
		else begin
					allocate_rd0 <= allocate_rd0;
		end
	end




	always @(posedge clk or posedge rst) begin
		if (rst) begin
				allocate_rd1 <= 6'd33;
		end
		else if ((!iswrite1 && stall_allocate_rd1) | stall | ROB_stall | mt_stall | stall_reservation_station_LS | (!hit && is_branch_exe) ) begin 
				allocate_rd1 <= allocate_rd1;
		end 
		else if (iswrite1  | (allocate_rd1 == 6'b0) ) begin
					allocate_rd1 <= new_allocate_rd1;
		end
		else begin
					allocate_rd1 <= allocate_rd1;
		end
	end


			
			
	always @(posedge clk or posedge rst) begin
		if (rst) begin
				allocate_rd2 <= 6'd34;
		end
		else if ((!iswrite2 && stall_allocate_rd2) |stall | ROB_stall | mt_stall | stall_reservation_station_LS | (!hit && is_branch_exe) ) begin 
				allocate_rd2 <= allocate_rd2;
		end 
		else if (iswrite2  | (allocate_rd2 == 6'b0) ) begin
					allocate_rd2 <= new_allocate_rd2;
		end
		else begin
					allocate_rd2 <= allocate_rd2;
		end
	end
		
		
		
	always @(posedge clk or posedge rst) begin
		if (rst) begin
				allocate_rd3 <= 6'd35;
		end
		else if ((!iswrite3 && stall_allocate_rd3) |stall | ROB_stall | mt_stall | stall_reservation_station_LS | (!hit && is_branch_exe) ) begin 
				allocate_rd3 <= allocate_rd3;
		end 
		else if (iswrite3  | (allocate_rd3 == 6'b0) ) begin
					allocate_rd3 <= new_allocate_rd3;
		end
		else begin
					allocate_rd3 <= allocate_rd3;
		end
	end
			
endmodule



