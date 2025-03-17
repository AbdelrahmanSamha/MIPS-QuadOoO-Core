module Schedule_Stage(
    //==================================================================
    // Global Inputs & Outputs
    //==================================================================
    // Inputs from the arithmetic reservation stations
    input  [40:0] ARTins0, ARTins1, ARTins2, ARTins3, ARTins4, ARTins5,
                   ARTins6, ARTins7, ARTins8, ARTins9,
    input  [9:0]  ARTstatus,
    
    // Inputs from the loadstore reservation stations
    input  [36:0] inst0_in_rsv_ls, inst1_in_rsv_ls, inst2_in_rsv_ls, inst3_in_rsv_ls,
    input  [3:0]  LSstatus,
    
    // Valid bits read from PRF for arithmetic stations
    input         rs0validsource1, rs0validsource2,
    input         rs1validsource1, rs1validsource2,
    input         rs2validsource1, rs2validsource2,
    input         rs3validsource1, rs3validsource2,
    input         rs4validsource1, rs4validsource2,
    input         rs5validsource1, rs5validsource2,
    input         rs6validsource1, rs6validsource2,
    input         rs7validsource1, rs7validsource2,
    input         rs8validsource1, rs8validsource2,
    input         rs9validsource1, rs9validsource2,
    
    // Valid bits for LOADstore stations
    input         Rt0validsource, Rs0validsource,
    input         Rt1validsource, Rs1validsource,
    input         Rt2validsource, Rs2validsource,
    input         Rt3validsource, Rs3validsource,
    
    // Bypass network inputs
    input  [5:0]  FU0, FU1, FU2,  LSU0, LSU1,
    input  [5:0]  FU0_readstage, FU1_readstage, FU2_readstage, 
                   LSU0_readstage, LSU1_readstage,
    //LSU                
    input         is_cache_full,
	 input stall_LS,
	 
	 //BU input for flushing 
    input [6:0] BIDs_flush,
	 
    // Global outputs (sent back to the reservation stations)
    output [3:0]  updated_LoadStore_status,
    output [9:0]  updated_ART_status,
    
    //==================================================================
    // ALU Segments
    //==================================================================
    // --- ALU0 ---
    output [4:0]  alu0_ROBentry,
    output [5:0]  alu0_dest,
    output [3:0]  alu0_operation,
    output [5:0]  alu0_s1_index,
    output [1:0]  alu0_bid,
    output        alu0_is_Itype,
    output [1:0]  alu0_s1_alu_forwarding, alu0_s2_alu_forwarding,
    output [1:0]  alu0_s1_lsu_forwarding, alu0_s2_lsu_forwarding,
    output        alu0_s1_needforwarding, alu0_s2_needforwarding,
    output [15:0] alu0_imm16b,
    
    // --- ALU1 ---
    output [4:0]  alu1_ROBentry,
    output [5:0]  alu1_dest,
    output [3:0]  alu1_operation,
    output [5:0]  alu1_s1_index, 
    output [1:0]  alu1_bid,
    output        alu1_is_Itype,
    output [1:0]  alu1_s1_alu_forwarding, alu1_s2_alu_forwarding,
    output [1:0]  alu1_s1_lsu_forwarding, alu1_s2_lsu_forwarding,
    output        alu1_s1_needforwarding, alu1_s2_needforwarding,
    output [15:0] alu1_imm16b,
    
    // --- ALU2 ---
    output [4:0]  alu2_ROBentry,
    output [5:0]  alu2_dest,
    output [3:0]  alu2_operation,
    output [5:0]  alu2_s1_index, 
    output [1:0]  alu2_bid,
    output        alu2_is_Itype,
    output [1:0]  alu2_s1_alu_forwarding, alu2_s2_alu_forwarding,
    output [1:0]  alu2_s1_lsu_forwarding, alu2_s2_lsu_forwarding,
    output        alu2_s1_needforwarding, alu2_s2_needforwarding,
    output [15:0] alu2_imm16b,
    
    
    
    //==================================================================
    // Branch Unit (BU) Segment
    //==================================================================
    // (Removed unused BU_source1 and BU_source2)
	 output [4:0]  bu_ROBentry,
    output [2:0]  bu_operation,
    output [9:0]  bu_imm,
    output [1:0]  bu_BID,
    output        bu_prediction,
    output [5:0]  bu_s1_index, bu_s2_index,
    output        bu_is_branch, bu_is_Jr,
    output [1:0]  bu_s1_alu_forwarding, bu_s2_alu_forwarding,
    output [1:0]  bu_s1_lsu_forwarding, bu_s2_lsu_forwarding,
    output        bu_s1_needforwarding, bu_s2_needforwarding,
    
    //==================================================================
    // LSU Segments
    //==================================================================
    // --- LSU0 ---
   
    output [4:0]  lsu0_ROBentry,
    
    output [1:0]  lsu0_operation,
    output [5:0]  lsu0_Rt_index, lsu0_Rs_index,
    output [1:0]  lsu0_bid,
    output [1:0]  lsu0_Rt_alu_forwarding, lsu0_Rs_alu_forwarding,
    output [1:0]  lsu0_Rt_lsu_forwarding, lsu0_Rs_lsu_forwarding,
    output        lsu0_Rt_needforwarding, lsu0_Rs_needforwarding,
    output [15:0] lsu0_imm,
    
    // --- LSU1 ---
   
    output [4:0]  lsu1_ROBentry,
    
    output [1:0]  lsu1_operation,
    output [5:0]  lsu1_Rt_index, lsu1_Rs_index,
    output [1:0]  lsu1_bid,
    output [1:0]  lsu1_Rt_alu_forwarding, lsu1_Rs_alu_forwarding,
    output [1:0]  lsu1_Rt_lsu_forwarding, lsu1_Rs_lsu_forwarding,
    output        lsu1_Rt_needforwarding, lsu1_Rs_needforwarding,
    output [15:0] lsu1_imm
);

