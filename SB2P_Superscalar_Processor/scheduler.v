module scheduler(
		
		input [40:0] ARTins0, ARTins1, ARTins2, ARTins3, ARTins4, ARTins5, ARTins6,ARTins7, ARTins8, ARTins9,
		input [9:0] ARTstatus,
		input rs0validsource1, rs0validsource2,
		input rs1validsource1, rs1validsource2,
		input rs2validsource1, rs2validsource2,
		input rs3validsource1, rs3validsource2,
		input rs4validsource1, rs4validsource2,
		input rs5validsource1, rs5validsource2,
		input rs6validsource1, rs6validsource2,
		input rs7validsource1, rs7validsource2,
		input rs8validsource1, rs8validsource2,
		input rs9validsource1, rs9validsource2,
		input [5:0] FU0 ,FU1,FU2, LSU0, LSU1,
		input [5:0] FU0_readstage, FU1_readstage, FU2_readstage,LSU0_readstage, LSU1_readstage,
		input [6:0] BIDs_flush,
		input stall_LS,
		output[9:0] new_ready_arithmetic,
		output[50:0] dispatched_alu0, dispatched_alu1,dispatched_alu2, dispatched_bu
		
);

reg [9:0] flushed_arith;
wire [9:0] dispatched_status;

assign new_ready_arithmetic = flushed_arith | dispatched_status; 

//---------------------------------------------------------------------
// Instance 0: rs_ready0
//---------------------------------------------------------------------
wire [5:0]  ins0_s1, ins0_s2;
wire [15:0]imm0;
wire is_itype0;

wire is_branch0;

wire is_ready0, is_forward0_rs1,is_forward0_rs2;
wire [1:0] ART0_s1_alu_selectormux ,ART0_s2_alu_selectormux ,ART0_s1_lsu_selectormux , ART0_s2_lsu_selectormux;


