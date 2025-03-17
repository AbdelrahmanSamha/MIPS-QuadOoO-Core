module schedule_ls (
    input [36:0] inst0, inst1, inst2, inst3,  // Incoming instructions
	 input [3:0] LSstatus,
	 input [6:0] BIDs_flush,
	 
	 //valid bits come from the PRF, 
    input Rt0validsource, Rs0validsource,
	 input Rt1validsource, Rs1validsource,
    input Rt2validsource, Rs2validsource,
	 input Rt3validsource, Rs3validsource,
	 
	 input [5:0] FU0 , FU1, FU2,LSU0,LSU1,////current dest in the execute stage
	 input [5:0] FU0_readstage, FU1_readstage, FU2_readstage,  LSU0_readstage, LSU1_readstage,
	 
	 input stall_LS,
	 input is_cache_full, //this comes from the LSU to know if we have room to dispatch sw instruction 
    output [46:0] inst0_out_scheduler_ls, inst1_out_scheduler_ls,  // Read outputs
	 output  [3:0] new_status
);

    //reg [31:0] inst [3:0];   // Instruction storage.... delete not used 

    // Opcode and Register Fields
    wire [5:0] opcode_h, opcode_m0, opcode_m1, opcode_l;
    //wire [4:0] src_reg_m0, src_reg_m1, src_reg_l;
   // wire [4:0] dest_reg_h, dest_reg_m0, dest_reg_m1, dest_reg_l;

    // Dependency signals
   // wire dependency_m0_h, dependency_m1_h, dependency_m1_m0;
    //wire dependency_l_h, dependency_l_m0, dependency_l_m1;

    // Instruction Type Identification
	 wire is_sw_h, is_sw_m0, is_sw_m1;
    // wire is_sw_l;
     wire  is_lw_h, is_lw_m0, is_lw_m1, is_lw_l;
     //wire  is_lw_h;

	 
	 
    // Dependency Checks 
    //wire dep_sl_h_m0, dep_ss_h_m0, dep_sl_h_m1, dep_ss_h_m1, dep_sl_h_l, dep_ss_h_l;       delete
    //wire dep_sl_m0_m1, dep_ss_m0_m1, dep_sl_m0_l, dep_ss_m0_l, dep_sl_m1_l, dep_ss_m1_l;   delete
	 
	 reg [2:0] mux0_sl_sel, mux1_sl_sel;

	 /*
	 
	 ROB, 2 lsb bits of opcode, Rs, Rt, and imm value total of 37bits
	[36:32] ROB
	[31:30] BID
	[29:28] operation (2bits lsb of the opcode) -> #10 for store, 01 for load#
	[27:22] Rt
	[21:16] Rs
	[15:0] immediate
	*/
	reg [3:0] status; //not really registers but wires in astrisk always block
	reg [3:0] flushed_LS;
	assign new_status = flushed_LS | status;
	 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------------------
// Instance 0: LSU_RS_ready0
//---------------------------------------------------------------------	 
wire is_store_LSR0;
wire is_load_LSR0;
wire [5:0] Rtindex_LSR0, Rsindex_LSR0;
wire ready_LSR0;
wire [1:0] selector_for_Rt_ALUmux_LSR0, selector_for_Rt_LSUmux_LSR0;
wire Rtforward_LSR0;
wire [1:0] selector_for_Rs_ALUmux_LSR0, selector_for_Rs_LSUmux_LSR0;
wire Rsforward_LSR0;

assign is_load_LSR0 = inst0[28];
assign is_store_LSR0 = inst0[29];
assign Rtindex_LSR0  = inst0[27:22];
assign Rsindex_LSR0  = inst0[21:16];

reg is_empty0;
wire [1:0] BID0_temp;

assign BID0_temp = inst0[31:30];

	always@(*)begin 
		is_empty0 = LSstatus[0];
		flushed_LS[0] = 1'b0;
		if (!BIDs_flush[6] && BIDs_flush[BID0_temp]) begin 
				is_empty0 =1'b1;
				flushed_LS[0] = 1'b1;
		end

	end 
wire [1:0] BID0;
assign BID0 =  (BIDs_flush[6] && BIDs_flush[BID0_temp])? BIDs_flush[5:4] : BID0_temp;