wire [50:0] dispatched_alu0,dispatched_alu1 , dispatched_alu2, dispatched_bu;

wire [46:0] dispatched_lsu0,dispatched_lsu1;// not connected 

schedule_ls scheduler_lw_sw (
    .inst0(inst0_in_rsv_ls), // inputs   
    .inst1(inst1_in_rsv_ls),  
    .inst2(inst2_in_rsv_ls),  
    .inst3(inst3_in_rsv_ls),  
	 .LSstatus(LSstatus),
 	 .Rt0validsource(Rt0validsource), .Rs0validsource(Rs0validsource),
	 .Rt1validsource(Rt1validsource), .Rs1validsource(Rs1validsource),
    .Rt2validsource(Rt2validsource), .Rs2validsource(Rs2validsource),
	 .Rt3validsource(Rt3validsource), .Rs3validsource(Rs3validsource),
	 .is_cache_full(is_cache_full),//input from the LSU 
    .stall_LS(stall_LS),
    .new_status(updated_LoadStore_status),  // output to the rev_lw_sw
	 .FU0_readstage(FU0_readstage),//current dest in the read stage
	 .FU1_readstage(FU1_readstage),
	 .FU2_readstage(FU2_readstage),
	 
	 .LSU0_readstage(LSU0_readstage),
	 .LSU1_readstage(LSU1_readstage),
	 .FU0(FU0), //current dest in the read stage
	 .FU1(FU1),
	 .FU2(FU2),
	 
  	 .LSU0(LSU0),
	 .LSU1(LSU1),
	 .BIDs_flush(BIDs_flush),//to flush mispredicted instruction 
	 
	 // output
	 .inst0_out_scheduler_ls(dispatched_lsu0),  
	 .inst1_out_scheduler_ls(dispatched_lsu1)
	 
);


scheduler scheduler(.ARTins0(ARTins0), .ARTins1(ARTins1), .ARTins2(ARTins2), .ARTins3(ARTins3), .ARTins4(ARTins4), .ARTins5(ARTins5),
							  .ARTins6(ARTins6), .ARTins7(ARTins7), .ARTins8(ARTins8), .ARTins9(ARTins9),. ARTstatus(ARTstatus),//status is the vector recived from the Arithemtic reservation stations. if1 empty, if 0 there is an instruction in the staiton.
							  .rs0validsource1(rs0validsource1),
							  .rs0validsource2(rs0validsource2),
							  .rs1validsource1(rs1validsource1),
							  .rs1validsource2(rs1validsource2),
							  .rs2validsource1(rs2validsource1),
							  .rs2validsource2(rs2validsource2),
							  .rs3validsource1(rs3validsource1),
							  .rs3validsource2(rs3validsource2),
							  .rs4validsource1(rs4validsource1),
							  .rs4validsource2(rs4validsource2),
							  .rs5validsource1(rs5validsource1),
							  .rs5validsource2(rs5validsource2),
							  .rs6validsource1(rs6validsource1),
							  .rs6validsource2(rs6validsource2),
							  .rs7validsource1(rs7validsource1),
							  .rs7validsource2(rs7validsource2),
							  .rs8validsource1(rs8validsource1),
							  .rs8validsource2(rs8validsource2),
							  .rs9validsource1(rs9validsource1),
							  .rs9validsource2(rs9validsource2),
							  .FU0_readstage(FU0_readstage),//current dest in the read stage
							  .FU1_readstage(FU1_readstage),
							  .FU2_readstage(FU2_readstage),
							  
							  .LSU0_readstage(LSU0_readstage),
							  .LSU1_readstage(LSU1_readstage),
							  .FU0(FU0),//current dest in the execute stage
							  .FU1(FU1),
							  .FU2(FU2),
							  
							  .LSU0(LSU0),
							  .LSU1(LSU1),
							  .BIDs_flush(BIDs_flush),//to flush mispredicted instruction 
							  .stall_LS(stall_LS),
							  //outputs
							  .new_ready_arithmetic(updated_ART_status),//must be sent back to the arithmetic reservation stations
							  .dispatched_alu0(dispatched_alu0),.dispatched_alu1(dispatched_alu1), .dispatched_alu2(dispatched_alu2),
							  .dispatched_bu(dispatched_bu)
							  );
							  
							  