assign ins0_s1 = ARTins0[21:16];
assign ins0_s2 = (is_branch0)? ARTins0[27:22]: ARTins0[15:10];
assign imm0 = ARTins0[15:0];
assign is_itype0 = (ARTins0[32] | (ARTins0[33:32] == 2'b11));///if 11 its JR and must be treated as I type
 
assign is_branch0 = ARTins0[33];
reg is_empty0;

wire [1:0]BID0_temp;
assign BID0_temp = ARTins0[35:34];

	always @(*) begin
		is_empty0 = ARTstatus[0];
		flushed_arith[0] = 1'b0;
		if (!BIDs_flush[6] && BIDs_flush[BID0_temp]) begin 
			is_empty0 =1'b1;
			flushed_arith[0] = 1'b1;
		end
	end
	
wire [1:0] BID0; 
	assign BID0 =  (BIDs_flush[6] && BIDs_flush[BID0_temp])? BIDs_flush[5:4] : BID0_temp; 

ArithmeticRSREADY rs_ready0 (
    // Input ports
    .rs1index(ins0_s1),
    .rs2index(ins0_s2),
    .rs1valid(rs0validsource1),//PRF 
    .rs2valid(rs0validsource2),//PRF
    .empty(is_empty0),
    .is_itype(is_itype0),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready0),
    .selector_for_s1_ALUmux(ART0_s1_alu_selectormux),//2b
    .selector_for_s1_LSUmux(ART0_s1_lsu_selectormux),//2b
    .rs1forward(is_forward0_rs1),//1b
    .selector_for_s2_ALUmux(ART0_s2_alu_selectormux),//2b
    .selector_for_s2_LSUmux(ART0_s2_lsu_selectormux),//2b
    .rs2forward(is_forward0_rs2)//1b
);
/*
50:46 ROB
45:44 BID
43:38 opcode
37:32 dest
31:26 s1 
25:24 aluselmuxs1
23:22 aluselmuxs2
21:20 lsuselmuxs1
19:18 lseselmuxs2
17 isforwards1
16 isforwards2
15:10 s2 or 15:0 imm
*/

wire [50:0] ART_ins0_afterprocessing;  //ROB				//BID	 //opcode		 //dest
assign ART_ins0_afterprocessing = 		{ARTins0[40:36],BID0	 ,ARTins0[33:28],ARTins0[27:22],
													
													ins0_s1, ART0_s1_alu_selectormux, ART0_s2_alu_selectormux, ART0_s1_lsu_selectormux, ART0_s2_lsu_selectormux,
													is_forward0_rs1,is_forward0_rs2,imm0};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 
//---------------------------------------------------------------------
// Instance 1: rs_ready1
//---------------------------------------------------------------------
wire [5:0]  ins1_s1, ins1_s2;
wire [15:0] imm1;
wire is_itype1;
reg is_empty1;
wire is_branch1;

wire is_ready1, is_forward1_rs1, is_forward1_rs2;
wire [1:0] ART1_s1_alu_selectormux, ART1_s2_alu_selectormux, ART1_s1_lsu_selectormux, ART1_s2_lsu_selectormux;

assign ins1_s1 = ARTins1[21:16];
assign ins1_s2 = (is_branch1)? ARTins1[27:22] : ARTins1[15:10];
assign imm1 = ARTins1[15:0];
assign is_itype1 =(ARTins1[32] | (ARTins1[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch1 = ARTins1[33];

wire [1:0] BID1_temp;
assign BID1_temp = ARTins1[35:34];

always @(*) begin
    is_empty1 = ARTstatus[1];
    flushed_arith[1] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID1_temp]) begin 
        is_empty1 = 1'b1;
        flushed_arith[1] = 1'b1;
    end
end

wire [1:0] BID1; 
assign BID1 = (BIDs_flush[6] && BIDs_flush[BID1_temp]) ? BIDs_flush[5:4] : BID1_temp;

	
	
ArithmeticRSREADY rs_ready1 (
    // Input ports
    .rs1index(ins1_s1),
    .rs2index(ins1_s2),
    .rs1valid(rs1validsource1), // PRF
    .rs2valid(rs1validsource2), // PRF
    .empty(is_empty1),
    .is_itype(is_itype1),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
	 
    // Output ports
    .ready(is_ready1),
    .selector_for_s1_ALUmux(ART1_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART1_s1_lsu_selectormux),
    .rs1forward(is_forward1_rs1),
    .selector_for_s2_ALUmux(ART1_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART1_s2_lsu_selectormux),
    .rs2forward(is_forward1_rs2)
);
wire [50:0] ART_ins1_afterprocessing;
assign ART_ins1_afterprocessing = {ARTins1[40:36],BID1, ARTins1[33:28], ARTins1[27:22],
                                   ins1_s1, ART1_s1_alu_selectormux, ART1_s2_alu_selectormux, ART1_s1_lsu_selectormux, ART1_s2_lsu_selectormux,
                                   is_forward1_rs1, is_forward1_rs2, imm1};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 

//---------------------------------------------------------------------
// Instance 2: rs_ready2
//---------------------------------------------------------------------
wire [5:0]  ins2_s1, ins2_s2;
wire [15:0] imm2;
wire is_itype2;
reg is_empty2;
wire is_branch2;

wire is_ready2, is_forward2_rs1, is_forward2_rs2;
wire [1:0] ART2_s1_alu_selectormux, ART2_s2_alu_selectormux, ART2_s1_lsu_selectormux, ART2_s2_lsu_selectormux;

assign ins2_s1 = ARTins2[21:16];
assign ins2_s2 = (is_branch2)? ARTins2[27:22]:ARTins2[15:10];
assign imm2 = ARTins2[15:0];
assign is_itype2 =(ARTins2[32] | (ARTins2[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch2 = ARTins2[33];


// Index 2
wire [1:0] BID2_temp;
assign BID2_temp = ARTins2[35:34];

always @(*) begin
    is_empty2 = ARTstatus[2];
    flushed_arith[2] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID2_temp]) begin 
        is_empty2 = 1'b1;
        flushed_arith[2] = 1'b1;
    end
end

wire [1:0] BID2; 
assign BID2 = (BIDs_flush[6] && BIDs_flush[BID2_temp]) ? BIDs_flush[5:4] : BID2_temp;

ArithmeticRSREADY rs_ready2 (
    // Input ports
    .rs1index(ins2_s1),
    .rs2index(ins2_s2),
    .rs1valid(rs2validsource1), // PRF
    .rs2valid(rs2validsource2), // PRF
    .empty(is_empty2),
    .is_itype(is_itype2),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready2),
    .selector_for_s1_ALUmux(ART2_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART2_s1_lsu_selectormux),
    .rs1forward(is_forward2_rs1),
    .selector_for_s2_ALUmux(ART2_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART2_s2_lsu_selectormux),
    .rs2forward(is_forward2_rs2)
);
wire [50:0] ART_ins2_afterprocessing;
assign ART_ins2_afterprocessing = {ARTins2[40:36],BID2, ARTins2[33:28], ARTins2[27:22],
                                   ins2_s1, ART2_s1_alu_selectormux, ART2_s2_alu_selectormux, ART2_s1_lsu_selectormux, ART2_s2_lsu_selectormux,
                                   is_forward2_rs1, is_forward2_rs2, imm2};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 
//---------------------------------------------------------------------
// Instance 3: rs_ready3
//---------------------------------------------------------------------
wire [5:0]  ins3_s1, ins3_s2;
wire [15:0] imm3;
wire is_itype3;
reg is_empty3;
wire is_branch3;

wire is_ready3, is_forward3_rs1, is_forward3_rs2;
wire [1:0] ART3_s1_alu_selectormux, ART3_s2_alu_selectormux, ART3_s1_lsu_selectormux, ART3_s2_lsu_selectormux;

assign ins3_s1 = ARTins3[21:16];
assign ins3_s2 = (is_branch3)? ARTins3[27:22]:ARTins3[15:10];
assign imm3 = ARTins3[15:0];
assign is_itype3 =(ARTins3[32] | (ARTins3[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch3 = ARTins3[33];

// Index 3
wire [1:0] BID3_temp;
assign BID3_temp = ARTins3[35:34];

always @(*) begin
    is_empty3 = ARTstatus[3];
    flushed_arith[3] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID3_temp]) begin 
        is_empty3 = 1'b1;
        flushed_arith[3] = 1'b1;
    end
end

wire [1:0] BID3; 
assign BID3 = (BIDs_flush[6] && BIDs_flush[BID3_temp]) ? BIDs_flush[5:4] : BID3_temp;

ArithmeticRSREADY rs_ready3 (
    // Input ports
    .rs1index(ins3_s1),
    .rs2index(ins3_s2),
    .rs1valid(rs3validsource1), // PRF
    .rs2valid(rs3validsource2), // PRF
    .empty(is_empty3),
    .is_itype(is_itype3),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
    // Output ports
    .ready(is_ready3),
    .selector_for_s1_ALUmux(ART3_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART3_s1_lsu_selectormux),
    .rs1forward(is_forward3_rs1),
    .selector_for_s2_ALUmux(ART3_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART3_s2_lsu_selectormux),
    .rs2forward(is_forward3_rs2)
);
wire [50:0] ART_ins3_afterprocessing;
assign ART_ins3_afterprocessing = {ARTins3[40:36],BID3, ARTins3[33:28], ARTins3[27:22],
                                   ins3_s1, ART3_s1_alu_selectormux, ART3_s2_alu_selectormux, ART3_s1_lsu_selectormux, ART3_s2_lsu_selectormux,
                                   is_forward3_rs1, is_forward3_rs2, imm3};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 

//---------------------------------------------------------------------
// Instance 4: rs_ready4
//---------------------------------------------------------------------
wire [5:0]  ins4_s1, ins4_s2;
wire [15:0] imm4;
wire is_itype4;
reg is_empty4;
wire is_branch4;

wire is_ready4, is_forward4_rs1, is_forward4_rs2;
wire [1:0] ART4_s1_alu_selectormux, ART4_s2_alu_selectormux, ART4_s1_lsu_selectormux, ART4_s2_lsu_selectormux;

assign ins4_s1 = ARTins4[21:16];
assign ins4_s2 = (is_branch4)? ARTins4[27:22]:ARTins4[15:10];
assign imm4 = ARTins4[15:0];
assign is_itype4 =(ARTins4[32] | (ARTins4[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch4 = ARTins4[33];

// Index 4
wire [1:0] BID4_temp;
assign BID4_temp = ARTins4[35:34];

always @(*) begin
    is_empty4 = ARTstatus[4];
    flushed_arith[4] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID4_temp]) begin 
        is_empty4 = 1'b1;
        flushed_arith[4] = 1'b1;
    end
end

wire [1:0] BID4; 
assign BID4 = (BIDs_flush[6] && BIDs_flush[BID4_temp]) ? BIDs_flush[5:4] : BID4_temp;

ArithmeticRSREADY rs_ready4 (
    // Input ports
    .rs1index(ins4_s1),
    .rs2index(ins4_s2),
    .rs1valid(rs4validsource1), // PRF
    .rs2valid(rs4validsource2), // PRF
    .empty(is_empty4),
    .is_itype(is_itype4),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready4),
    .selector_for_s1_ALUmux(ART4_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART4_s1_lsu_selectormux),
    .rs1forward(is_forward4_rs1),
    .selector_for_s2_ALUmux(ART4_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART4_s2_lsu_selectormux),
    .rs2forward(is_forward4_rs2)
);
wire [50:0] ART_ins4_afterprocessing;
assign ART_ins4_afterprocessing = {ARTins4[40:36],BID4, ARTins4[33:28], ARTins4[27:22],
                                   ins4_s1, ART4_s1_alu_selectormux, ART4_s2_alu_selectormux, ART4_s1_lsu_selectormux, ART4_s2_lsu_selectormux,
                                   is_forward4_rs1, is_forward4_rs2, imm4};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 


//---------------------------------------------------------------------
// Instance 5: rs_ready5
//---------------------------------------------------------------------
wire [5:0]  ins5_s1, ins5_s2;
wire [15:0] imm5;
wire is_itype5;
reg is_empty5;
wire is_branch5;

wire is_ready5, is_forward5_rs1, is_forward5_rs2;
wire [1:0] ART5_s1_alu_selectormux, ART5_s2_alu_selectormux, ART5_s1_lsu_selectormux, ART5_s2_lsu_selectormux;

assign ins5_s1 = ARTins5[21:16];
assign ins5_s2 = (is_branch5)? ARTins5[27:22]:ARTins5[15:10];
assign imm5 = ARTins5[15:0];
assign is_itype5 =(ARTins5[32] | (ARTins5[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch5 = ARTins5[33];

// Index 5
wire [1:0] BID5_temp;
assign BID5_temp = ARTins5[35:34];

always @(*) begin
    is_empty5 = ARTstatus[5];
    flushed_arith[5] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID5_temp]) begin 
        is_empty5 = 1'b1;
        flushed_arith[5] = 1'b1;
    end
end

wire [1:0] BID5; 
assign BID5 = (BIDs_flush[6] && BIDs_flush[BID5_temp]) ? BIDs_flush[5:4] : BID5_temp;

ArithmeticRSREADY rs_ready5 (
    // Input ports
    .rs1index(ins5_s1),
    .rs2index(ins5_s2),
    .rs1valid(rs5validsource1), // PRF
    .rs2valid(rs5validsource2), // PRF
    .empty(is_empty5),
    .is_itype(is_itype5),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
   
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready5),
    .selector_for_s1_ALUmux(ART5_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART5_s1_lsu_selectormux),
    .rs1forward(is_forward5_rs1),
    .selector_for_s2_ALUmux(ART5_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART5_s2_lsu_selectormux),
    .rs2forward(is_forward5_rs2)
);
wire [50:0] ART_ins5_afterprocessing;
assign ART_ins5_afterprocessing = {ARTins5[40:36],BID5, ARTins5[33:28], ARTins5[27:22],
                                   ins5_s1, ART5_s1_alu_selectormux, ART5_s2_alu_selectormux, ART5_s1_lsu_selectormux, ART5_s2_lsu_selectormux,
                                   is_forward5_rs1, is_forward5_rs2, imm5};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 

//---------------------------------------------------------------------
// Instance 6: rs_ready6
//---------------------------------------------------------------------
wire [5:0]  ins6_s1, ins6_s2;
wire [15:0] imm6;
wire is_itype6;
reg is_empty6;
wire is_branch6;

wire is_ready6, is_forward6_rs1, is_forward6_rs2;
wire [1:0] ART6_s1_alu_selectormux, ART6_s2_alu_selectormux, ART6_s1_lsu_selectormux, ART6_s2_lsu_selectormux;

assign ins6_s1 = ARTins6[21:16];
assign ins6_s2 = (is_branch6)? ARTins6[27:22]:ARTins6[15:10];
assign imm6 = ARTins6[15:0];
assign is_itype6 =(ARTins6[32] | (ARTins6[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch6 = ARTins6[33];

// Index 6
wire [1:0] BID6_temp;
assign BID6_temp = ARTins6[35:34];

always @(*) begin
    is_empty6 = ARTstatus[6];
    flushed_arith[6] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID6_temp]) begin 
        is_empty6 = 1'b1;
        flushed_arith[6] = 1'b1;
    end
end

wire [1:0] BID6; 
assign BID6 = (BIDs_flush[6] && BIDs_flush[BID6_temp]) ? BIDs_flush[5:4] : BID6_temp;

ArithmeticRSREADY rs_ready6 (
    // Input ports
    .rs1index(ins6_s1),
    .rs2index(ins6_s2),
    .rs1valid(rs6validsource1), // PRF
    .rs2valid(rs6validsource2), // PRF
    .empty(is_empty6),
    .is_itype(is_itype6),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready6),
    .selector_for_s1_ALUmux(ART6_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART6_s1_lsu_selectormux),
    .rs1forward(is_forward6_rs1),
    .selector_for_s2_ALUmux(ART6_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART6_s2_lsu_selectormux),
    .rs2forward(is_forward6_rs2)
);
wire [50:0] ART_ins6_afterprocessing;
assign ART_ins6_afterprocessing = {ARTins6[40:36],BID6, ARTins6[33:28], ARTins6[27:22],
                                   ins6_s1, ART6_s1_alu_selectormux, ART6_s2_alu_selectormux, ART6_s1_lsu_selectormux, ART6_s2_lsu_selectormux,
                                   is_forward6_rs1, is_forward6_rs2, imm6};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 

//---------------------------------------------------------------------
// Instance 7: rs_ready7
//---------------------------------------------------------------------
wire [5:0]  ins7_s1, ins7_s2;
wire [15:0] imm7;
wire is_itype7;
reg is_empty7;
wire is_branch7;

wire is_ready7, is_forward7_rs1, is_forward7_rs2;
wire [1:0] ART7_s1_alu_selectormux, ART7_s2_alu_selectormux, ART7_s1_lsu_selectormux, ART7_s2_lsu_selectormux;

assign ins7_s1 = ARTins7[21:16];
assign ins7_s2 = (is_branch7)? ARTins7[27:22]:ARTins7[15:10];
assign imm7 = ARTins7[15:0];
assign is_itype7 =(ARTins7[32] | (ARTins7[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch7 = ARTins7[33];

// Index 7
wire [1:0] BID7_temp;
assign BID7_temp = ARTins7[35:34];

always @(*) begin
    is_empty7 = ARTstatus[7];
    flushed_arith[7] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID7_temp]) begin 
        is_empty7 = 1'b1;
        flushed_arith[7] = 1'b1;
    end
end

wire [1:0] BID7; 
assign BID7 = (BIDs_flush[6] && BIDs_flush[BID7_temp]) ? BIDs_flush[5:4] : BID7_temp;

ArithmeticRSREADY rs_ready7 (
    // Input ports
    .rs1index(ins7_s1),
    .rs2index(ins7_s2),
    .rs1valid(rs7validsource1), // PRF
    .rs2valid(rs7validsource2), // PRF
    .empty(is_empty7),
    .is_itype(is_itype7),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready7),
    .selector_for_s1_ALUmux(ART7_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART7_s1_lsu_selectormux),
    .rs1forward(is_forward7_rs1),
    .selector_for_s2_ALUmux(ART7_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART7_s2_lsu_selectormux),
    .rs2forward(is_forward7_rs2)
);
wire [50:0] ART_ins7_afterprocessing;
assign ART_ins7_afterprocessing = {ARTins7[40:36],BID7, ARTins7[33:28], ARTins7[27:22],
                                   ins7_s1, ART7_s1_alu_selectormux, ART7_s2_alu_selectormux, ART7_s1_lsu_selectormux, ART7_s2_lsu_selectormux,
                                   is_forward7_rs1, is_forward7_rs2, imm7};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 


//---------------------------------------------------------------------
// Instance 8: rs_ready8
//---------------------------------------------------------------------
wire [5:0]  ins8_s1, ins8_s2;
wire [15:0] imm8;
wire is_itype8;
reg is_empty8;
wire is_branch8;

wire is_ready8, is_forward8_rs1, is_forward8_rs2;
wire [1:0] ART8_s1_alu_selectormux, ART8_s2_alu_selectormux, ART8_s1_lsu_selectormux, ART8_s2_lsu_selectormux;

assign ins8_s1 = ARTins8[21:16];
assign ins8_s2 = (is_branch8)? ARTins8[27:22]:ARTins8[15:10];
assign imm8 = ARTins8[15:0];
assign is_itype8 =(ARTins8[32] | (ARTins8[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch8 = ARTins8[33];

// Index 8
wire [1:0] BID8_temp;
assign BID8_temp = ARTins8[35:34];

always @(*) begin
    is_empty8 = ARTstatus[8];
    flushed_arith[8] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID8_temp]) begin 
        is_empty8 = 1'b1;
        flushed_arith[8] = 1'b1;
    end
end

wire [1:0] BID8; 
assign BID8 = (BIDs_flush[6] && BIDs_flush[BID8_temp]) ? BIDs_flush[5:4] : BID8_temp;

ArithmeticRSREADY rs_ready8 (
    //Input ports
    .rs1index(ins8_s1),
    .rs2index(ins8_s2),
    .rs1valid(rs8validsource1), // PRF
    .rs2valid(rs8validsource2), // PRF
    .empty(is_empty8),
    .is_itype(is_itype8),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready8),
    .selector_for_s1_ALUmux(ART8_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART8_s1_lsu_selectormux),
    .rs1forward(is_forward8_rs1),
    .selector_for_s2_ALUmux(ART8_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART8_s2_lsu_selectormux),
    .rs2forward(is_forward8_rs2)
);
wire [50:0] ART_ins8_afterprocessing;
assign ART_ins8_afterprocessing = {ARTins8[40:36],BID8, ARTins8[33:28], ARTins8[27:22],
                                   ins8_s1, ART8_s1_alu_selectormux, ART8_s2_alu_selectormux, ART8_s1_lsu_selectormux, ART8_s2_lsu_selectormux,
                                   is_forward8_rs1, is_forward8_rs2, imm8};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 
//---------------------------------------------------------------------
// Instance 9: rs_ready9
//---------------------------------------------------------------------
wire [5:0]  ins9_s1, ins9_s2;
wire [15:0] imm9;
wire is_itype9;
reg is_empty9;
wire is_branch9;

wire is_ready9, is_forward9_rs1, is_forward9_rs2;
wire [1:0] ART9_s1_alu_selectormux, ART9_s2_alu_selectormux, ART9_s1_lsu_selectormux, ART9_s2_lsu_selectormux;

assign ins9_s1 = ARTins9[21:16];
assign ins9_s2 = (is_branch9)? ARTins9[27:22]:ARTins9[15:10];
assign imm9 = ARTins9[15:0];
assign is_itype9 =(ARTins9[32] | (ARTins9[33:32] == 2'b11));///if 11 its JR and must be treated as I type

assign is_branch9 = ARTins9[33];

// Index 9
wire [1:0] BID9_temp;
assign BID9_temp = ARTins9[35:34];

always @(*) begin
    is_empty9 = ARTstatus[9];
    flushed_arith[9] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID9_temp]) begin 
        is_empty9 = 1'b1;
        flushed_arith[9] = 1'b1;
    end
end

wire [1:0] BID9; 
assign BID9 = (BIDs_flush[6] && BIDs_flush[BID9_temp]) ? BIDs_flush[5:4] : BID9_temp;

ArithmeticRSREADY rs_ready9 (
    // Input ports
    .rs1index(ins9_s1),
    .rs2index(ins9_s2),
    .rs1valid(rs9validsource1), // PRF
    .rs2valid(rs9validsource2), // PRF
    .empty(is_empty9),
    .is_itype(is_itype9),
    .FU0(FU0),//current dest in the execute stage
    .FU1(FU1),
    .FU2(FU2),
    
    .LSU0(LSU0),
    .LSU1(LSU1),
    .FU0_readstage(FU0_readstage),
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 
    // Output ports
    .ready(is_ready9),
    .selector_for_s1_ALUmux(ART9_s1_alu_selectormux),
    .selector_for_s1_LSUmux(ART9_s1_lsu_selectormux),
    .rs1forward(is_forward9_rs1),
    .selector_for_s2_ALUmux(ART9_s2_alu_selectormux),
    .selector_for_s2_LSUmux(ART9_s2_lsu_selectormux),
    .rs2forward(is_forward9_rs2)
);
wire [50:0] ART_ins9_afterprocessing;
assign ART_ins9_afterprocessing = {ARTins9[40:36],BID9, ARTins9[33:28], ARTins9[27:22],
                                   ins9_s1, ART9_s1_alu_selectormux, ART9_s2_alu_selectormux, ART9_s1_lsu_selectormux, ART9_s2_lsu_selectormux,
                                   is_forward9_rs1, is_forward9_rs2, imm9};// we take only the imm, the second source operand will embeded in the 6MSB bits if it was R-type. 


//////////////////////////////////////////////////////////////////////5 mux selectors for the ALUS and BU////////////////////////////////////////

wire [3:0] bu_selector , alu0selector, alu1selector, alu2selector;

wire [9:0] is_ready;
assign is_ready = (stall_LS) ? 10'b0 : {is_ready9,is_ready8,is_ready7,is_ready6,is_ready5,is_ready4,is_ready3,is_ready2,is_ready1,is_ready0};
ArithmeticScheduler u_ArithmeticScheduler (
    .ready0(is_ready[0]), .ready1(is_ready[1]), .ready2(is_ready[2]), .ready3(is_ready[3]),
    .ready4(is_ready[4]), .ready5(is_ready[5]), .ready6(is_ready[6]), .ready7(is_ready[7]),
    .ready8(is_ready[8]), .ready9(is_ready[9]),
    .isbranch0(is_branch0), .isbranch1(is_branch1), .isbranch2(is_branch2), .isbranch3(is_branch3),
    .isbranch4(is_branch4), .isbranch5(is_branch5), .isbranch6(is_branch6), .isbranch7(is_branch7),
    .isbranch8(is_branch8), .isbranch9(is_branch9),
	 .current_status(ARTstatus),
    .sel_branch(bu_selector), .sel0(alu0selector), .sel1(alu1selector), .sel2(alu2selector),
    .ready(dispatched_status)
);

/////////////////////////////////////////////////////////////////////the 5 muxes for the ALUs and BU////////////////////////////////////////
MUX11to1 #(51) ALU0MUX (
    .in0(ART_ins0_afterprocessing), .in1(ART_ins1_afterprocessing), .in2(ART_ins2_afterprocessing),
    .in3(ART_ins3_afterprocessing), .in4(ART_ins4_afterprocessing), .in5(ART_ins5_afterprocessing),
    .in6(ART_ins6_afterprocessing), .in7(ART_ins7_afterprocessing), .in8(ART_ins8_afterprocessing),
    .in9(ART_ins9_afterprocessing),
    .sel(alu0selector), 
    .out(dispatched_alu0)
);

MUX11to1 #(51) ALU1MUX (
    .in0(ART_ins0_afterprocessing), .in1(ART_ins1_afterprocessing), .in2(ART_ins2_afterprocessing),
    .in3(ART_ins3_afterprocessing), .in4(ART_ins4_afterprocessing), .in5(ART_ins5_afterprocessing),
    .in6(ART_ins6_afterprocessing), .in7(ART_ins7_afterprocessing), .in8(ART_ins8_afterprocessing),
    .in9(ART_ins9_afterprocessing),  
    .sel(alu1selector), 
    .out(dispatched_alu1)
);

MUX11to1 #(51) ALU2MUX (
    .in0(ART_ins0_afterprocessing), .in1(ART_ins1_afterprocessing), .in2(ART_ins2_afterprocessing),
    .in3(ART_ins3_afterprocessing), .in4(ART_ins4_afterprocessing), .in5(ART_ins5_afterprocessing),
    .in6(ART_ins6_afterprocessing), .in7(ART_ins7_afterprocessing), .in8(ART_ins8_afterprocessing),
    .in9(ART_ins9_afterprocessing), 
    .sel(alu2selector), 
    .out(dispatched_alu2)
);