// Instantiate the LoadStoreReady module
LoadStoreReady load_store_ready0 (
    .is_cache_full(is_cache_full),
    .Rtindex(Rtindex_LSR0),
    .Rsindex(Rsindex_LSR0),
    .Rtvalid(Rt0validsource),
    .Rsvalid(Rs0validsource),
    .is_store(is_store_LSR0),
	 .is_load(is_load_LSR0),
    .empty(is_empty0),
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
	 
    
    .ready(ready_LSR0),
    .selector_for_Rt_ALUmux(selector_for_Rt_ALUmux_LSR0),
    .selector_for_Rt_LSUmux(selector_for_Rt_LSUmux_LSR0),
    .Rtforward(Rtforward_LSR0),
    .selector_for_Rs_ALUmux(selector_for_Rs_ALUmux_LSR0),
    .selector_for_Rs_LSUmux(selector_for_Rs_LSUmux_LSR0),
    .Rsforward(Rsforward_LSR0)
);

	 
/*  

we add the selector bits to the instruction so we can use the bypass network: 

the full instruction should include: 

ROB 5bits 
operation 2bits 
Rs 6bits 
Rt 6bits 
aluselmuxs1 2b
aluselmuxs2 2b 
lsuselmuxs1 2b
lseselmuxs2 2b
isforward1	1b
isforward2	1b
16bit immediate

[46:42] ROB
[41:40] BID
[39:38] op
[37:32] Rt
[31:26] Rs
[25:24] aluselmuxs1
[23:22] aluselmuxs2
[21:20] lsuselmuxs1
[19:18] lseselmuxs2
[17] isforwardRt
[16] isforwardRs
[15:0]imm
*/
	 
									//ROB				//BID	//op			//Rt				//	Rs
wire [46:0] LSR_fullins0 = {inst0[36:32], BID0,	inst0[29:28], Rtindex_LSR0 , Rsindex_LSR0 ,selector_for_Rt_ALUmux_LSR0, selector_for_Rs_ALUmux_LSR0,
										selector_for_Rt_LSUmux_LSR0 ,selector_for_Rs_LSUmux_LSR0, Rtforward_LSR0, Rsforward_LSR0, inst0[15:0]};	 
	 
	 
	 
//---------------------------------------------------------------------
// Instance 1: LSU_RS_ready1
//---------------------------------------------------------------------	 
wire is_store_LSR1;
wire is_load_LSR1;
wire [5:0] Rtindex_LSR1, Rsindex_LSR1;
wire ready_LSR1;
wire [1:0] selector_for_Rt_ALUmux_LSR1, selector_for_Rt_LSUmux_LSR1;
wire Rtforward_LSR1;
wire [1:0] selector_for_Rs_ALUmux_LSR1, selector_for_Rs_LSUmux_LSR1;
wire Rsforward_LSR1;

assign is_store_LSR1 = inst1[29];
assign is_load_LSR1 = inst1[28];
assign Rtindex_LSR1  = inst1[27:22];
assign Rsindex_LSR1  = inst1[21:16];

reg is_empty1;

wire [1:0] BID1_temp;
assign BID1_temp = inst1[31:30];

always@(*)begin 
    is_empty1 = LSstatus[1];
    flushed_LS[1] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID1_temp]) begin 
        is_empty1 =1'b1;
        flushed_LS[1] = 1'b1;
    end
end 

wire [1:0] BID1;
assign BID1 =  (BIDs_flush[6] && BIDs_flush[BID1_temp])? BIDs_flush[5:4] : BID1_temp;

LoadStoreReady load_store_ready1 (
    .is_cache_full(is_cache_full),
    .Rtindex(Rtindex_LSR1),
    .Rsindex(Rsindex_LSR1),
    .Rtvalid(Rt1validsource),
    .Rsvalid(Rs1validsource),
    .is_store(is_store_LSR1),
	 .is_load(is_load_LSR1),
    .empty(is_empty1),
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
    
    .ready(ready_LSR1),
    .selector_for_Rt_ALUmux(selector_for_Rt_ALUmux_LSR1),
    .selector_for_Rt_LSUmux(selector_for_Rt_LSUmux_LSR1),
    .Rtforward(Rtforward_LSR1),
    .selector_for_Rs_ALUmux(selector_for_Rs_ALUmux_LSR1),
    .selector_for_Rs_LSUmux(selector_for_Rs_LSUmux_LSR1),
    .Rsforward(Rsforward_LSR1)
);