// ALU0 
	assign alu0_ROBentry            = dispatched_alu0[50:46];
	assign alu0_bid                 = dispatched_alu0[45:44];
	assign alu0_is_Itype            = dispatched_alu0[42];
	assign alu0_operation           = dispatched_alu0[41:38];
	assign alu0_dest                = dispatched_alu0[37:32];
	assign alu0_s1_index            = dispatched_alu0[31:26];
	assign alu0_s1_alu_forwarding   = dispatched_alu0[25:24];
	assign alu0_s2_alu_forwarding   = dispatched_alu0[23:22];
	assign alu0_s1_lsu_forwarding   = dispatched_alu0[21:20];
	assign alu0_s2_lsu_forwarding   = dispatched_alu0[19:18];
	assign alu0_s1_needforwarding   = dispatched_alu0[17];
	assign alu0_s2_needforwarding   = dispatched_alu0[16];	
	assign alu0_imm16b              = dispatched_alu0[15:0];

// ALU1 
	assign alu1_ROBentry            = dispatched_alu1[50:46];
	assign alu1_bid                 = dispatched_alu1[45:44];
	assign alu1_is_Itype            = dispatched_alu1[42];
	assign alu1_operation           = dispatched_alu1[41:38];
	assign alu1_dest                = dispatched_alu1[37:32];
	assign alu1_s1_index            = dispatched_alu1[31:26];
	assign alu1_s1_alu_forwarding   = dispatched_alu1[25:24];
	assign alu1_s2_alu_forwarding   = dispatched_alu1[23:22];
	assign alu1_s1_lsu_forwarding   = dispatched_alu1[21:20];
	assign alu1_s2_lsu_forwarding   = dispatched_alu1[19:18];
	assign alu1_s1_needforwarding   = dispatched_alu1[17];
	assign alu1_s2_needforwarding   = dispatched_alu1[16];
	assign alu1_imm16b              = dispatched_alu1[15:0];

// ALU2 
	assign alu2_ROBentry            = dispatched_alu2[50:46];
	assign alu2_bid                 = dispatched_alu2[45:44];
	assign alu2_is_Itype            = dispatched_alu2[42];
	assign alu2_operation           = dispatched_alu2[41:38];
	assign alu2_dest                = dispatched_alu2[37:32];
	assign alu2_s1_index            = dispatched_alu2[31:26];
	assign alu2_s1_alu_forwarding   = dispatched_alu2[25:24];
	assign alu2_s2_alu_forwarding   = dispatched_alu2[23:22];
	assign alu2_s1_lsu_forwarding   = dispatched_alu2[21:20];
	assign alu2_s2_lsu_forwarding   = dispatched_alu2[19:18];	
	assign alu2_s1_needforwarding   = dispatched_alu2[17];
	assign alu2_s2_needforwarding   = dispatched_alu2[16];
	assign alu2_imm16b              = dispatched_alu2[15:0];

	  
							  
							  
							  