MUX11to1 #(51) BUMUX (
    .in0(ART_ins0_afterprocessing), .in1(ART_ins1_afterprocessing), .in2(ART_ins2_afterprocessing),
    .in3(ART_ins3_afterprocessing), .in4(ART_ins4_afterprocessing), .in5(ART_ins5_afterprocessing),
    .in6(ART_ins6_afterprocessing), .in7(ART_ins7_afterprocessing), .in8(ART_ins8_afterprocessing),
    .in9(ART_ins9_afterprocessing), 
    .sel(bu_selector), 
    .out(dispatched_bu)
);

/*task automatic print_ART_table;
    integer i;
    reg [50:0] art_ins;
    reg Isready;
    reg is_itype;
    reg is_branch;
    integer s2_imm_value;
    begin
        // Print table header
		  $display("FU0: %0d | FU1: %0d | FU2: %0d | FU0_READ: %0d | FU1_READ: %0d | FU2_READ: %0d", FU0, FU1, FU2, FU0_readstage, FU1_readstage, FU2_readstage);
        $display("alu0selector: %0d | alu1selector: %0d | alu2selector: %0d | bu_selector: %0d", 
                alu0selector, alu1selector, alu2selector, bu_selector);
        $display("-------------------------------------------------------------------------------------------------------------------------------");
        $display("Index | ROB  | BID | Opcode | Dest | S1  | ALUS1 | ALUS2 | LSUS1 | LSUS2 | F1 | F2 | S2/Imm  | Rdy | I-type | Branch");
        $display("-------------------------------------------------------------------------------------------------------------------------------");
        
        // Print each instruction entry
        for (i = 0; i < 10; i = i + 1) begin
            case(i)
                0: begin art_ins = ART_ins0_afterprocessing; is_itype = is_itype0; Isready = is_ready[0]; is_branch = is_branch0; end
                1: begin art_ins = ART_ins1_afterprocessing; is_itype = is_itype1; Isready = is_ready[1]; is_branch = is_branch1; end
                2: begin art_ins = ART_ins2_afterprocessing; is_itype = is_itype2; Isready = is_ready[2]; is_branch = is_branch2; end
                3: begin art_ins = ART_ins3_afterprocessing; is_itype = is_itype3; Isready = is_ready[3]; is_branch = is_branch3; end
                4: begin art_ins = ART_ins4_afterprocessing; is_itype = is_itype4; Isready = is_ready[4]; is_branch = is_branch4; end
                5: begin art_ins = ART_ins5_afterprocessing; is_itype = is_itype5; Isready = is_ready[5]; is_branch = is_branch5; end
                6: begin art_ins = ART_ins6_afterprocessing; is_itype = is_itype6; Isready = is_ready[6]; is_branch = is_branch6; end
                7: begin art_ins = ART_ins7_afterprocessing; is_itype = is_itype7; Isready = is_ready[7]; is_branch = is_branch7; end
                8: begin art_ins = ART_ins8_afterprocessing; is_itype = is_itype8; Isready = is_ready[8]; is_branch = is_branch8; end
                9: begin art_ins = ART_ins9_afterprocessing; is_itype = is_itype9; Isready = is_ready[9]; is_branch = is_branch9; end
            endcase

            // Calculate S2/Imm value
            if (is_itype) begin
                s2_imm_value = $signed(art_ins[15:0]);  // Signed immediate for I-type
            end else begin
                s2_imm_value = art_ins[15:10];          // Unsigned S2 for R-type
            end

            // Print fields in decimal
            $display("%5d | %4d | %3d | %6d | %4d | %3d | %5d | %5d | %5d | %5d | %2d | %2d | %6d | %2d | %6d | %6d",
                i,
                art_ins[50:46],  // ROB
                art_ins[45:44],  // BID
                art_ins[43:38],  // Opcode
                art_ins[37:32],  // Dest
                art_ins[31:26],  // S1
                art_ins[25:24],  // ALUSelMuxS1
                art_ins[23:22],  // ALUSelMuxS2
                art_ins[21:20],  // LSUSelMuxS1
                art_ins[19:18],  // LSUSelMuxS2
                art_ins[17],     // ForwardS1
                art_ins[16],     // ForwardS2
                s2_imm_value,    // S2/Imm
                Isready,         // Ready status
                is_itype,        // I-type flag
                is_branch        // Branch flag
            );
        end
        $display("-------------------------------------------------------------------------------------------------------------------------------");
    end
endtask*/
task automatic print_ART_table(input integer file);
    integer i;
    reg [50:0] art_ins;
    reg Isready;
    reg is_itype;
    reg is_branch;
    integer s2_imm_value;
    begin
        // Print table header
        $fwrite(file, "FU0: %0d | FU1: %0d | FU2: %0d | FU0_READ: %0d | FU1_READ: %0d | FU2_READ: %0d\n", FU0, FU1, FU2, FU0_readstage, FU1_readstage, FU2_readstage);
        $fwrite(file, "alu0selector: %0d | alu1selector: %0d | alu2selector: %0d | bu_selector: %0d\n", 
                alu0selector, alu1selector, alu2selector, bu_selector);
        $fwrite(file, "-------------------------------------------------------------------------------------------------------------------------------\n");
        $fwrite(file, "Index | ROB  | BID | Opcode | Dest | S1  | ALUS1 | ALUS2 | LSUS1 | LSUS2 | F1 | F2 | S2/Imm  | Rdy | I-type | Branch\n");
        $fwrite(file, "-------------------------------------------------------------------------------------------------------------------------------\n");
        
        // Print each instruction entry
        for (i = 0; i < 10; i = i + 1) begin
            case(i)
                0: begin art_ins = ART_ins0_afterprocessing; is_itype = is_itype0; Isready = is_ready[0]; is_branch = is_branch0; end
                1: begin art_ins = ART_ins1_afterprocessing; is_itype = is_itype1; Isready = is_ready[1]; is_branch = is_branch1; end
                2: begin art_ins = ART_ins2_afterprocessing; is_itype = is_itype2; Isready = is_ready[2]; is_branch = is_branch2; end
                3: begin art_ins = ART_ins3_afterprocessing; is_itype = is_itype3; Isready = is_ready[3]; is_branch = is_branch3; end
                4: begin art_ins = ART_ins4_afterprocessing; is_itype = is_itype4; Isready = is_ready[4]; is_branch = is_branch4; end
                5: begin art_ins = ART_ins5_afterprocessing; is_itype = is_itype5; Isready = is_ready[5]; is_branch = is_branch5; end
                6: begin art_ins = ART_ins6_afterprocessing; is_itype = is_itype6; Isready = is_ready[6]; is_branch = is_branch6; end
                7: begin art_ins = ART_ins7_afterprocessing; is_itype = is_itype7; Isready = is_ready[7]; is_branch = is_branch7; end
                8: begin art_ins = ART_ins8_afterprocessing; is_itype = is_itype8; Isready = is_ready[8]; is_branch = is_branch8; end
                9: begin art_ins = ART_ins9_afterprocessing; is_itype = is_itype9; Isready = is_ready[9]; is_branch = is_branch9; end
            endcase
            
            // Calculate S2/Imm value
            if (is_itype) begin
                s2_imm_value = $signed(art_ins[15:0]);  // Signed immediate for I-type
            end else begin
                s2_imm_value = art_ins[15:10];          // Unsigned S2 for R-type
            end
            
            // Print fields in decimal
            $fwrite(file, "%5d | %5b | %2d | %6b | %4d | %3d | %5d | %5d | %5d | %5d | %2d | %2d | %6d | %2d | %6d | %6d\n",
                i,
                art_ins[50:46],  // ROB
                art_ins[45:44],  // BID
                art_ins[43:38],  // Opcode
                art_ins[37:32],  // Dest
                art_ins[31:26],  // S1
                art_ins[25:24],  // ALUSelMuxS1
                art_ins[23:22],  // ALUSelMuxS2
                art_ins[21:20],  // LSUSelMuxS1
                art_ins[19:18],  // LSUSelMuxS2
                art_ins[17],     // ForwardS1
                art_ins[16],     // ForwardS2
                s2_imm_value,    // S2/Imm
                Isready,         // Ready status
                is_itype,        // I-type flag
                is_branch        // Branch flag
            );
        end
        $fwrite(file, "-------------------------------------------------------------------------------------------------------------------------------\n");
    end
endtask



endmodule