wire [46:0] LSR_fullins1 = {inst1[36:32], BID1 , inst1[29:28], Rtindex_LSR1 , Rsindex_LSR1 ,selector_for_Rt_ALUmux_LSR1, selector_for_Rs_ALUmux_LSR1,
                            selector_for_Rt_LSUmux_LSR1 ,selector_for_Rs_LSUmux_LSR1, Rtforward_LSR1, Rsforward_LSR1, inst1[15:0]};

//---------------------------------------------------------------------
// Instance 2: LSU_RS_ready2
//---------------------------------------------------------------------	 
wire is_store_LSR2;
wire is_load_LSR2;
wire [5:0] Rtindex_LSR2, Rsindex_LSR2;
wire ready_LSR2;
wire [1:0] selector_for_Rt_ALUmux_LSR2, selector_for_Rt_LSUmux_LSR2;
wire Rtforward_LSR2;
wire [1:0] selector_for_Rs_ALUmux_LSR2, selector_for_Rs_LSUmux_LSR2;
wire Rsforward_LSR2;

assign is_store_LSR2 = inst2[29];
assign is_load_LSR2 = inst2[28];
assign Rtindex_LSR2  = inst2[27:22];
assign Rsindex_LSR2  = inst2[21:16];

reg is_empty2;

wire [1:0] BID2_temp;
assign BID2_temp = inst2[31:30];

always@(*)begin 
    is_empty2 = LSstatus[2];
    flushed_LS[2] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID2_temp]) begin 
        is_empty2 =1'b1;
        flushed_LS[2] = 1'b1;
    end
end 

wire [1:0] BID2;
assign BID2 =  (BIDs_flush[6] && BIDs_flush[BID2_temp])? BIDs_flush[5:4] : BID2_temp;

LoadStoreReady load_store_ready2 (
    .is_cache_full(is_cache_full),
    .Rtindex(Rtindex_LSR2),
    .Rsindex(Rsindex_LSR2),
    .Rtvalid(Rt2validsource),
    .Rsvalid(Rs2validsource),
    .is_store(is_store_LSR2),
	 .is_load(is_load_LSR2),
    .empty(is_empty2),
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
    
    .ready(ready_LSR2),
    .selector_for_Rt_ALUmux(selector_for_Rt_ALUmux_LSR2),
    .selector_for_Rt_LSUmux(selector_for_Rt_LSUmux_LSR2),
    .Rtforward(Rtforward_LSR2),
    .selector_for_Rs_ALUmux(selector_for_Rs_ALUmux_LSR2),
    .selector_for_Rs_LSUmux(selector_for_Rs_LSUmux_LSR2),
    .Rsforward(Rsforward_LSR2)
);

wire [46:0] LSR_fullins2 = {inst2[36:32], BID2 , inst2[29:28], Rtindex_LSR2 , Rsindex_LSR2 ,selector_for_Rt_ALUmux_LSR2, selector_for_Rs_ALUmux_LSR2,
                            selector_for_Rt_LSUmux_LSR2 ,selector_for_Rs_LSUmux_LSR2, Rtforward_LSR2, Rsforward_LSR2, inst2[15:0]};

//---------------------------------------------------------------------
// Instance 3: LSU_RS_ready3
//---------------------------------------------------------------------	 
wire is_store_LSR3;
wire is_load_LSR3;
wire [5:0] Rtindex_LSR3, Rsindex_LSR3;
wire ready_LSR3;
wire [1:0] selector_for_Rt_ALUmux_LSR3, selector_for_Rt_LSUmux_LSR3;
wire Rtforward_LSR3;
wire [1:0] selector_for_Rs_ALUmux_LSR3, selector_for_Rs_LSUmux_LSR3;
wire Rsforward_LSR3;

assign is_store_LSR3 = inst3[29];
assign is_load_LSR3 = inst3[28];
assign Rtindex_LSR3  = inst3[27:22];
assign Rsindex_LSR3  = inst3[21:16];

reg is_empty3;

wire [1:0] BID3_temp;
assign BID3_temp = inst3[31:30];

always@(*)begin 
    is_empty3 = LSstatus[3];
    flushed_LS[3] = 1'b0;
    if (!BIDs_flush[6] && BIDs_flush[BID3_temp]) begin 
        is_empty3 =1'b1;
        flushed_LS[3] = 1'b1;
    end