// branching unit							  
							  
	assign bu_ROBentry  				  = dispatched_bu[50:46];
   assign bu_operation 			 	  = dispatched_bu[40:38];
	assign bu_is_branch             = (dispatched_bu[43:42] == 2'b10);
	assign bu_is_Jr                 = (dispatched_bu[43:42] == 2'b11);
   assign bu_BID       			     = dispatched_bu[45:44];
   assign bu_s1_index  				  = dispatched_bu[31:26];
	assign bu_s2_index  				  = dispatched_bu[37:32];
	assign bu_s1_alu_forwarding	  = dispatched_bu[25:24];
	assign bu_s2_alu_forwarding	  = dispatched_bu[23:22];
	assign bu_s1_lsu_forwarding	  = dispatched_bu[21:20];
	assign bu_s2_lsu_forwarding	  = dispatched_bu[19:18];
	assign bu_s1_needforwarding	  = dispatched_bu[17];
	assign bu_s2_needforwarding	  = dispatched_bu[16];
   assign bu_prediction				  = dispatched_bu[10]; 
   assign bu_imm       				  = dispatched_bu[9:0];
							  
							  
// LSU0
							  
	assign lsu0_ROBentry 			  = dispatched_lsu0[46:42];
	assign lsu0_bid		 		     = dispatched_lsu0[41:40];
	assign lsu0_operation			  = dispatched_lsu0[39:38];
	assign lsu0_Rt_index 			  = dispatched_lsu0[37:32];
	assign lsu0_Rs_index 			  = dispatched_lsu0[31:26];
	assign lsu0_Rt_alu_forwarding	  = dispatched_lsu0[25:24];
	assign lsu0_Rs_alu_forwarding	  = dispatched_lsu0[23:22];
	assign lsu0_Rt_lsu_forwarding	  = dispatched_lsu0[21:20];
	assign lsu0_Rs_lsu_forwarding	  = dispatched_lsu0[19:18];
	assign lsu0_Rt_needforwarding	  = dispatched_lsu0[17];
	assign lsu0_Rs_needforwarding	  = dispatched_lsu0[16];
	assign lsu0_imm      			  = dispatched_lsu0[15:0];						  
							  
//LSU1
	assign lsu1_ROBentry            = dispatched_lsu1[46:42];
	assign lsu1_bid                 = dispatched_lsu1[41:40];
	assign lsu1_operation           = dispatched_lsu1[39:38];
	assign lsu1_Rt_index            = dispatched_lsu1[37:32];
	assign lsu1_Rs_index            = dispatched_lsu1[31:26];
	assign lsu1_Rt_alu_forwarding   = dispatched_lsu1[25:24];
	assign lsu1_Rs_alu_forwarding   = dispatched_lsu1[23:22];
	assign lsu1_Rt_lsu_forwarding   = dispatched_lsu1[21:20];
	assign lsu1_Rs_lsu_forwarding   = dispatched_lsu1[19:18];
	assign lsu1_Rt_needforwarding   = dispatched_lsu1[17];
	assign lsu1_Rs_needforwarding   = dispatched_lsu1[16];
	assign lsu1_imm                 = dispatched_lsu1[15:0];						
							  
 /*assign alu0_s1_index = dispatched_alu0[31:26];
 assign alu0_s2_index = dispatched_alu0[15:10];
 assign alu1_s1_index = dispatched_alu1[31:26];
 assign alu1_s2_index = dispatched_alu1[15:10];
 assign alu2_s1_index = dispatched_alu2[31:26];
 assign alu2_s2_index = dispatched_alu2[15:10];
 assign alu3_s1_index = dispatched_alu3[31:26];
 assign alu3_s2_index = dispatched_alu3[15:10];
 assign bu_s1_index   = dispatched_bu[37:32];//these are different for the BU, because we need an immediate value we cant take the 15:10
 assign bu_s2_index   = dispatched_bu[31:26];//the first source is in the position of the dest and the second is in the position of the second source. 
															//will not make a difference.
 assign lsu0_Rt_index = dispatched_lsu0[37:32];
 assign lsu0_Rs_index = dispatched_lsu0[31:26];
 assign lsu1_Rt_index = dispatched_lsu1[37:32];
 assign lsu1_Rs_index = dispatched_lsu1[31:26];
 */

 
 //---------------------------------------------------------------------
 //insutrctions preperation and muxes for arithmetic execution units
 //---------------------------------------------------------------------
 /*
 
wire [88:0] ALU0_fullins , ALU1_fullins  , ALU2_fullins , ALU3_fullins;
wire [94:0] BU_fullins;
wire [118:0]lsu0_fullins, lsu1_fullins;

 instruction_prepare_arithmetic preparing (
    .instruction_alu0(dispatched_alu0), 
    .instruction_alu1(dispatched_alu1), 
    .instruction_alu2(dispatched_alu2), 
    .instruction_alu3(dispatched_alu3), 
    .instruction_bu(dispatched_bu), 
    .inst0source1(alu0_s1), 
    .inst0source2(alu0_s2), 
    .inst1source1(alu1_s1), 
    .inst1source2(alu1_s2), 
    .inst2source1(alu2_s1), 
    .inst2source2(alu2_s2), 
    .inst3source1(alu3_s1), 
    .inst3source2(alu3_s2), 
    .inst4source1(bu_s1), 
    .inst4source2(bu_s2), 
	 
	 //output
    .instructionout_alu0(ALU0_fullins), 
    .instructionout_alu1(ALU1_fullins), 
    .instructionout_alu2(ALU2_fullins), 
    .instructionout_alu3(ALU3_fullins), 
    .instructionout_bu(BU_fullins)
);
							  


	
		scheduler_forwarding_muxes ALU0 (
    .ALU_fullins(ALU0_fullins), 
    .alu0(alu0), 
    .alu1(alu1), 
    .alu2(alu2), 
    .alu3(alu3), 
    .lsu0(lsu0), 
    .lsu1(lsu1), 
    .source1(alu0_source1), 
    .source2(alu0_source2), 
    .ROBentry(alu0_ROBentry), 
    .dest(alu0_dest), 
    .operation(alu0_operation)
);
	
		scheduler_forwarding_muxes ALU1 (
    .ALU_fullins(ALU1_fullins), 
    .alu0(alu0), 
    .alu1(alu1), 
    .alu2(alu2), 
    .alu3(alu3), 
    .lsu0(lsu0), 
    .lsu1(lsu1), 
    .source1(alu1_source1), 
    .source2(alu1_source2), 
    .ROBentry(alu1_ROBentry), 
    .dest(alu1_dest), 
    .operation(alu1_operation)
);
	scheduler_forwarding_muxes ALU2 (
    .ALU_fullins(ALU2_fullins), 
    .alu0(alu0), 
    .alu1(alu1), 
    .alu2(alu2), 
    .alu3(alu3), 
    .lsu0(lsu0), 
    .lsu1(lsu1), 
    .source1(alu2_source1), 
    .source2(alu2_source2), 
    .ROBentry(alu2_ROBentry), 
    .dest(alu2_dest), 
    .operation(alu2_operation)
);


	scheduler_forwarding_muxes ALU3 (
    .ALU_fullins(ALU3_fullins), 
    .alu0(alu0), 
    .alu1(alu1), 
    .alu2(alu2), 
    .alu3(alu3), 
    .lsu0(lsu0), 
    .lsu1(lsu1), 
    .source1(alu3_source1), 
    .source2(alu3_source2), 
    .ROBentry(alu3_ROBentry), 
    .dest(alu3_dest), 
    .operation(alu3_operation)
);


	shceduler_forwarding_muxes_BU BU (
    .BU_fullins(BU_fullins),
    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
    .alu3(alu3),
    .lsu0(lsu0),
    .lsu1(lsu1),
    .source1(BU_source1),
    .source2(BU_source2),
    .ROBentry(BU_ROBentry),
    .BID(BU_BID),
    .operation(BU_operation),
    .immediate(BU_imm),
	 .prediction(BU_prediction)
);

 //---------------------------------------------------------------------
 //insutrctions preperation and muxes for memory access units
 //---------------------------------------------------------------------

	instruction_prepare_LoadStore prep (
    .instruction_lsu0(dispatched_lsu0),  
    .instruction_lsu1(dispatched_lsu1),  
    .lsu0_Rt(lsu0_Rt),  
    .lsu0_Rs(lsu0_Rs),  
    .lsu1_Rt(lsu1_Rt),  
    .lsu1_Rs(lsu1_Rt),  
    .instruction_lsu0out(lsu0_fullins),  
    .instruction_lsu1out(lsu1_fullins)
);

scheduler_LoadStore_muxes LSU0 (
    .lsu_fullins(lsu0_fullins),  
    .alu0(alu0),  
    .alu1(alu1),  
    .alu2(alu2),  
    .alu3(alu3),  
    .lsu0(lsu0),  
    .lsu1(lsu1),  
	 
    .Rtoperand(lsu0_Rt_source),  
    .address(lsu0_address),  
    .ROBentry(lsu0_ROBentry),  
    .dest(lsu0_dest),  
    .operation(lsu0_operation)
);

scheduler_LoadStore_muxes LSU1 (
    .lsu_fullins(lsu1_fullins),  
    .alu0(alu0),  
    .alu1(alu1),  
    .alu2(alu2),  
    .alu3(alu3),  
    .lsu0(lsu0),  
    .lsu1(lsu1),
	 
    .Rtoperand(lsu1_Rt_source),  
    .address(lsu1_address),  
    .ROBentry(lsu1_ROBentry),  
    .dest(lsu1_dest),
    .operation(lsu1_operation)
);*/

endmodule 