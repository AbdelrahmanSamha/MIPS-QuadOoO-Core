module Commit_Stage (
	 input clk, rst, 
	 
	 //----------RENAME STAGE INPUTS---------//
	 input [3:0]valid_word,
	 input is_store0_rename, is_store1_rename, is_store2_rename, is_store3_rename,
	 input is_branch0_rename, is_branch1_rename, is_branch2_rename, is_branch3_rename,
	 input [4:0] arc0, arc1, arc2, arc3,
	 input [5:0] physicalreg0 , physicalreg1 , physicalreg2, physicalreg3,
	 input [5:0] stale_inst0, stale_inst1, stale_inst2, stale_inst3,
	 input [1:0] BID0, BID1, BID2, BID3,
	 
	 
	 
	 
	 //=========incoming stall signals=========//
	 
	 input stall_reservation_station, stall_reservation_station_LS,mt_stall,
	 //=========EXECUTE STAGE INPUTS=========//
	 input [4:0] ROBlsu0,
	 input lsu0valid,
	 input [4:0] ROBlsu1,
	 input lsu1valid,
	 input [4:0] ROBalu0,
	 input alu0valid,
	 input [4:0] ROBalu1,
	 input alu1valid,
	 input [4:0] ROBalu2,
	 input alu2valid,
	 
	 //branching Unit
	 input [4:0] ROBbu,
	 input buvalid,
	 input [1:0]BID,
	 input [6:0]BIDs_flush,
	 input resolution,	
		
	
	 //===========PRF values to commit ========//
	 input [31:0] PRFvalue0, PRFvalue1, PRFvalue2, PRFvalue3,

	 //==============OUTPUTS==========//
	 output [5:0] PRFindex0, PRFindex1, PRFindex2, PRFindex3, //we send the index to the prf and we get the value back from it. 
	 output [2:0] tail,
	 output stall,
	 output all_done,
	  
	 output [5:0] return_stale0 , return_stale1, return_stale2, return_stale3,
	 output 		  PNR0, PNR1, PNR2, PNR3,		//if active then the stale is valid to be returned, if not then the stale must not be returned. 
	 output [4:0]  ROB_sw_commit0,ROB_sw_commit1,
	 output  PNR_sw0, PNR_sw1						//if active then the ROB_sw_commit must be commited to the DATAmemory...
);

wire [23:0] head_bank0, head_bank1, head_bank2, head_bank3;

assign PRFindex0 = head_bank0[14:9];
assign PRFindex1 = head_bank1[14:9];
assign PRFindex2 = head_bank2[14:9];
assign PRFindex3 = head_bank3[14:9];

assign return_stale0 = head_bank0[8:3]; 
assign return_stale1 = head_bank1[8:3];
assign return_stale2 = head_bank2[8:3];
assign return_stale3 = head_bank3[8:3];



ROB rob_inst (
    .clk(clk),
    .rst(rst),
    
    .way0_Valid(valid_word[0]),
    .way0_sw(is_store0_rename),
    .way0_branch(is_branch0_rename),
    .way0_arcreg(arc0),
    .way0_physicalreg(physicalreg0),
    .way0_stale(stale_inst0),
    .way0_bid(BID0),
    
    .way1_Valid(valid_word[1]),
    .way1_sw(is_store1_rename),												
    .way1_branch(is_branch1_rename),
    .way1_arcreg(arc1),
    .way1_physicalreg(physicalreg1),
    .way1_stale(stale_inst1),
    .way1_bid(BID1),
    
    .way2_Valid(valid_word[2]),
    .way2_sw(is_store2_rename),
    .way2_branch(is_branch2_rename),
    .way2_arcreg(arc2),
    .way2_physicalreg(physicalreg2),
    .way2_stale(stale_inst2),
    .way2_bid(BID2),
    
    .way3_Valid(valid_word[3]),
    .way3_sw(is_store3_rename),
    .way3_branch(is_branch3_rename),
    .way3_arcreg(arc3),
    .way3_physicalreg(physicalreg3),
    .way3_stale(stale_inst3),
    .way3_bid(BID3),
	
	.stall_reservation_station(stall_reservation_station), .stall_reservation_station_LS(stall_reservation_station_LS), .mt_stall(mt_stall),
	
	//execute stage inputs
    .ROBlsu0(ROBlsu0),
    .lsu0valid(lsu0valid),
    .ROBlsu1(ROBlsu1),
    .lsu1valid(lsu1valid),
    .ROBalu0(ROBalu0),
    .alu0valid(alu0valid),
    .ROBalu1(ROBalu1),
    .alu1valid(alu1valid),
    .ROBalu2(ROBalu2),
    .alu2valid(alu2valid),
    

    .ROBbu(ROBbu),
    .buvalid(buvalid),
    .BID(BID),
	 .BIDs_flush(BIDs_flush),
    .resolution(resolution),

    .tail(tail),
    .all_done(all_done),
    .stall(stall),
    .head_bank0(head_bank0),
    .head_bank1(head_bank1),
    .head_bank2(head_bank2),
    .head_bank3(head_bank3),
	 .ROB_sw_commit0(ROB_sw_commit0),
	 .ROB_sw_commit1(ROB_sw_commit1),
	 .PNR_sw0(PNR_sw0),
	 .PNR_sw1(PNR_sw1)
);

ARF_commit arf_commit_inst (
    .clk          (clk),  // Connect clock signal
    .rst          (rst),  // Connect reset signal
    
    //==== Control Signals ====//
    .all_done     (all_done),  // Connect all_done signal from ROB
    
    //==== ROB Interface ====//
    .head_bank0   (head_bank0),  // Connect head_bank0 from ROB
    .head_bank1   (head_bank1),  // Connect head_bank1 from ROB
    .head_bank2   (head_bank2),  // Connect head_bank2 from ROB
    .head_bank3   (head_bank3),  // Connect head_bank3 from ROB
    
    //==== PRF Interface ====//
    .PRF_value0   (PRFvalue0),  // Connect PRF_value0 from PRF
    .PRF_value1   (PRFvalue1),  // Connect PRF_value1 from PRF
    .PRF_value2   (PRFvalue2),  // Connect PRF_value2 from PRF
    .PRF_value3   (PRFvalue3),  // Connect PRF_value3 from PRF
    .PNR0(PNR0),
	 .PNR1(PNR1),
	 .PNR2(PNR2),
	 .PNR3(PNR3)

);

endmodule