end 

wire [1:0] BID3;
assign BID3 =  (BIDs_flush[6] && BIDs_flush[BID3_temp])? BIDs_flush[5:4] : BID3_temp;

LoadStoreReady load_store_ready3 (
    .is_cache_full(is_cache_full),
    .Rtindex(Rtindex_LSR3),
    .Rsindex(Rsindex_LSR3),
    .Rtvalid(Rt3validsource),
    .Rsvalid(Rs3validsource),
    .is_store(is_store_LSR3),
	 .is_load(is_load_LSR3),
    .empty(is_empty3),
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
    
    .ready(ready_LSR3),
    .selector_for_Rt_ALUmux(selector_for_Rt_ALUmux_LSR3),
    .selector_for_Rt_LSUmux(selector_for_Rt_LSUmux_LSR3),
    .Rtforward(Rtforward_LSR3),
    .selector_for_Rs_ALUmux(selector_for_Rs_ALUmux_LSR3),
    .selector_for_Rs_LSUmux(selector_for_Rs_LSUmux_LSR3),
    .Rsforward(Rsforward_LSR3)
);

wire [46:0] LSR_fullins3 = {inst3[36:32], BID3 , inst3[29:28], Rtindex_LSR3 , Rsindex_LSR3 ,selector_for_Rt_ALUmux_LSR3, selector_for_Rs_ALUmux_LSR3,
                            selector_for_Rt_LSUmux_LSR3 ,selector_for_Rs_LSUmux_LSR3, Rtforward_LSR3, Rsforward_LSR3, inst3[15:0]};
	 



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 
wire [3:0]ready; 
assign ready = (stall_LS) ? 4'b0 :{ready_LSR3,ready_LSR2,ready_LSR1,ready_LSR0};
	 
	 
	/* 
	 wire [15:0] address_h, address_m0, address_m1, address_l;

    // Instruction type identification
    assign opcode_h = inst0[29:28];
    //assign dest_reg_h = inst0[4:0];
	 assign address_h = {9'b0,inst0[31:26]} + inst1[15:0];
	
    assign opcode_m0 = inst1[29:28];
   // assign src_reg_m0 = inst1[25:21];
   // assign dest_reg_m0 = inst1[4:0];
 	 assign address_m0 = {9'b0,inst1[31:26]} + inst1[15:0];
    
	 assign opcode_m1 = inst2[29:28] ;
    //assign src_reg_m1 = inst2[25:21];
    //assign dest_reg_m1 = inst2[4:0];
	 assign address_m1 = {9'b0,inst2[31:26]} + inst1[15:0];
	 
   // assign opcode_l = inst3[29:28];
    //assign src_reg_l = inst3[25:21];
    //assign dest_reg_l = inst3[4:0];
	 assign address_l = {9'b0,inst3[31:26]} + inst1[15:0];
		
    // Load/Store Identifiers
    assign is_sw_h  = (opcode_h  == 2'b10);
   // assign is_lw_m0 = (opcode_m0 == 2'b01);
    assign is_sw_m0 = (opcode_m0 == 2'b10);
   // assign is_lw_m1 = (opcode_m1 == 2'b01);
    assign is_sw_m1 = (opcode_m1 == 2'b10);
   // assign is_lw_l  = (opcode_l  == 2'b01);
  //  assign is_sw_l  = (opcode_l  == 2'b10);

    // Dependency Checks
   assign dep_sl_h_m0 = (dest_reg_h == src_reg_m0);
    assign dep_ss_h_m0 = (dest_reg_h == dest_reg_m0);
    assign dep_sl_h_m1 = (dest_reg_h == src_reg_m1);
    assign dep_ss_h_m1 = (dest_reg_h == dest_reg_m1);
    assign dep_sl_h_l  = (dest_reg_h == src_reg_l);
    assign dep_ss_h_l  = (dest_reg_h == dest_reg_l);
    assign dep_sl_m0_m1 = (dest_reg_m0 == src_reg_m1);
    assign dep_ss_m0_m1 = (dest_reg_m0 == dest_reg_m1);
    assign dep_sl_m0_l  = (dest_reg_m0 == src_reg_l);
    assign dep_ss_m0_l  = (dest_reg_m0 == dest_reg_l);
    assign dep_sl_m1_l  = (dest_reg_m1 == src_reg_l);
    assign dep_ss_m1_l  = (dest_reg_m1 == dest_reg_l);
*/
/*
wire dep_h_m0,dep_h_m1, dep_h_l, dep_m0_m1, dep_m0_l, dep_m1_l;

	assign dep_h_m0 = (address_h == address_m0);
	assign dep_h_m1 = (address_h == address_m1);
	assign dep_h_l = (address_h == address_l);
	assign dep_m0_m1 = (address_m0 == address_m1);
	assign dep_m0_l = (address_m0 == address_l);
	assign dep_m1_l = (address_m1 == address_l);

    assign dependency_m0_h = (is_sw_h && dep_h_m0);
    assign dependency_m1_h = (is_sw_h && dep_h_m1);
    assign dependency_l_h  = (is_sw_h && dep_h_l);
    assign dependency_m1_m0 = (is_sw_m0 && dep_m0_m1);
    assign dependency_l_m0  = (is_sw_m0 && dep_m0_l);
    assign dependency_l_m1  = (is_sw_m1 && dep_m1_l);




    // Final Dependency Decisions
    assign dependency_m0_h = is_sw_h && ((is_lw_m0 && dep_sl_h_m0) || (is_sw_m0 && dep_ss_h_m0));
    assign dependency_m1_h = is_sw_h && ((is_lw_m1 && dep_sl_h_m1) || (is_sw_m1 && dep_ss_h_m1));
    assign dependency_l_h  = is_sw_h && ((is_lw_l && dep_sl_h_l) || (is_sw_l && dep_ss_h_l));
    assign dependency_m1_m0 = is_sw_m0 && ((is_lw_m1 && dep_sl_m0_m1) || (is_sw_m1 && dep_ss_m0_m1));
    assign dependency_l_m0  = is_sw_m0 && ((is_lw_l && dep_sl_m0_l) || (is_sw_l && dep_ss_m0_l));
    assign dependency_l_m1  = is_sw_m1 && ((is_lw_l && dep_sl_m1_l) || (is_sw_l && dep_ss_m1_l));
*/

    // Mux Selection Logic
	 /*
always @(*) begin
//
 mux0_sl_sel = 2'b00;
 mux1_sl_sel = 2'b00;
 status = LSstatus;
        if (ready[0]) begin 
            mux0_sl_sel = 2'b00;
			status[0] = 1'b1;
            if (ready[1] && !dependency_m0_h) begin 
                mux1_sl_sel = 2'b01;
				status[1] = 1'b1;
            end else if (ready[2] && !dependency_m1_h && !dependency_m1_m0) begin 
                mux1_sl_sel = 2'b10;
				status[2] = 1'b1;
			end else if (ready[3] && !dependency_l_h && !dependency_l_m0 && !dependency_l_m1) begin 
                mux1_sl_sel = 2'b11;
				status[3] = 1'b1;
			end
        end else if (ready[1] && !dependency_m0_h) begin 
            mux0_sl_sel = 2'b01;
			status[1] = 1'b1;
            if (ready[2] && !dependency_m1_h && !dependency_m1_m0) begin 
                mux1_sl_sel = 2'b10;
				status[2] = 1'b1;
			end else if (ready[3] && !dependency_l_h && !dependency_l_m0 && !dependency_l_m1) begin 
                mux1_sl_sel = 2'b11;
				status[3] = 1'b1;
			end
        end else if (ready[2] && !dependency_m1_h && !dependency_m1_m0) begin 
            mux0_sl_sel = 2'b10;
            status[2] = 1'b1;
			if (ready[3] && !dependency_l_h && !dependency_l_m0 && !dependency_l_m1) begin 
                mux1_sl_sel = 2'b11;
				status[3] = 1'b1;
			end
        end else if (ready[3] && !dependency_l_h && !dependency_l_m0 && !dependency_l_m1) begin 
            mux0_sl_sel = 2'b11;
			status[3] = 1'b1;
        end
    end
*/	 
/*****************************/



    assign is_sw_h  = (opcode_h  == 2'b10);
    assign is_sw_m0 = (opcode_m0 == 2'b10);
    assign is_sw_m1 = (opcode_m1 == 2'b10);
    //assign is_sw_l  = (opcode_l  == 2'b10);
	
	 //assign is_lw_h = (opcode_h == 2'b01);
	 assign is_lw_m1 = (opcode_m1 == 2'b01);
	 assign is_lw_m0 = (opcode_m0 == 2'b01);
    assign is_lw_l  = (opcode_l  == 2'b01);

    assign opcode_h = inst0[29:28];
	
    assign opcode_m0 = inst1[29:28];

	 assign opcode_m1 = inst2[29:28] ;
	 
    assign opcode_l = inst3[29:28];


always @(*) begin
 mux0_sl_sel = 3'b111;
 mux1_sl_sel = 3'b111;
 status = LSstatus;
 
	if (is_sw_h) begin 
		if (ready[0]) begin 
			if ((is_sw_m0 | is_lw_m0) && ready[1]) begin // pop h & m0 (2 sw)
				mux0_sl_sel = 3'b00;
				mux1_sl_sel = 3'b01;
				status[0] = 1'b1;
				status[1] = 1'b1;
			end
			else begin 
				mux0_sl_sel = 3'b00;
				status[0] = 1'b1;
			end
		end 
	end
	else begin // is_lw_h 
		if (ready[0]) begin 
			if (is_lw_m0 && ready[1]) begin 
				mux0_sl_sel = 3'b00;
				mux1_sl_sel = 3'b01;
				status[0] = 1'b1;
				status[1] = 1'b1;
			end 
			else if (is_lw_m1 && ready[2] && (!is_sw_m0)) begin 				// h is lw and not ready ... check if there and lw ready to pop ... there should be no sw between the lw 
					mux0_sl_sel = 3'b00;
					mux1_sl_sel = 3'b10;
					status[0] = 1'b1;
					status[2] = 1'b1;		
			end
			else if (is_lw_l && ready[3] && (!is_sw_m0) && (!is_sw_m1)) begin 				
					mux0_sl_sel = 3'b00;
					mux1_sl_sel = 3'b11;
					status[0] = 1'b1;
					status[3] = 1'b1;		
			end 
			else begin // there is no ready lw except h 
					mux0_sl_sel = 3'b00;
					status[0] = 1'b1;
			end
		end
	else if (is_lw_m0 && ready[1]) begin       // lw h not ready  ... search to other ready lw .. no sw in between 
				if (is_lw_m1 && ready[2]) begin 				
					mux0_sl_sel = 3'b01;
					mux1_sl_sel = 3'b10;
					status[1] = 1'b1;
					status[2] = 1'b1;
				end
				else if (is_lw_l && ready[3] && (!is_sw_m1)) begin 				
						mux0_sl_sel = 3'b01;
						mux1_sl_sel = 3'b11;
						status[1] = 1'b1;
						status[3] = 1'b1;		
				end 
				else begin // there is no ready lw except m0 
						mux0_sl_sel = 3'b01;
						status[1] = 1'b1;
				end
	end 
	else if (is_lw_m1 && ready[2] && (!is_sw_m0)) begin       // lw h & m0 not ready  ... search to other ready lw .. no sw in between 
				if (is_lw_l && ready[3]) begin 				
					mux0_sl_sel = 3'b10;
					mux1_sl_sel = 3'b11;
					status[2] = 1'b1;
					status[3] = 1'b1;
				end		
				else begin // there is no ready lw except m1 
					mux0_sl_sel = 3'b10;
					status[2] = 1'b1;
				end
	end
	else if (is_lw_l && ready[3] && (!is_sw_m0) && (!is_sw_m1)) begin       // lw h & m0 & m1 not ready  ... search to other ready lw .. no sw in between 
					mux0_sl_sel = 3'b11;
					status[3] = 1'b1;
	end
end
end


/*****************************/
	    MUX5to1 #(47) mux0_sw_lw (
        .in0(LSR_fullins0),
        .in1(LSR_fullins1),
        .in2(LSR_fullins2),
        .in3(LSR_fullins3),
		  .in4(),
        .sel(mux0_sl_sel),
        .out(inst0_out_scheduler_ls)
    );
	 
	     MUX5to1 #(47) mux1_sw_lw (
        .in0(LSR_fullins0),
        .in1(LSR_fullins1),
        .in2(LSR_fullins2),
        .in3(LSR_fullins3),
		  .in4(),
        .sel(mux1_sl_sel),
        .out(inst1_out_scheduler_ls)
    );

endmodule