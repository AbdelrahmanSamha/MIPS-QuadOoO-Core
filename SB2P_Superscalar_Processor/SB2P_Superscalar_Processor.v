module SB2P_Superscalar_Processor(clk, rst ,stall_counter,stall_branch_priority_table,stop_fetch,
stall_reservation_station,stall_reservation_station_LS,ROB_stall,stall_frpools,stall_branching_unit,mt_stall,stall_freeid,is_branch_ES,hit,pc0,pc1);

    input clk, rst;

    // Wires for program counter and instructions
	 output wire [7:0] pc0,pc1;
    wire [31:0] instruction0_in, instruction1_in, instruction2_in, instruction3_in;
    wire [31:0] instruction0_out_fd1, instruction1_out_fd1, instruction2_out_fd1, instruction3_out_fd1;
    output stop_fetch;
	

	 wire write_on_rd0,write_on_rd1,write_on_rd2,write_on_rd3,
				 match0_rd1,match0_rd2,match0_rd3,match0_rs1a,match0_rs1b,
		       match0_rs2a,match0_rs2b,match0_rs3a,match0_rs3b,
			    match1_rd2,match1_rd3,match1_rs2a,match1_rs2b,match1_rs3a,match1_rs3b, 
				 match2_rd3,match2_rs3a,match2_rs3b;
		
	 wire [4:0] rd0,rd1,rd2,rd3;

	 
    // RAT and Free Register Pool signals
    wire [4:0] rat_read_index0, rat_read_index1, rat_read_index2, rat_read_index3,
               rat_read_index4, rat_read_index5, rat_read_index6, rat_read_index7,
               rat_read_index8, rat_read_index9, rat_read_index10, rat_read_index11;
					

    wire [5:0] rat_read_data0, rat_read_data1, rat_read_data2, rat_read_data3,
               rat_read_data4, rat_read_data5, rat_read_data6, rat_read_data7,
               rat_read_data8, rat_read_data9, rat_read_data10, rat_read_data11;



	 	
	 wire [17:0] rat_inst0,rat_inst1,rat_inst2,rat_inst3;
	 


		wire [5:0] allocate_rd0, allocate_rd1, allocate_rd2, allocate_rd3;

		wire [5:0] stale_inst0_rename,stale_inst1_rename, stale_inst2_rename, stale_inst3_rename;



		wire [5:0] out0_frpool,out1_frpool,out2_frpool,out3_frpool;// output_frpool
		
		
		wire [3:0] valid_word,valid_word_id2;
		// sorting unit
		
	 wire [3:0] rsv_write_index0, rsv_write_index1, rsv_write_index2, rsv_write_index3;
   
	 wire [40:0] rsv_write_data0, rsv_write_data1, rsv_write_data2, rsv_write_data3;

  
    wire [40:0] rsv_read_data0, rsv_read_data1, rsv_read_data2, rsv_read_data3, rsv_read_data4,
					 rsv_read_data5, rsv_read_data6, rsv_read_data7, rsv_read_data8, rsv_read_data9;
							
	 wire write_enable0_rsv, write_enable1_rsv , write_enable2_rsv, write_enable3_rsv;

	 wire [9:0] status_rsv;
	 wire [1:0] BID0,BID1,BID2,BID3, available_id;
	 wire [1:0] BID0out,BID1out,BID2out,BID3out;
	 wire is_branch;
	 output wire hit;

	 wire [9:0] Arithmetic_updated_status;
			
		wire[17:0] inst0_out, inst1_out, inst2_out, inst3_out;
		wire[4:0] rd0_out, rd1_out, rd2_out, rd3_out;
		wire match0_rd1_out, match0_rd2_out, match0_rd3_out;
		wire match0_rs1a_out, match0_rs1b_out;
		wire match0_rs2a_out, match0_rs2b_out;
		wire match0_rs3a_out, match0_rs3b_out;
		wire match1_rd2_out, match1_rd3_out;
		wire match1_rs2a_out, match1_rs2b_out;
		wire match1_rs3a_out, match1_rs3b_out;
		wire match2_rd3_out, match2_rs3a_out, match2_rs3b_out;
		wire write_on_rd0_out, write_on_rd1_out, write_on_rd2_out, write_on_rd3_out;
		wire partofbranch0in,partofbranch1in,partofbranch2in,partofbranch3in;
		wire partofbranch0out,partofbranch1out,partofbranch2out,partofbranch3out;
		
		
wire [5:0] return_stale0_commit_out, return_stale1_commit_out, return_stale2_commit_out, return_stale3_commit_out;

wire all_done_commit_out;

wire PNR0_commit_out, PNR1_commit_out, PNR2_commit_out, PNR3_commit_out;

															
			// is_branch out from decode stage 
		wire is_branch0_decode, is_branch1_decode, is_branch2_decode, is_branch3_decode;
		wire is_branch3_rename,is_branch2_rename,is_branch1_rename,is_branch0_rename;	
					//mt										
		wire [1:0] pointer_register0_out, pointer_register1_out, pointer_register2_out;
		
		wire way0modified0, way0modified1, way0modified2;
		wire way1modified0, way1modified1, way1modified2;
		wire way2modified0, way2modified1, way2modified2;
		wire way3modified0, way3modified1, way3modified2;
		wire [1:0] h_out_priority_table, m_out_priority_table, l_out_priority_table;
		
		wire [3:0 ]Free_ID_WR;
      wire [10:0] MT_out0,MT_out1,MT_out2,MT_out3,MT_out4,MT_out5,MT_out6,MT_out7,MT_out8,MT_out9;
		
      
		wire [63:0] frpool_reg_out;
			
												
			
		// write enables form incremental_controller to mapping table 
		wire writeEn0, writeEn1, writeEn2, writeEn3, 
		writeEn4, writeEn5, writeEn6, writeEn7,
		writeEn8, writeEn9, writeEn10,writeEn11;
		
		//reservation_station_lw_sw
		wire write_enable0_rsv_lw_sw, write_enable1_rsv_lw_sw, write_enable2_rsv_lw_sw, write_enable3_rsv_lw_sw;
		wire[36:0] inst0_out_rsv_ls, inst1_out_rsv_ls, inst2_out_rsv_ls, inst3_out_rsv_ls;

	
	// decode stage 
	wire [5:0] control_0_decode, control_1_decode, control_2_decode, control_3_decode;
			 
	wire [15:0] imm0_decode, imm1_decode, imm2_decode, imm3_decode;
	
	wire [5:0] control_decode_out0, control_decode_out1, control_decode_out2, control_decode_out3;
	
	wire [15:0] imm0_decode_out, imm1_decode_out, imm2_decode_out, imm3_decode_out;
	
	wire [63:0]	recovery_reg_mt;
	
	wire write_en_way0,write_en_way1,write_en_way2,write_en_way3;
	wire dep_sw0_lw1;
	
wire rs0validsource1;
wire rs0validsource2;
wire rs1validsource1;
wire rs1validsource2;
wire rs2validsource1;
wire rs2validsource2;
wire rs3validsource1;
wire rs3validsource2;
wire rs4validsource1;
wire rs4validsource2;
wire rs5validsource1;
wire rs5validsource2;
wire rs6validsource1;
wire rs6validsource2;
wire rs7validsource1;
wire rs7validsource2;
wire rs8validsource1;
wire rs8validsource2;
wire rs9validsource1;
wire rs9validsource2;
wire Rt0validsource;
wire Rt1validsource;
wire Rt2validsource;
wire Rt3validsource;
wire Rs0validsource;
wire Rs1validsource;
wire Rs2validsource;
wire Rs3validsource;


//==================================================================
// Wire Declarations for the schedule stage entering the readstage
//==================================================================
// --- ALU Segments ---
wire [4:0]  alu0_ROBentry_readpipe_in, alu1_ROBentry_readpipe_in, alu2_ROBentry_readpipe_in, alu3_ROBentry_readpipe_in;
wire [5:0]  alu0_dest_readpipe_in, alu1_dest_readpipe_in, alu2_dest_readpipe_in, alu3_dest_readpipe_in;
wire [3:0]  alu0_operation_readpipe_in, alu1_operation_readpipe_in, alu2_operation_readpipe_in, alu3_operation_readpipe_in;
wire [5:0]  alu0_s1_index_readpipe_in, alu1_s1_index_readpipe_in, alu2_s1_index_readpipe_in, alu3_s1_index_readpipe_in;
wire [1:0]  alu0_bid_readpipe_in, alu1_bid_readpipe_in, alu2_bid_readpipe_in, alu3_bid_readpipe_in;
wire        alu0_is_Itype_readpipe_in, alu1_is_Itype_readpipe_in, alu2_is_Itype_readpipe_in, alu3_is_Itype_readpipe_in;
wire [1:0]  alu0_s1_alu_forwarding_readpipe_in, alu1_s1_alu_forwarding_readpipe_in, alu2_s1_alu_forwarding_readpipe_in, alu3_s1_alu_forwarding_readpipe_in;
wire [1:0]  alu0_s2_alu_forwarding_readpipe_in, alu1_s2_alu_forwarding_readpipe_in, alu2_s2_alu_forwarding_readpipe_in, alu3_s2_alu_forwarding_readpipe_in;
wire [1:0]  alu0_s1_lsu_forwarding_readpipe_in, alu1_s1_lsu_forwarding_readpipe_in, alu2_s1_lsu_forwarding_readpipe_in, alu3_s1_lsu_forwarding_readpipe_in;
wire [1:0]  alu0_s2_lsu_forwarding_readpipe_in, alu1_s2_lsu_forwarding_readpipe_in, alu2_s2_lsu_forwarding_readpipe_in, alu3_s2_lsu_forwarding_readpipe_in;
wire        alu0_s1_needforwarding_readpipe_in, alu1_s1_needforwarding_readpipe_in, alu2_s1_needforwarding_readpipe_in, alu3_s1_needforwarding_readpipe_in;
wire        alu0_s2_needforwarding_readpipe_in, alu1_s2_needforwarding_readpipe_in, alu2_s2_needforwarding_readpipe_in, alu3_s2_needforwarding_readpipe_in;
wire [15:0] alu0_imm16b_readpipe_in, alu1_imm16b_readpipe_in, alu2_imm16b_readpipe_in, alu3_imm16b_readpipe_in;

// --- Branch Unit (BU) Segment ---
wire [4:0]  bu_ROBentry_readpipe_in;
wire [2:0]  bu_operation_readpipe_in;
wire [9:0]  bu_imm_readpipe_in;
wire [1:0]  bu_BID_readpipe_in;
wire        bu_prediction_readpipe_in;
wire [5:0]  bu_s1_index_readpipe_in, bu_s2_index_readpipe_in;
wire        bu_is_branch_readpipe_in, bu_is_Jr_readpipe_in;
wire [1:0]  bu_s1_alu_forwarding_readpipe_in, bu_s2_alu_forwarding_readpipe_in;
wire [1:0]  bu_s1_lsu_forwarding_readpipe_in, bu_s2_lsu_forwarding_readpipe_in;
wire        bu_s1_needforwarding_readpipe_in, bu_s2_needforwarding_readpipe_in;

// --- LSU Segments ---
wire [4:0]  lsu0_ROBentry_readpipe_in, lsu1_ROBentry_readpipe_in;

wire [1:0]  lsu0_operation_readpipe_in, lsu1_operation_readpipe_in;
wire [5:0]  lsu0_Rt_index_readpipe_in, lsu1_Rt_index_readpipe_in;
wire [5:0]  lsu0_Rs_index_readpipe_in, lsu1_Rs_index_readpipe_in;
wire [1:0]  lsu0_bid_readpipe_in, lsu1_bid_readpipe_in;
wire [1:0]  lsu0_Rt_alu_forwarding_readpipe_in, lsu1_Rt_alu_forwarding_readpipe_in;
wire [1:0]  lsu0_Rs_alu_forwarding_readpipe_in, lsu1_Rs_alu_forwarding_readpipe_in;
wire [1:0]  lsu0_Rt_lsu_forwarding_readpipe_in, lsu1_Rt_lsu_forwarding_readpipe_in;
wire [1:0]  lsu0_Rs_lsu_forwarding_readpipe_in, lsu1_Rs_lsu_forwarding_readpipe_in;
wire        lsu0_Rt_needforwarding_readpipe_in, lsu1_Rt_needforwarding_readpipe_in;
wire        lsu0_Rs_needforwarding_readpipe_in, lsu1_Rs_needforwarding_readpipe_in;
wire [15:0] lsu0_imm_readpipe_in, lsu1_imm_readpipe_in;

//==================================================================
// Wire Declarations for the readstage outputs
//==================================================================
// --- ALU Segments ---
wire [4:0]  alu0_ROBentry_readpipe_out, alu1_ROBentry_readpipe_out, alu2_ROBentry_readpipe_out, alu3_ROBentry_readpipe_out;
wire [5:0]  alu0_dest_readpipe_out, alu1_dest_readpipe_out, alu2_dest_readpipe_out, alu3_dest_readpipe_out;
wire [3:0]  alu0_operation_readpipe_out, alu1_operation_readpipe_out, alu2_operation_readpipe_out, alu3_operation_readpipe_out;
wire [5:0]  alu0_s1_index_readpipe_out, alu1_s1_index_readpipe_out, alu2_s1_index_readpipe_out, alu3_s1_index_readpipe_out;
wire [1:0]  alu0_bid_readpipe_out, alu1_bid_readpipe_out, alu2_bid_readpipe_out, alu3_bid_readpipe_out;

wire        alu0_is_Itype_readpipe_out, alu1_is_Itype_readpipe_out, alu2_is_Itype_readpipe_out, alu3_is_Itype_readpipe_out;
wire [1:0]  alu0_s1_alu_forwarding_readpipe_out, alu1_s1_alu_forwarding_readpipe_out, alu2_s1_alu_forwarding_readpipe_out, alu3_s1_alu_forwarding_readpipe_out;
wire [1:0]  alu0_s2_alu_forwarding_readpipe_out, alu1_s2_alu_forwarding_readpipe_out, alu2_s2_alu_forwarding_readpipe_out, alu3_s2_alu_forwarding_readpipe_out;
wire [1:0]  alu0_s1_lsu_forwarding_readpipe_out, alu1_s1_lsu_forwarding_readpipe_out, alu2_s1_lsu_forwarding_readpipe_out, alu3_s1_lsu_forwarding_readpipe_out;
wire [1:0]  alu0_s2_lsu_forwarding_readpipe_out, alu1_s2_lsu_forwarding_readpipe_out, alu2_s2_lsu_forwarding_readpipe_out, alu3_s2_lsu_forwarding_readpipe_out;
wire        alu0_s1_needforwarding_readpipe_out, alu1_s1_needforwarding_readpipe_out, alu2_s1_needforwarding_readpipe_out, alu3_s1_needforwarding_readpipe_out;
wire        alu0_s2_needforwarding_readpipe_out, alu1_s2_needforwarding_readpipe_out, alu2_s2_needforwarding_readpipe_out, alu3_s2_needforwarding_readpipe_out;
wire [15:0] alu0_imm16b_readpipe_out, alu1_imm16b_readpipe_out, alu2_imm16b_readpipe_out, alu3_imm16b_readpipe_out;



// --- Branch Unit (BU) Segment ---
wire [4:0]  bu_ROBentry_readpipe_out;
wire [2:0]  bu_operation_readpipe_out;
wire [9:0]  bu_imm_readpipe_out;
wire [1:0]  bu_BID_readpipe_out;
wire        bu_prediction_readpipe_out;
wire [5:0]  bu_s1_index_readpipe_out, bu_s2_index_readpipe_out;
wire        bu_is_branch_readpipe_out, bu_is_Jr_readpipe_out;
wire [1:0]  bu_s1_alu_forwarding_readpipe_out, bu_s2_alu_forwarding_readpipe_out;
wire [1:0]  bu_s1_lsu_forwarding_readpipe_out, bu_s2_lsu_forwarding_readpipe_out;
wire        bu_s1_needforwarding_readpipe_out, bu_s2_needforwarding_readpipe_out;

// --- LSU Segments ---
wire [4:0]  lsu0_ROBentry_readpipe_out, lsu1_ROBentry_readpipe_out;
wire [1:0]  lsu0_operation_readpipe_out, lsu1_operation_readpipe_out;
wire [5:0]  lsu0_Rt_index_readpipe_out, lsu1_Rt_index_readpipe_out;
wire [5:0]  lsu0_Rs_index_readpipe_out, lsu1_Rs_index_readpipe_out;
wire [1:0]  lsu0_bid_readpipe_out, lsu1_bid_readpipe_out;
wire [1:0]  lsu0_Rt_alu_forwarding_readpipe_out, lsu1_Rt_alu_forwarding_readpipe_out;
wire [1:0]  lsu0_Rs_alu_forwarding_readpipe_out, lsu1_Rs_alu_forwarding_readpipe_out;
wire [1:0]  lsu0_Rt_lsu_forwarding_readpipe_out, lsu1_Rt_lsu_forwarding_readpipe_out;
wire [1:0]  lsu0_Rs_lsu_forwarding_readpipe_out, lsu1_Rs_lsu_forwarding_readpipe_out;
wire        lsu0_Rt_needforwarding_readpipe_out, lsu1_Rt_needforwarding_readpipe_out;
wire        lsu0_Rs_needforwarding_readpipe_out, lsu1_Rs_needforwarding_readpipe_out;
wire [15:0] lsu0_imm_readpipe_out, lsu1_imm_readpipe_out;


// --- prf read for the readstage wires --- 
wire [31:0] alu0_s1_prf_out, alu0_s2_prf_out, alu1_s1_prf_out, alu1_s2_prf_out, 
            alu2_s1_prf_out, alu2_s2_prf_out, alu3_s1_prf_out, alu3_s2_prf_out;

	wire [31:0] Bu_s1_prf_out, Bu_s2_prf_out;		

	wire [31:0] lsu0_rt_prf_out, lsu0_rs_prf_out, lsu1_rt_prf_out, lsu1_rs_prf_out;
//==================================================================
// Wire Declarations for the ...
//==================================================================

// Declare wires for ExecuteStage outputs
wire [32:0] alu0_result_ES, alu1_result_ES, alu2_result_ES, alu3_result_ES,lsu0_result_ES,lsu1_result_ES;
output is_branch_ES; 
wire resolution_ES;
wire [5:0] lsu0_dest_address, lsu1_dest_address;
wire is_cache_full;

wire  valid0_lw_sw_rob_out, valid1_lw_sw_rob_out;

							  



	




// Declare output wires from the execute pipe to the execute stage.
wire [31:0] alu0_source1_exepipe_out, alu0_source2_exepipe_out;
wire [4:0]  alu0_ROBentry_exepipe_out;
wire [5:0]  alu0_dest_exepipe_out;
wire [3:0]  alu0_operation_exepipe_out;
wire [1:0]  alu0_bid_exepipe_out;

wire [31:0] alu1_source1_exepipe_out, alu1_source2_exepipe_out;
wire [4:0]  alu1_ROBentry_exepipe_out;
wire [5:0]  alu1_dest_exepipe_out;
wire [3:0]  alu1_operation_exepipe_out;
wire [1:0]  alu1_bid_exepipe_out;

wire [31:0] alu2_source1_exepipe_out, alu2_source2_exepipe_out;
wire [4:0]  alu2_ROBentry_exepipe_out;
wire [5:0]  alu2_dest_exepipe_out;
wire [3:0]  alu2_operation_exepipe_out;
wire [1:0]  alu2_bid_exepipe_out;

wire [31:0] alu3_source1_exepipe_out, alu3_source2_exepipe_out;
wire [4:0]  alu3_ROBentry_exepipe_out;
wire [5:0]  alu3_dest_exepipe_out;
wire [3:0]  alu3_operation_exepipe_out;
wire [1:0]  alu3_bid_exepipe_out;

wire [31:0] BU_source1_exepipe_out, BU_source2_exepipe_out;
wire [4:0]  BU_ROBentry_exepipe_out;
wire [2:0]  BU_operation_exepipe_out;
wire [9:0]  BU_imm_exepipe_out;
wire [1:0]  BU_BID_exepipe_out;
wire BU_prediction_exepipe_out;


wire [31:0] alu0_source1_exepipe_in, alu0_source2_exepipe_in;
wire [31:0] alu1_source1_exepipe_in, alu1_source2_exepipe_in;
wire [31:0] alu2_source1_exepipe_in, alu2_source2_exepipe_in;
wire [31:0] alu3_source1_exepipe_in, alu3_source2_exepipe_in;
wire [3:0] 	alu0_operation_exepipe_in , alu1_operation_exepipe_in, alu2_operation_exepipe_in, alu3_operation_exepipe_in;
wire [2:0] bu_operation_exepipe_in;
wire [1:0]  alu0_bid__exepipe_in, alu1_bid__exepipe_in, alu2_bid__exepipe_in;
wire [31:0] BU_source1_exepipe_in, BU_source2_exepipe_in;
wire [31:0] lsu0_Rt_exepipe_in;
wire [31:0] lsu0_address_exepipe_in;
wire [31:0] lsu1_Rt_exepipe_in;
wire [31:0] lsu1_address_exepipe_in;
	
	
	
wire [9:0] address_B_Jr;
wire [6:0] BIDs_flush;
wire branching_flush0, branching_flush1, branching_flush2, branching_flush3;
wire [9:0] branch_target_fs_out;

//==================================================================
// Wire stall_branch_priority_table
//==================================================================
output wire stall_branch_priority_table;
wire flush_branch_Miss;
//==================================================================
// stall_reservation_station /// 
//==================================================================
output wire stall_reservation_station;
output wire stall_reservation_station_LS;
output stall_freeid;
wire stall_LS;

//-=================================================================
//commit stage wires 
//==================================================================
wire [5:0] commit_index0, commit_index1, commit_index2, commit_index3; 
wire [31:0] commit_value0, commit_value1, commit_value2, commit_value3;


wire [4:0]ROB_sw_commit0,ROB_sw_commit1;


wire [4:0] fs_read_index_jr;
wire [5:0] fs_read_data_jr_prf_index;

wire [10:0] jr_address_prf;

output wire stall_branching_unit;

output wire stall_frpools;
output mt_stall;
wire stall_allocate_rd0, stall_allocate_rd1, stall_allocate_rd2, stall_allocate_rd3;

//lsu dependency check 
wire dep_lw0_sw1, dep_sw0_sw1_mux;





	 
	 
	 /********************************/
	output wire ROB_stall;
	 
	 
	 output stall_counter;
	 
	 assign stall_counter = (stall_branch_priority_table | stall_reservation_station |
									stall_reservation_station_LS | ROB_stall |stall_frpools | stall_branching_unit | mt_stall) ? 1'b1 : 1'b0;
	 
	 
	 
	 /************************************/


wire valid_index_rat, valid_index_prf;

wire valid_index_fs;



    // Fetch Stage Instance
    FetchStage FS (
        .clk(clk),.pc0_out(pc0),.pc1_out(pc1),.reset(rst),
        .inst0(instruction0_in),
        .inst1(instruction1_in),
        .inst2(instruction2_in),
        .inst3(instruction3_in),
		  .Address_Branch(address_B_Jr),
		  
		  .hit(hit),
		  .is_branchexe(is_branch_ES),
		  .branching_flush0(branching_flush0), 
		  .branching_flush1(branching_flush1), 
		  .branching_flush2(branching_flush2), 
		  .branching_flush3(branching_flush3),
		  .Stall(stall_branch_priority_table | stall_reservation_station | stall_reservation_station_LS | ROB_stall |stall_frpools | mt_stall | stall_freeid),
		  

		  .write_on_rd0_decode(write_on_rd0),  // input from decode 
		  .write_on_rd1_decode(write_on_rd1),
		  .write_on_rd2_decode(write_on_rd2),
		  .write_on_rd3_decode(write_on_rd3),
		  
		  .rd0_decode(rd0),
		  .rd1_decode(rd1),
		  .rd2_decode(rd2),
		  .rd3_decode(rd3),
		  .stall_branching_unit(stall_branching_unit),
		  
		  .jr_address_prf(jr_address_prf),  // input from prf stage 
		  		  .jr_index_out(fs_read_index_jr), // input from fetch stage  
		  .valid_index_fs_out(valid_index_fs),
		  .valid_index_prf_in(valid_index_prf),
		  .stop_fetch(stop_fetch)
    );	 
	 
    // IF/ID Stage Instance
    IFID1 IFID_1 (
        .clk(clk),
        .rst(rst),
        .inst0_in(instruction0_in),
        .inst1_in(instruction1_in),
        .inst2_in(instruction2_in),
        .inst3_in(instruction3_in),
        .inst0_out(instruction0_out_fd1),
        .inst1_out(instruction1_out_fd1),
        .inst2_out(instruction2_out_fd1),
        .inst3_out(instruction3_out_fd1),
		  .flush0(branching_flush0),
		  .flush1(branching_flush1),
		  .flush2(branching_flush2),
		  .flush3(branching_flush3),
		  
		  .flush_branch_Miss((is_branch_ES && !hit)),

		  
		  //stall if branch_priority_table is full
		  .stall_branch_priority_table(stall_branch_priority_table | stall_freeid),
		  .stall_reservation_station_LS(stall_reservation_station_LS),
		  .stall_reservation_station(stall_reservation_station |stall_frpools | mt_stall ),
		  .ROB_stall(ROB_stall),
		  .stall_branching_unit(stall_branching_unit)
    );
    // Decode Stage Instance
    decode_stage decoder (
		  .clk(clk), .rst(rst ),
        .instruction0(instruction0_out_fd1),
        .instruction1(instruction1_out_fd1),
        .instruction2(instruction2_out_fd1),
        .instruction3(instruction3_out_fd1),
		  .rat_inst0(rat_inst0),
		  .rat_inst1(rat_inst1),
		  .rat_inst2(rat_inst2),
		  .rat_inst3(rat_inst3),
		  .rat_read_index0(rat_read_index0),
		  .rat_read_index1(rat_read_index1),
		  .rat_read_index2(rat_read_index2),
		  .rat_read_index3(rat_read_index3),
		  .rat_read_index4(rat_read_index4), 
		  .rat_read_index5(rat_read_index5),
		  .rat_read_index6(rat_read_index6), 
	     .rat_read_index7(rat_read_index7), 
		  .rat_read_index8(rat_read_index8),
		  .rat_read_index9(rat_read_index9), 
		  .rat_read_index10(rat_read_index10), 
		  .rat_read_index11(rat_read_index11),
		  .rat_read_data0(rat_read_data0), 
		  .rat_read_data1(rat_read_data1),
		  .rat_read_data2(rat_read_data2),
		  .rat_read_data3(rat_read_data3), 
		  .rat_read_data4(rat_read_data4),
		  .rat_read_data5(rat_read_data5),
		  .rat_read_data6(rat_read_data6),
		  .rat_read_data7(rat_read_data7),
		  .rat_read_data8(rat_read_data8),
		  .rat_read_data9(rat_read_data9), 
	  	  .rat_read_data10(rat_read_data10),
		  .rat_read_data11(rat_read_data11),
		  
		  .write_on_rd0(write_on_rd0),
		  .write_on_rd1(write_on_rd1),
		  .write_on_rd2(write_on_rd2),
		  .write_on_rd3(write_on_rd3),
		  .match0_rd1(match0_rd1),
		  .match0_rd2(match0_rd2),
		  .match0_rd3(match0_rd3),
		  .match0_rs1a(match0_rs1a),
		  .match0_rs1b(match0_rs1b),
		  .match0_rs2a(match0_rs2a),
		  .match0_rs2b(match0_rs2b),
		  .match0_rs3a(match0_rs3a),
		  .match0_rs3b(match0_rs3b),
		  .match1_rd2(match1_rd2),
		  .match1_rd3(match1_rd3),
		  .match1_rs2a(match1_rs2a),
		  .match1_rs2b(match1_rs2b),
		  .match1_rs3a(match1_rs3a),
		  .match1_rs3b(match1_rs3b),
		  .match2_rd3(match2_rd3),
		  .match2_rs3a(match2_rs3a),
		  .match2_rs3b(match2_rs3b),
		  .rd0(rd0),
		  .rd1(rd1),
		  .rd2(rd2),
		  .rd3(rd3),
		  
		  .valid_word(valid_word),
		  .BID0(BID0),
		  .BID1(BID1),
		  .BID2(BID2),
		  .BID3(BID3),
		  .is_branch(is_branch),
		  .available_id(available_id),
		  
		  .branch_resolved(is_branch_ES),
		  .BID_resolve(BU_BID_exepipe_out),
		  
		  .hit(hit),
	 
		  .partofbranch0(partofbranch0in),
		  .partofbranch1(partofbranch1in),
		  .partofbranch2(partofbranch2in),
		  .partofbranch3(partofbranch3in),
		  
		  .is_branch0(is_branch0_decode),
		  .is_branch1(is_branch1_decode),
		  .is_branch2(is_branch2_decode),
		  .is_branch3(is_branch3_decode),
		  
		  .control_0(control_0_decode),
		  .control_1(control_1_decode),
		  .control_2(control_2_decode),
		  .control_3(control_3_decode),
		  
		  .imm0(imm0_decode),
		  .imm1(imm1_decode),
		  .imm2(imm2_decode),
		  .imm3(imm3_decode),
		  
		  // input from priority_table to free_branch_id 
		  .h_in(h_out_priority_table),	  
		  .m_in(m_out_priority_table),	  
		  .l_in(l_out_priority_table),
		
		  .rd0_rename(rd0_out),
		  .rd1_rename(rd1_out),
		  .rd2_rename(rd2_out),
		  .rd3_rename(rd3_out),
		  .iswrite_rename0(write_on_rd0_out),
		  .iswrite_rename1(write_on_rd1_out),
		  .iswrite_rename2(write_on_rd2_out),
		  .iswrite_rename3(write_on_rd3_out),
		  .physicalway0_rename(allocate_rd0),
		  .physicalway1_rename(allocate_rd1),
		  .physicalway2_rename(allocate_rd2),
		  .physicalway3_rename(allocate_rd3),
		  .stall_in(stall_reservation_station | stall_reservation_station_LS | ROB_stall | stall_frpools | mt_stall),
		  .stall_freeid(stall_freeid),
		  .BIDs_flush(BIDs_flush)
			  
		  );
		
		//assign Free_ID_WR = {hit,is_branch_ES,BU_BID_exepipe_out};
		
		branch_priority_table PT(.clk(clk),.rst(rst),
										.branch_ID(available_id),.is_branch(is_branch),.branch_resolved(is_branch_ES),.resolved_ID(BU_BID_exepipe_out),// we get these two when we design the ALU (.branch_resolved(),.resolved_ID())
										.H(h_out_priority_table),.M(m_out_priority_table),.L(l_out_priority_table),
										.hit(hit),
										
										.stall_in(stall_reservation_station | stall_reservation_station_LS | ROB_stall |stall_frpools | mt_stall),
										
										.stall(stall_branch_priority_table));
									
		mapping_table MT(.clk(clk),.reset(rst),.current_branch_ID(available_id),.allocate_table(is_branch),

                                .arch_reg0(rd0_out),.arch_reg1(rd1_out),.arch_reg2(rd2_out),.arch_reg3(rd3_out),
                                .old_phys_reg0(stale_inst0_rename),.old_phys_reg1(stale_inst1_rename),.old_phys_reg2(stale_inst2_rename),.old_phys_reg3(stale_inst3_rename),
										  
										  .BID0out(BID0out),.BID1out(BID1out),.BID2out(BID2out),.BID3out(BID3out),
										  .hit(hit),.is_branch_exe(is_branch_ES), 
										  .branch_ID(BU_BID_exepipe_out),
										  
										  .is_branch(is_branch0_rename | is_branch1_rename | is_branch2_rename | is_branch3_rename), 
										  .is_branch0(is_branch0_rename),
										  .is_branch1(is_branch1_rename),
										  .is_branch2(is_branch2_rename),
										  .is_branch3(is_branch3_rename), 
										  
										  .inst_write0(write_on_rd0_out),.inst_write1(write_on_rd1_out),.inst_write2(write_on_rd2_out),.inst_write3(write_on_rd3_out),
										  
										  .allocate_dest_Reg0(allocate_rd0),.allocate_dest_Reg1(allocate_rd1),.allocate_dest_Reg2(allocate_rd2),.allocate_dest_Reg3(allocate_rd3), // allocate_dest_reg for each way 
										  .frpool_current_reg(frpool_reg_out),
										  
                                .way0modified0(way0modified0), .way0modified1(way0modified1), .way0modified2(way0modified2),//output
                                .way1modified0(way1modified0), .way1modified1(way1modified1), .way1modified2(way1modified2),
                                .way2modified0(way2modified0), .way2modified1(way2modified1), .way2modified2(way2modified2),
                                .way3modified0(way3modified0), .way3modified1(way3modified1), .way3modified2(way3modified2),

                                .writeEn0(writeEn0), .writeEn1(writeEn1), .writeEn2(writeEn2), .writeEn3(writeEn3), 
                                .writeEn4(writeEn4), .writeEn5(writeEn5), .writeEn6(writeEn6), .writeEn7(writeEn7),
                                .writeEn8(writeEn8), .writeEn9(writeEn9), .writeEn10(writeEn10),.writeEn11(writeEn11),
											//batch ready to commit
                                .all_done(all_done_commit_out), // frpool 
                                 //to return to the free list of registers from commit. 
                                .return_stale0(return_stale0_commit_out),
                                .return_stale1(return_stale1_commit_out),
                                .return_stale2(return_stale2_commit_out),
                                .return_stale3(return_stale3_commit_out),

                                .PNR0(PNR0_commit_out),//if active then the stale is valid to be returned, if not then the stale must not be returned.
                                .PNR1(PNR1_commit_out),
                                .PNR2(PNR2_commit_out),
                                .PNR3(PNR3_commit_out),
                                .Pointer_register0(pointer_register0_out), .Pointer_register1(pointer_register1_out), .Pointer_register2(pointer_register2_out),

                                .MT_out0(MT_out0),.MT_out1(MT_out1),.MT_out2(MT_out2),.MT_out3(MT_out3),.MT_out4(MT_out4),.MT_out5(MT_out5),
                                .MT_out6(MT_out6),.MT_out7(MT_out7),.MT_out8(MT_out8),.MT_out9(MT_out9),
                                
										  
										  .status_reg(recovery_reg_mt),
										 
										  .H(h_out_priority_table),.M(m_out_priority_table),.L(l_out_priority_table),
										  .mt_stall(mt_stall),
										  .stallafterdecode(stall_frpools | stall_reservation_station_LS | stall_reservation_station |  ROB_stall | stall_branch_priority_table )
										  
                                );
							

		Incremental_controller controller (.partofbranch0(partofbranch0out),.partofbranch1(partofbranch1out),.partofbranch2(partofbranch2out),.partofbranch3(partofbranch3out),
														
														.way0modified0(way0modified0), .way0modified1(way0modified1), .way0modified2(way0modified2),//input
														.way1modified0(way1modified0), .way1modified1(way1modified1), .way1modified2(way1modified2),
														.way2modified0(way2modified0), .way2modified1(way2modified1), .way2modified2(way2modified2),
														.way3modified0(way3modified0), .way3modified1(way3modified1), .way3modified2(way3modified2),
														.H(h_out_priority_table),.M(m_out_priority_table),.L(l_out_priority_table),
														
														.writeEn0(writeEn0), .writeEn1(writeEn1), .writeEn2(writeEn2), .writeEn3(writeEn3), 
														.writeEn4(writeEn4), .writeEn5(writeEn5), .writeEn6(writeEn6), .writeEn7(writeEn7),
														.writeEn8(writeEn8), .writeEn9(writeEn9), .writeEn10(writeEn10),.writeEn11(writeEn11),
														
														.is_branch0(is_branch0_rename), .is_branch1(is_branch1_rename),.is_branch2(is_branch2_rename),.is_branch3(is_branch3_rename),/////////////from rename
														
														.matchd0_d1(match0_rd1_out), .matchd0_d2(match0_rd2_out), .matchd0_d3(match0_rd3_out),
													   .matchd1_d2(match1_rd2_out), .matchd1_d3(match1_rd3_out),
													   .matchd2_d3(match2_rd3_out),
														
														.pointer_register0(pointer_register0_out), .pointer_register1(pointer_register1_out), .pointer_register2(pointer_register2_out)
														);

													
    // ID/ID Stage Instance
    IDID2 IDID_2 (
    .clk(clk),
    .rst(rst),
    .inst0_in(rat_inst0),
    .inst1_in(rat_inst1),
    .inst2_in(rat_inst2),
    .inst3_in(rat_inst3),
    .rd0_in(rd0),
    .rd1_in(rd1),
    .rd2_in(rd2),
    .rd3_in(rd3),
    .match0_rd1_in(match0_rd1),
    .match0_rd2_in(match0_rd2),
    .match0_rd3_in(match0_rd3),
    .match0_rs1a_in(match0_rs1a),
    .match0_rs1b_in(match0_rs1b),
    .match0_rs2a_in(match0_rs2a),
    .match0_rs2b_in(match0_rs2b),
    .match0_rs3a_in(match0_rs3a),
    .match0_rs3b_in(match0_rs3b),
    .match1_rd2_in(match1_rd2),
    .match1_rd3_in(match1_rd3),
    .match1_rs2a_in(match1_rs2a),
    .match1_rs2b_in(match1_rs2b),
    .match1_rs3a_in(match1_rs3a),
    .match1_rs3b_in(match1_rs3b),
    .match2_rd3_in(match2_rd3),
    .match2_rs3a_in(match2_rs3a),
    .match2_rs3b_in(match2_rs3b),
	 .write_on_rd0_in(write_on_rd0),
    .write_on_rd1_in(write_on_rd1),
    .write_on_rd2_in(write_on_rd2),
    .write_on_rd3_in(write_on_rd3),
	 .BID0in(BID0),
	 .BID1in(BID1),
	 .BID2in(BID2),
	 .BID3in(BID3),
	 .partofbranch0in(partofbranch0in),.partofbranch1in(partofbranch1in),.partofbranch2in(partofbranch2in),.partofbranch3in(partofbranch3in),
	 .is_branch0_in(is_branch0_decode),.is_branch1_in(is_branch1_decode), .is_branch2_in(is_branch2_decode),.is_branch3_in(is_branch3_decode),
	 .control_decode_0(control_0_decode),// input from decpde stage
	 .control_decode_1(control_1_decode),
	 .control_decode_2(control_2_decode),
	 .control_decode_3(control_3_decode),
	
	
	
	 .rd0_out(rd0_out),
    .rd1_out(rd1_out),
    .rd2_out(rd2_out),
    .rd3_out(rd3_out),
	 .inst0_out(inst0_out),
    .inst1_out(inst1_out),
    .inst2_out(inst2_out),
    .inst3_out(inst3_out),
	 
    .match0_rd1_out(match0_rd1_out),
    .match0_rd2_out(match0_rd2_out),
    .match0_rd3_out(match0_rd3_out),
    .match0_rs1a_out(match0_rs1a_out),
    .match0_rs1b_out(match0_rs1b_out),
    .match0_rs2a_out(match0_rs2a_out),
    .match0_rs2b_out(match0_rs2b_out),
    .match0_rs3a_out(match0_rs3a_out),
    .match0_rs3b_out(match0_rs3b_out),
    .match1_rd2_out(match1_rd2_out),
    .match1_rd3_out(match1_rd3_out),
    .match1_rs2a_out(match1_rs2a_out),
    .match1_rs2b_out(match1_rs2b_out),
    .match1_rs3a_out(match1_rs3a_out),
    .match1_rs3b_out(match1_rs3b_out),
    .match2_rd3_out(match2_rd3_out),
    .match2_rs3a_out(match2_rs3a_out),
    .match2_rs3b_out(match2_rs3b_out),
	 .write_on_rd0_out(write_on_rd0_out),
    .write_on_rd1_out(write_on_rd1_out),
    .write_on_rd2_out(write_on_rd2_out),
    .write_on_rd3_out(write_on_rd3_out),
	 
	.BID0out(BID0out),///  the rename.
	.BID1out(BID1out),///  the rename.
	.BID2out(BID2out),/// the rename.
	.BID3out(BID3out),///  the rename.
	 
	.partofbranch0out(partofbranch0out),.partofbranch1out(partofbranch1out),.partofbranch2out(partofbranch2out),.partofbranch3out(partofbranch3out),
	.valid_word_in(valid_word),
	.valid_word_out(valid_word_id2), // input to the sorting unit
	
	 
	 
	 .imm0_decode(imm0_decode),// input from decpde stage
	 .imm1_decode(imm1_decode),
	 .imm2_decode(imm2_decode),
	 .imm3_decode(imm3_decode),
	 
	 .stall_branch_priority_table(stall_branch_priority_table | stall_freeid), //stall if branch_priority_table is full
	 .stall_reservation_station_LS(stall_reservation_station_LS),
	 .ROB_stall(ROB_stall),
	 .mt_stall(mt_stall),
	 .stall_reservation_station(stall_reservation_station),
	 .flush_branch_Miss((is_branch_ES && !hit)),
	 .control_decode_out0(control_decode_out0), // output from IDID2
	 .control_decode_out1(control_decode_out1),
	 .control_decode_out2(control_decode_out2),
	 .control_decode_out3(control_decode_out3), 
	 
	 .is_branch3_out(is_branch3_rename),.is_branch2_out(is_branch2_rename),.is_branch1_out(is_branch1_rename),.is_branch0_out(is_branch0_rename),
	 .imm0_decode_out(imm0_decode_out), // output from IDID2
	 .imm1_decode_out(imm1_decode_out),
	 .imm2_decode_out(imm2_decode_out),
	 .imm3_decode_out(imm3_decode_out),
	 
	 .stall_frpools(stall_frpools)
	 
	 
	
);
	wire is_store0_rename  ,is_store1_rename ,is_store2_rename ,is_store3_rename;
	wire [2:0] tail;
	wire [1:0]BID0_new_rename,BID1_new_rename,BID2_new_rename,BID3_new_rename;
    // Rename Stage Instance
    rename_stage rename (
			.clk(clk), .rst(rst), 
			
			//way0 input 
			.instruction0_18b(inst0_out),
			.iswrite0(write_on_rd0_out),
			.matchd0_d1(match0_rd1_out), 
			.matchd0_d2(match0_rd2_out),
			.matchd0_d3(match0_rd3_out),
			.match0_rs1a(match0_rs1a_out),
			.match0_rs1b(match0_rs1b_out),
			.match0_rs2a(match0_rs2a_out),
			.match0_rs2b(match0_rs2b_out),
			.match0_rs3a(match0_rs3a_out),
			.match0_rs3b(match0_rs3b_out),
			.new_allocate_rd0(out0_frpool),
			.ROBentry0({tail,2'b00}),////comes from ROB
			.opcode0(control_decode_out0), 
			.imm0(imm0_decode_out),
			.isBranch0(is_branch0_rename),
			.BID0(BID0out),
			
			//way1 input 
			.instruction1_18b(inst1_out),
			.iswrite1(write_on_rd1_out),
			.matchd1_d2(match1_rd2_out),
			.matchd1_d3(match1_rd3_out),
			.match1_rs2a(match1_rs2a_out),
			.match1_rs2b(match1_rs2b_out),
			.match1_rs3a(match1_rs3a_out),
			.match1_rs3b(match1_rs3b_out),
			.new_allocate_rd1(out1_frpool),
			.ROBentry1({tail,2'b01}),////comes from ROB
			.opcode1(control_decode_out1), 
			.imm1(imm1_decode_out),
			.isBranch1(is_branch1_rename),
			.BID1(BID1out),
			
			//way2 input 
			.instruction2_18b(inst2_out),
			.iswrite2(write_on_rd2_out),
			.matchd2_d3(match2_rd3_out),
			.match2_rs3a(match2_rs3a_out),
			.match2_rs3b(match2_rs3b_out),
			.new_allocate_rd2(out2_frpool),
			.ROBentry2({tail,2'b10}),////comes from ROB
			.opcode2(control_decode_out2), 
			.imm2(imm2_decode_out),
			.isBranch2(is_branch2_rename),
			.BID2(BID2out),
			
			//way3 input 
			.instruction3_18b(inst3_out),
			.iswrite3(write_on_rd3_out),
			.new_allocate_rd3(out3_frpool),
			.ROBentry3({tail,2'b11}),////comes from ROB
			.opcode3(control_decode_out3), 
			.imm3(imm3_decode_out),
			.isBranch3(is_branch3_rename),
			.BID3(BID3out),
			
			//output way0
			.writeEn_way0(write_en_way0),
			.allocate_rd0(allocate_rd0),
	
			//output way1
			.allocate_rd1(allocate_rd1),
			.writeEn_way1(write_en_way1),
	
			//output way2
			.allocate_rd2(allocate_rd2),
			.writeEn_way2(write_en_way2),
	
			//output way3
			.allocate_rd3(allocate_rd3),
			.writeEn_way3(write_en_way3),
			
			//sorting unit 
			.valid_word(valid_word_id2),
			
			.status(status_rsv),
			.updated_status(Arithmetic_updated_status),
			
			.write_index0(rsv_write_index0), 
			.write_index1(rsv_write_index1), 
			.write_index2(rsv_write_index2), 
			.write_index3(rsv_write_index3),
			 
			.write_data0(rsv_write_data0),
			.write_data1(rsv_write_data1), 
			.write_data2(rsv_write_data2),
			.write_data3(rsv_write_data3),
									
			.write_enable0_rsv(write_enable0_rsv),
			.write_enable1_rsv(write_enable1_rsv),
			.write_enable2_rsv(write_enable2_rsv),
			.write_enable3_rsv(write_enable3_rsv),
			
			
			
			// write enbales for the reservation_station_lw_sw 
			.write_enable0_rsv_lw_sw(write_enable0_rsv_lw_sw),
			.write_enable1_rsv_lw_sw(write_enable1_rsv_lw_sw),
			.write_enable2_rsv_lw_sw(write_enable2_rsv_lw_sw),
			.write_enable3_rsv_lw_sw(write_enable3_rsv_lw_sw),
			
			.is_store0(is_store0_rename),
			.is_store1(is_store1_rename),
			.is_store2(is_store2_rename),
			.is_store3(is_store3_rename),
			.stale_inst0(stale_inst0_rename),
			.stale_inst1(stale_inst1_rename),
			.stale_inst2(stale_inst2_rename),
			.stale_inst3(stale_inst3_rename),
			.stall(stall_reservation_station),
			.BIDs_flush(BIDs_flush),
			
			.hit(hit),.is_branch_exe(is_branch_ES),
				
			.stall_frpools(stall_frpools),  // output 
			
			.stall_allocate_rd0(stall_allocate_rd0),  // output only for frpools 
			.stall_allocate_rd1(stall_allocate_rd1), 
			.stall_allocate_rd2(stall_allocate_rd2), 
			.stall_allocate_rd3(stall_allocate_rd3) ,
			
			.mt_stall(mt_stall),
			.ROB_stall(ROB_stall),
 	      
			.stall_reservation_station_LS(stall_reservation_station_LS),
			
			.out0_fr_is_zero(out0_fr_is_zero), 
			.out1_fr_is_zero(out1_fr_is_zero),
			.out2_fr_is_zero(out2_fr_is_zero),
			.out3_fr_is_zero(out3_fr_is_zero),
			
			// new ID to the ROB buffer
			.BID0_temp(BID0_new_rename),
			.BID1_temp(BID1_new_rename),
			.BID2_temp(BID2_new_rename),
			.BID3_temp(BID3_new_rename)

    );
	 

    // Register Alias Table Instance
		RAT rat(
			 .clk(clk),
			 .reset(rst),
			 //decodestage read (12 ports)
			 .read_index0(rat_read_index0),
			 .read_index1(rat_read_index1),
			 .read_index2(rat_read_index2),
			 .read_index3(rat_read_index3),
			 .read_index4(rat_read_index4),
			 .read_index5(rat_read_index5),
			 .read_index6(rat_read_index6),
			 .read_index7(rat_read_index7),
			 .read_index8(rat_read_index8),
			 .read_index9(rat_read_index9),
			 .read_index10(rat_read_index10),
			 .read_index11(rat_read_index11),
			 
			 .read_data0(rat_read_data0),
			 .read_data1(rat_read_data1),
			 .read_data2(rat_read_data2),
			 .read_data3(rat_read_data3),
			 .read_data4(rat_read_data4),
			 .read_data5(rat_read_data5),
			 .read_data6(rat_read_data6),
			 .read_data7(rat_read_data7),
			 .read_data8(rat_read_data8),
			 .read_data9(rat_read_data9),
			 .read_data10(rat_read_data10),
			 .read_data11(rat_read_data11),
			 
			 //rename stage write (4ports)
			 .write_index0(rd0_out),//rd0 from idid2
			 .write_index1(rd1_out),//rd1 from idid2
			 .write_index2(rd2_out),//rd2 from idid2
			 .write_index3(rd3_out),//rd3 from idid2
			
			 .write_data0(allocate_rd0),//allocate_rd0 port from rename stage outputs
			 .write_data1(allocate_rd1),//allocate_rd1 port from rename stage outputs
			 .write_data2(allocate_rd2),//allocate_rd2 port from rename stage outputs
			 .write_data3(allocate_rd3),//allocate_rd3 port from rename stage outputs
			 
			 .write_en_way0(write_en_way0),
			 .write_en_way1(write_en_way1),
			 .write_en_way2(write_en_way2),
			 .write_en_way3(write_en_way3),
			 	 
			 .Branch_Miss((!hit && is_branch_ES)),
			 .MT_in0(MT_out0),
			 .MT_in1(MT_out1),
			 .MT_in2(MT_out2),
			 .MT_in3(MT_out3),
			 .MT_in4(MT_out4),
			 .MT_in5(MT_out5),
			 .MT_in6(MT_out6),
			 .MT_in7(MT_out7),
			 .MT_in8(MT_out8),
			 .MT_in9(MT_out9),
			 .mt_stall(mt_stall),
			 			 
			 .fs_read_index_jr(fs_read_index_jr), // input from fetch stage 
			 .valid_index_fs_in(valid_index_fs), // input form fetch stage 
			 
			 .read_data_jr(fs_read_data_jr_prf_index),  // output to prf as index 
			 .valid_index_out_rat(valid_index_rat) // output to prf 

);



	
frpools frpools_instance (
    .clk(clk),
    .rst(rst),
    
	 .write_on_rd0_out(write_on_rd0_out),
    .write_on_rd1_out(write_on_rd1_out),
    .write_on_rd2_out(write_on_rd2_out),
    .write_on_rd3_out(write_on_rd3_out),
    
	 .recovery_reg_mt(recovery_reg_mt), // 64 bit 
    .isbranchexe(is_branch_ES),
	 .hit(hit),
   
    .stall_reservation_station(stall_reservation_station),
    .stall_reservation_station_LS(stall_reservation_station_LS),
	 
	 .out0_frpool(out0_frpool),
    .out1_frpool(out1_frpool),
    .out2_frpool(out2_frpool),
    .out3_frpool(out3_frpool),
    
	 .frpool_reg_out(frpool_reg_out),
	 
	 	//batch ready to commit
    .all_done(all_done_commit_out), // frpool 
	//to return to the free list of registers from commit. 
	 .return_stale0(return_stale0_commit_out),
	 .return_stale1(return_stale1_commit_out),
	 .return_stale2(return_stale2_commit_out),
	 .return_stale3(return_stale3_commit_out),
	
	 .PNR0(PNR0_commit_out),//if active then the stale is valid to be returned, if not then the stale must not be returned.
	 .PNR1(PNR1_commit_out),
	 .PNR2(PNR2_commit_out),
	 .PNR3(PNR3_commit_out),
	 
	 .stall_allocate_rd0(stall_allocate_rd0), 
	 .stall_allocate_rd1(stall_allocate_rd1), 
	 .stall_allocate_rd2(stall_allocate_rd2), 
	 .stall_allocate_rd3(stall_allocate_rd3),
	 
	 .mt_stall(mt_stall),
	 
	 .ROB_stall(ROB_stall),

	 .physical_way0(allocate_rd0),
	 .physical_way1(allocate_rd1),
	 .physical_way2(allocate_rd2),
	 .physical_way3(allocate_rd3),
	 
	 .out0_fr_is_zero(out0_fr_is_zero), // output to rename stage
	 .out1_fr_is_zero(out1_fr_is_zero),
	 .out2_fr_is_zero(out2_fr_is_zero),
	 .out3_fr_is_zero(out3_fr_is_zero),
	 
	 .allocate_rd0_in(allocate_rd0),
	 .allocate_rd1_in(allocate_rd1),
	 .allocate_rd2_in(allocate_rd2),
	 .allocate_rd3_in(allocate_rd3)


		
);

		// reservation_station	
    reservation_station reservation_reg(
        .clk(clk),
        .reset(rst),
		  
        .read_data0(rsv_read_data0),
        .read_data1(rsv_read_data1),
        .read_data2(rsv_read_data2),
        .read_data3(rsv_read_data3),
        .read_data4(rsv_read_data4),
        .read_data5(rsv_read_data5),
        .read_data6(rsv_read_data6),
        .read_data7(rsv_read_data7),
        .read_data8(rsv_read_data8),
        .read_data9(rsv_read_data9),
		  
        .write_index0(rsv_write_index0),
        .write_index1(rsv_write_index1),
        .write_index2(rsv_write_index2),
        .write_index3(rsv_write_index3),
		  
        .write_data0(rsv_write_data0),
        .write_data1(rsv_write_data1),
        .write_data2(rsv_write_data2),
        .write_data3(rsv_write_data3),
		  
		  .write_en_way0(write_enable0_rsv),
		  .write_en_way1(write_enable1_rsv),
		  .write_en_way2(write_enable2_rsv),
	     .write_en_way3(write_enable3_rsv),
		  
		  .status(status_rsv),
		  .updated_status(Arithmetic_updated_status),
		  
		  .stall_LS(stall_reservation_station_LS),
		  .ROB_stall(ROB_stall),
		  .BIDs_flush(BIDs_flush)
    );
	 
	wire [3:0] LoadStore_updated_status;
	wire [3:0] LSstatus;
	

	 reservation_station_lw_sw rsv_lw_sw(
   .clk(clk),
   .reset(rst),
   .we0(write_enable0_rsv_lw_sw),       // Valid bits for 4 input instructions
	.we1(write_enable1_rsv_lw_sw),
	.we2(write_enable2_rsv_lw_sw),
	.we3(write_enable3_rsv_lw_sw),
	.inst0_in(rsv_write_data0),
	.inst1_in(rsv_write_data1),
	.inst2_in(rsv_write_data2),
	.inst3_in(rsv_write_data3),
	 // wait for the final format
    .inst0_out(inst0_out_rsv_ls),         // First output
    .inst1_out(inst1_out_rsv_ls),         // Second output
    .inst2_out(inst2_out_rsv_ls),         // 3rd output
    .inst3_out(inst3_out_rsv_ls),         // 4th output
    .stall(stall_reservation_station_LS),    		// Stall signal .. not connected yet  
	.ROB_stall(ROB_stall),
	 .currentstatus(LSstatus),
	 .LoadStore_updated_status(LoadStore_updated_status),
	 .BIDs_flush(BIDs_flush)
);
 


	Schedule_Stage SS (
    // Inputs from the ARITHMETIC reservation stations
    .ARTins0(rsv_read_data0), .ARTins1(rsv_read_data1), .ARTins2(rsv_read_data2), .ARTins3(rsv_read_data3), .ARTins4(rsv_read_data4), .ARTins5(rsv_read_data5),
    .ARTins6(rsv_read_data6), .ARTins7(rsv_read_data7), .ARTins8(rsv_read_data8), .ARTins9(rsv_read_data9),
    .ARTstatus(status_rsv),
    
    
    
    // Inputs from the rsv_lw_sw
    .inst0_in_rsv_ls(inst0_out_rsv_ls),
    .inst1_in_rsv_ls(inst1_out_rsv_ls),
    .inst2_in_rsv_ls(inst2_out_rsv_ls),
    .inst3_in_rsv_ls(inst3_out_rsv_ls),
    .LSstatus(LSstatus),
	 
    // Outputs 
    .updated_ART_status(Arithmetic_updated_status), // Must be sent back to the arithmetic reservation stations
    .updated_LoadStore_status(LoadStore_updated_status), // Must be sent back to the lw_sw reservation stations
    
    
	 
	 .is_cache_full(is_cache_full),//input from the LSU cache,, must be configured to be come a stall if the read stage was stalled.
	 .stall_LS(stall_LS),
	 .BIDs_flush(BIDs_flush),
	//PRF valid bits for arithmetic stations
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
	//valid bits read from the PRF for the LOADstore stations
	.Rt0validsource(Rt0validsource), .Rs0validsource(Rs0validsource),
	.Rt1validsource(Rt1validsource), .Rs1validsource(Rs1validsource),
    .Rt2validsource(Rt2validsource), .Rs2validsource(Rs2validsource),
	.Rt3validsource(Rt3validsource), .Rs3validsource(Rs3validsource),
	 
	//current dest in execute stage
	.FU0(alu0_dest_exepipe_out),
	.FU1(alu1_dest_exepipe_out),
	.FU2(alu2_dest_exepipe_out),
	
  	.LSU0(lsu0_dest_address),
	.LSU1(lsu1_dest_address),
	//current dest in the read stage
	.FU0_readstage(alu0_dest_readpipe_out),
	.FU1_readstage(alu1_dest_readpipe_out),
	.FU2_readstage(alu2_dest_readpipe_out),
	
  	.LSU0_readstage(lsu0_Rt_index_readpipe_out),
	.LSU1_readstage(lsu1_Rt_index_readpipe_out),
	
	//==================================================================
    // Outputs to the read pipe
    //==================================================================
	 
    // ALU0 Ports
    
    .alu0_ROBentry(alu0_ROBentry_readpipe_in),
    .alu0_dest(alu0_dest_readpipe_in),
    .alu0_operation(alu0_operation_readpipe_in),
    .alu0_s1_index(alu0_s1_index_readpipe_in),
    .alu0_bid(alu0_bid_readpipe_in),
    .alu0_is_Itype(alu0_is_Itype_readpipe_in),
    .alu0_s1_alu_forwarding(alu0_s1_alu_forwarding_readpipe_in),
    .alu0_s2_alu_forwarding(alu0_s2_alu_forwarding_readpipe_in),
    .alu0_s1_lsu_forwarding(alu0_s1_lsu_forwarding_readpipe_in),
    .alu0_s2_lsu_forwarding(alu0_s2_lsu_forwarding_readpipe_in),
    .alu0_s1_needforwarding(alu0_s1_needforwarding_readpipe_in),
    .alu0_s2_needforwarding(alu0_s2_needforwarding_readpipe_in),
    .alu0_imm16b(alu0_imm16b_readpipe_in),

    
    // ALU1 Ports
  
    .alu1_ROBentry(alu1_ROBentry_readpipe_in),
    .alu1_dest(alu1_dest_readpipe_in),
    .alu1_operation(alu1_operation_readpipe_in),
    .alu1_s1_index(alu1_s1_index_readpipe_in),
    .alu1_bid(alu1_bid_readpipe_in),
    .alu1_is_Itype(alu1_is_Itype_readpipe_in),
    .alu1_s1_alu_forwarding(alu1_s1_alu_forwarding_readpipe_in),
    .alu1_s2_alu_forwarding(alu1_s2_alu_forwarding_readpipe_in),
    .alu1_s1_lsu_forwarding(alu1_s1_lsu_forwarding_readpipe_in),
    .alu1_s2_lsu_forwarding(alu1_s2_lsu_forwarding_readpipe_in),
    .alu1_s1_needforwarding(alu1_s1_needforwarding_readpipe_in),
    .alu1_s2_needforwarding(alu1_s2_needforwarding_readpipe_in),
    .alu1_imm16b(alu1_imm16b_readpipe_in),

    
    // ALU2 Ports
	
    .alu2_ROBentry(alu2_ROBentry_readpipe_in),
    .alu2_dest(alu2_dest_readpipe_in),
    .alu2_operation(alu2_operation_readpipe_in),
    .alu2_s1_index(alu2_s1_index_readpipe_in),
    .alu2_bid(alu2_bid_readpipe_in),
    .alu2_is_Itype(alu2_is_Itype_readpipe_in),
    .alu2_s1_alu_forwarding(alu2_s1_alu_forwarding_readpipe_in),
    .alu2_s2_alu_forwarding(alu2_s2_alu_forwarding_readpipe_in),
    .alu2_s1_lsu_forwarding(alu2_s1_lsu_forwarding_readpipe_in),
    .alu2_s2_lsu_forwarding(alu2_s2_lsu_forwarding_readpipe_in),
    .alu2_s1_needforwarding(alu2_s1_needforwarding_readpipe_in),
    .alu2_s2_needforwarding(alu2_s2_needforwarding_readpipe_in),
    .alu2_imm16b(alu2_imm16b_readpipe_in),


    // Branch Unit (BU) Ports
    
    .bu_ROBentry(bu_ROBentry_readpipe_in),
    .bu_operation(bu_operation_readpipe_in),
    .bu_imm(bu_imm_readpipe_in),
    .bu_BID(bu_BID_readpipe_in),
    .bu_prediction(bu_prediction_readpipe_in),
    .bu_s1_index(bu_s1_index_readpipe_in),
    .bu_s2_index(bu_s2_index_readpipe_in),
    .bu_is_branch(bu_is_branch_readpipe_in),
    .bu_is_Jr(bu_is_Jr_readpipe_in),
    .bu_s1_alu_forwarding(bu_s1_alu_forwarding_readpipe_in),
    .bu_s2_alu_forwarding(bu_s2_alu_forwarding_readpipe_in),
    .bu_s1_lsu_forwarding(bu_s1_lsu_forwarding_readpipe_in),
    .bu_s2_lsu_forwarding(bu_s2_lsu_forwarding_readpipe_in),
    .bu_s1_needforwarding(bu_s1_needforwarding_readpipe_in),
    .bu_s2_needforwarding(bu_s2_needforwarding_readpipe_in),

    
    // LSU0 Ports
    
    .lsu0_ROBentry(lsu0_ROBentry_readpipe_in),
    
    .lsu0_operation(lsu0_operation_readpipe_in),
    .lsu0_Rt_index(lsu0_Rt_index_readpipe_in),
    .lsu0_Rs_index(lsu0_Rs_index_readpipe_in),
    .lsu0_bid(lsu0_bid_readpipe_in),
    .lsu0_Rt_alu_forwarding(lsu0_Rt_alu_forwarding_readpipe_in),
    .lsu0_Rs_alu_forwarding(lsu0_Rs_alu_forwarding_readpipe_in),
    .lsu0_Rt_lsu_forwarding(lsu0_Rt_lsu_forwarding_readpipe_in),
    .lsu0_Rs_lsu_forwarding(lsu0_Rs_lsu_forwarding_readpipe_in),
    .lsu0_Rt_needforwarding(lsu0_Rt_needforwarding_readpipe_in),
    .lsu0_Rs_needforwarding(lsu0_Rs_needforwarding_readpipe_in),
    .lsu0_imm(lsu0_imm_readpipe_in),

    
    // LSU1 Ports
    
    .lsu1_ROBentry(lsu1_ROBentry_readpipe_in),
    
    .lsu1_operation(lsu1_operation_readpipe_in),
    .lsu1_Rt_index(lsu1_Rt_index_readpipe_in),
    .lsu1_Rs_index(lsu1_Rs_index_readpipe_in),
    .lsu1_bid(lsu1_bid_readpipe_in),
    .lsu1_Rt_alu_forwarding(lsu1_Rt_alu_forwarding_readpipe_in),
    .lsu1_Rs_alu_forwarding(lsu1_Rs_alu_forwarding_readpipe_in),
    .lsu1_Rt_lsu_forwarding(lsu1_Rt_lsu_forwarding_readpipe_in),
    .lsu1_Rs_lsu_forwarding(lsu1_Rs_lsu_forwarding_readpipe_in),
    .lsu1_Rt_needforwarding(lsu1_Rt_needforwarding_readpipe_in),
    .lsu1_Rs_needforwarding(lsu1_Rs_needforwarding_readpipe_in),
    .lsu1_imm(lsu1_imm_readpipe_in)
 
);



	
	readpipe readpipe_instance (
    .clk(clk),
    .rst(rst),

    // ALU0
    .alu0_ROBentry_readpipe_in(alu0_ROBentry_readpipe_in),
    .alu0_dest_readpipe_in(alu0_dest_readpipe_in),
    .alu0_operation_readpipe_in(alu0_operation_readpipe_in),
    .alu0_s1_index_readpipe_in(alu0_s1_index_readpipe_in),
    .alu0_bid_readpipe_in(alu0_bid_readpipe_in),
    .alu0_is_Itype_readpipe_in(alu0_is_Itype_readpipe_in),
    .alu0_s1_alu_forwarding_readpipe_in(alu0_s1_alu_forwarding_readpipe_in),
    .alu0_s2_alu_forwarding_readpipe_in(alu0_s2_alu_forwarding_readpipe_in),
    .alu0_s1_lsu_forwarding_readpipe_in(alu0_s1_lsu_forwarding_readpipe_in),
    .alu0_s2_lsu_forwarding_readpipe_in(alu0_s2_lsu_forwarding_readpipe_in),
    .alu0_s1_needforwarding_readpipe_in(alu0_s1_needforwarding_readpipe_in),
    .alu0_s2_needforwarding_readpipe_in(alu0_s2_needforwarding_readpipe_in),
    .alu0_imm16b_readpipe_in(alu0_imm16b_readpipe_in),

    .alu0_ROBentry_readpipe_out(alu0_ROBentry_readpipe_out),
    .alu0_dest_readpipe_out(alu0_dest_readpipe_out),
    .alu0_operation_readpipe_out(alu0_operation_readpipe_out),
    .alu0_s1_index_readpipe_out(alu0_s1_index_readpipe_out),
    .alu0_bid_readpipe_out(alu0_bid_readpipe_out),
    .alu0_is_Itype_readpipe_out(alu0_is_Itype_readpipe_out),
    .alu0_s1_alu_forwarding_readpipe_out(alu0_s1_alu_forwarding_readpipe_out),
    .alu0_s2_alu_forwarding_readpipe_out(alu0_s2_alu_forwarding_readpipe_out),
    .alu0_s1_lsu_forwarding_readpipe_out(alu0_s1_lsu_forwarding_readpipe_out),
    .alu0_s2_lsu_forwarding_readpipe_out(alu0_s2_lsu_forwarding_readpipe_out),
    .alu0_s1_needforwarding_readpipe_out(alu0_s1_needforwarding_readpipe_out),
    .alu0_s2_needforwarding_readpipe_out(alu0_s2_needforwarding_readpipe_out),
    .alu0_imm16b_readpipe_out(alu0_imm16b_readpipe_out),

    // ALU1
    .alu1_ROBentry_readpipe_in(alu1_ROBentry_readpipe_in),
    .alu1_dest_readpipe_in(alu1_dest_readpipe_in),
    .alu1_operation_readpipe_in(alu1_operation_readpipe_in),
    .alu1_s1_index_readpipe_in(alu1_s1_index_readpipe_in),
    .alu1_bid_readpipe_in(alu1_bid_readpipe_in),
    .alu1_is_Itype_readpipe_in(alu1_is_Itype_readpipe_in),
    .alu1_s1_alu_forwarding_readpipe_in(alu1_s1_alu_forwarding_readpipe_in),
    .alu1_s2_alu_forwarding_readpipe_in(alu1_s2_alu_forwarding_readpipe_in),
    .alu1_s1_lsu_forwarding_readpipe_in(alu1_s1_lsu_forwarding_readpipe_in),
    .alu1_s2_lsu_forwarding_readpipe_in(alu1_s2_lsu_forwarding_readpipe_in),
    .alu1_s1_needforwarding_readpipe_in(alu1_s1_needforwarding_readpipe_in),
    .alu1_s2_needforwarding_readpipe_in(alu1_s2_needforwarding_readpipe_in),
    .alu1_imm16b_readpipe_in(alu1_imm16b_readpipe_in),

    .alu1_ROBentry_readpipe_out(alu1_ROBentry_readpipe_out),
    .alu1_dest_readpipe_out(alu1_dest_readpipe_out),
    .alu1_operation_readpipe_out(alu1_operation_readpipe_out),
    .alu1_s1_index_readpipe_out(alu1_s1_index_readpipe_out),
    .alu1_bid_readpipe_out(alu1_bid_readpipe_out),
    .alu1_is_Itype_readpipe_out(alu1_is_Itype_readpipe_out),
    .alu1_s1_alu_forwarding_readpipe_out(alu1_s1_alu_forwarding_readpipe_out),
    .alu1_s2_alu_forwarding_readpipe_out(alu1_s2_alu_forwarding_readpipe_out),
    .alu1_s1_lsu_forwarding_readpipe_out(alu1_s1_lsu_forwarding_readpipe_out),
    .alu1_s2_lsu_forwarding_readpipe_out(alu1_s2_lsu_forwarding_readpipe_out),
    .alu1_s1_needforwarding_readpipe_out(alu1_s1_needforwarding_readpipe_out),
    .alu1_s2_needforwarding_readpipe_out(alu1_s2_needforwarding_readpipe_out),
    .alu1_imm16b_readpipe_out(alu1_imm16b_readpipe_out),

    // ALU2
    .alu2_ROBentry_readpipe_in(alu2_ROBentry_readpipe_in),
    .alu2_dest_readpipe_in(alu2_dest_readpipe_in),
    .alu2_operation_readpipe_in(alu2_operation_readpipe_in),
    .alu2_s1_index_readpipe_in(alu2_s1_index_readpipe_in),
    .alu2_bid_readpipe_in(alu2_bid_readpipe_in),
    .alu2_is_Itype_readpipe_in(alu2_is_Itype_readpipe_in),
    .alu2_s1_alu_forwarding_readpipe_in(alu2_s1_alu_forwarding_readpipe_in),
    .alu2_s2_alu_forwarding_readpipe_in(alu2_s2_alu_forwarding_readpipe_in),
    .alu2_s1_lsu_forwarding_readpipe_in(alu2_s1_lsu_forwarding_readpipe_in),
    .alu2_s2_lsu_forwarding_readpipe_in(alu2_s2_lsu_forwarding_readpipe_in),
    .alu2_s1_needforwarding_readpipe_in(alu2_s1_needforwarding_readpipe_in),
    .alu2_s2_needforwarding_readpipe_in(alu2_s2_needforwarding_readpipe_in),
    .alu2_imm16b_readpipe_in(alu2_imm16b_readpipe_in),

    .alu2_ROBentry_readpipe_out(alu2_ROBentry_readpipe_out),
    .alu2_dest_readpipe_out(alu2_dest_readpipe_out),
    .alu2_operation_readpipe_out(alu2_operation_readpipe_out),
    .alu2_s1_index_readpipe_out(alu2_s1_index_readpipe_out),
    .alu2_bid_readpipe_out(alu2_bid_readpipe_out),
    .alu2_is_Itype_readpipe_out(alu2_is_Itype_readpipe_out),
    .alu2_s1_alu_forwarding_readpipe_out(alu2_s1_alu_forwarding_readpipe_out),
    .alu2_s2_alu_forwarding_readpipe_out(alu2_s2_alu_forwarding_readpipe_out),
    .alu2_s1_lsu_forwarding_readpipe_out(alu2_s1_lsu_forwarding_readpipe_out),
    .alu2_s2_lsu_forwarding_readpipe_out(alu2_s2_lsu_forwarding_readpipe_out),
    .alu2_s1_needforwarding_readpipe_out(alu2_s1_needforwarding_readpipe_out),
    .alu2_s2_needforwarding_readpipe_out(alu2_s2_needforwarding_readpipe_out),
    .alu2_imm16b_readpipe_out(alu2_imm16b_readpipe_out),



    // BU
    .bu_ROBentry_readpipe_in(bu_ROBentry_readpipe_in),
    .bu_operation_readpipe_in(bu_operation_readpipe_in),
    .bu_imm_readpipe_in(bu_imm_readpipe_in),
    .bu_BID_readpipe_in(bu_BID_readpipe_in),
    .bu_prediction_readpipe_in(bu_prediction_readpipe_in),
    .bu_s1_index_readpipe_in(bu_s1_index_readpipe_in),
    .bu_s2_index_readpipe_in(bu_s2_index_readpipe_in),
    .bu_is_branch_readpipe_in(bu_is_branch_readpipe_in),
    .bu_is_Jr_readpipe_in(bu_is_Jr_readpipe_in),
    .bu_s1_alu_forwarding_readpipe_in(bu_s1_alu_forwarding_readpipe_in),
    .bu_s2_alu_forwarding_readpipe_in(bu_s2_alu_forwarding_readpipe_in),
    .bu_s1_lsu_forwarding_readpipe_in(bu_s1_lsu_forwarding_readpipe_in),
    .bu_s2_lsu_forwarding_readpipe_in(bu_s2_lsu_forwarding_readpipe_in),
    .bu_s1_needforwarding_readpipe_in(bu_s1_needforwarding_readpipe_in),
    .bu_s2_needforwarding_readpipe_in(bu_s2_needforwarding_readpipe_in),

    .bu_ROBentry_readpipe_out(bu_ROBentry_readpipe_out),
    .bu_operation_readpipe_out(bu_operation_readpipe_out),
    .bu_imm_readpipe_out(bu_imm_readpipe_out),
    .bu_BID_readpipe_out(bu_BID_readpipe_out),
    .bu_prediction_readpipe_out(bu_prediction_readpipe_out),
    .bu_s1_index_readpipe_out(bu_s1_index_readpipe_out),
    .bu_s2_index_readpipe_out(bu_s2_index_readpipe_out),
    .bu_is_branch_readpipe_out(bu_is_branch_readpipe_out),
    .bu_is_Jr_readpipe_out(bu_is_Jr_readpipe_out),
    .bu_s1_alu_forwarding_readpipe_out(bu_s1_alu_forwarding_readpipe_out),
    .bu_s2_alu_forwarding_readpipe_out(bu_s2_alu_forwarding_readpipe_out),
    .bu_s1_lsu_forwarding_readpipe_out(bu_s1_lsu_forwarding_readpipe_out),
    .bu_s2_lsu_forwarding_readpipe_out(bu_s2_lsu_forwarding_readpipe_out),
    .bu_s1_needforwarding_readpipe_out(bu_s1_needforwarding_readpipe_out),
    .bu_s2_needforwarding_readpipe_out(bu_s2_needforwarding_readpipe_out),

    // LSU0
    .lsu0_ROBentry_readpipe_in(lsu0_ROBentry_readpipe_in),
    
    .lsu0_operation_readpipe_in(lsu0_operation_readpipe_in),
    .lsu0_Rt_index_readpipe_in(lsu0_Rt_index_readpipe_in),
    .lsu0_Rs_index_readpipe_in(lsu0_Rs_index_readpipe_in),
    .lsu0_bid_readpipe_in(lsu0_bid_readpipe_in),
    .lsu0_Rt_alu_forwarding_readpipe_in(lsu0_Rt_alu_forwarding_readpipe_in),
    .lsu0_Rs_alu_forwarding_readpipe_in(lsu0_Rs_alu_forwarding_readpipe_in),
    .lsu0_Rt_lsu_forwarding_readpipe_in(lsu0_Rt_lsu_forwarding_readpipe_in),
    .lsu0_Rs_lsu_forwarding_readpipe_in(lsu0_Rs_lsu_forwarding_readpipe_in),
    .lsu0_Rt_needforwarding_readpipe_in(lsu0_Rt_needforwarding_readpipe_in),
    .lsu0_Rs_needforwarding_readpipe_in(lsu0_Rs_needforwarding_readpipe_in),
    .lsu0_imm_readpipe_in(lsu0_imm_readpipe_in),

    .lsu0_ROBentry_readpipe_out(lsu0_ROBentry_readpipe_out),
    
    .lsu0_operation_readpipe_out(lsu0_operation_readpipe_out),
    .lsu0_Rt_index_readpipe_out(lsu0_Rt_index_readpipe_out),
    .lsu0_Rs_index_readpipe_out(lsu0_Rs_index_readpipe_out),
    .lsu0_bid_readpipe_out(lsu0_bid_readpipe_out),
    .lsu0_Rt_alu_forwarding_readpipe_out(lsu0_Rt_alu_forwarding_readpipe_out),
    .lsu0_Rs_alu_forwarding_readpipe_out(lsu0_Rs_alu_forwarding_readpipe_out),
    .lsu0_Rt_lsu_forwarding_readpipe_out(lsu0_Rt_lsu_forwarding_readpipe_out),
    .lsu0_Rs_lsu_forwarding_readpipe_out(lsu0_Rs_lsu_forwarding_readpipe_out),
    .lsu0_Rt_needforwarding_readpipe_out(lsu0_Rt_needforwarding_readpipe_out),
    .lsu0_Rs_needforwarding_readpipe_out(lsu0_Rs_needforwarding_readpipe_out),
    .lsu0_imm_readpipe_out(lsu0_imm_readpipe_out),

    // LSU1
    .lsu1_ROBentry_readpipe_in(lsu1_ROBentry_readpipe_in),
    
    .lsu1_operation_readpipe_in(lsu1_operation_readpipe_in),
    .lsu1_Rt_index_readpipe_in(lsu1_Rt_index_readpipe_in),
    .lsu1_Rs_index_readpipe_in(lsu1_Rs_index_readpipe_in),
    .lsu1_bid_readpipe_in(lsu1_bid_readpipe_in),
    .lsu1_Rt_alu_forwarding_readpipe_in(lsu1_Rt_alu_forwarding_readpipe_in),
    .lsu1_Rs_alu_forwarding_readpipe_in(lsu1_Rs_alu_forwarding_readpipe_in),
    .lsu1_Rt_lsu_forwarding_readpipe_in(lsu1_Rt_lsu_forwarding_readpipe_in),
    .lsu1_Rs_lsu_forwarding_readpipe_in(lsu1_Rs_lsu_forwarding_readpipe_in),
    .lsu1_Rt_needforwarding_readpipe_in(lsu1_Rt_needforwarding_readpipe_in),
    .lsu1_Rs_needforwarding_readpipe_in(lsu1_Rs_needforwarding_readpipe_in),
    .lsu1_imm_readpipe_in(lsu1_imm_readpipe_in),

    .lsu1_ROBentry_readpipe_out(lsu1_ROBentry_readpipe_out),
    
    .lsu1_operation_readpipe_out(lsu1_operation_readpipe_out),
    .lsu1_Rt_index_readpipe_out(lsu1_Rt_index_readpipe_out),
    .lsu1_Rs_index_readpipe_out(lsu1_Rs_index_readpipe_out),
    .lsu1_bid_readpipe_out(lsu1_bid_readpipe_out),
    .lsu1_Rt_alu_forwarding_readpipe_out(lsu1_Rt_alu_forwarding_readpipe_out),
    .lsu1_Rs_alu_forwarding_readpipe_out(lsu1_Rs_alu_forwarding_readpipe_out),
    .lsu1_Rt_lsu_forwarding_readpipe_out(lsu1_Rt_lsu_forwarding_readpipe_out),
    .lsu1_Rs_lsu_forwarding_readpipe_out(lsu1_Rs_lsu_forwarding_readpipe_out),
    .lsu1_Rt_needforwarding_readpipe_out(lsu1_Rt_needforwarding_readpipe_out),
    .lsu1_Rs_needforwarding_readpipe_out(lsu1_Rs_needforwarding_readpipe_out),
    .lsu1_imm_readpipe_out(lsu1_imm_readpipe_out),
	 
	 .stall_LS(stall_LS)
);

wire [2:0] size_cache_lsu;
wire [1:0] number_of_commit_lsu;


wire valid_lsu0_read_out, valid_lsu1_read_out;

wire [4:0] lsu0_ROBentry_execute_out, lsu1_ROBentry_execute_out;

wire valid_lsu0_execute_out,valid_lsu1_execute_out;

wire PNR_sw0,PNR_sw1;

ReadStage readstage_instance (
    // --- ALU0 Inputs ---
    .alu0_ROBentry_ReadS(alu0_ROBentry_readpipe_out),
    .alu0_dest_ReadS(alu0_dest_readpipe_out),
    .alu0_operation_ReadS(alu0_operation_readpipe_out),
    .alu0_s1_index_ReadS(alu0_s1_index_readpipe_out),
    .alu0_bid_ReadS(alu0_bid_readpipe_out),
    .alu0_is_Itype_ReadS(alu0_is_Itype_readpipe_out),
    .alu0_s1_alu_forwarding_ReadS(alu0_s1_alu_forwarding_readpipe_out),
    .alu0_s2_alu_forwarding_ReadS(alu0_s2_alu_forwarding_readpipe_out),
    .alu0_s1_lsu_forwarding_ReadS(alu0_s1_lsu_forwarding_readpipe_out),
    .alu0_s2_lsu_forwarding_ReadS(alu0_s2_lsu_forwarding_readpipe_out),
    .alu0_s1_needforwarding_ReadS(alu0_s1_needforwarding_readpipe_out),
    .alu0_s2_needforwarding_ReadS(alu0_s2_needforwarding_readpipe_out),
    .alu0_imm16b_ReadS(alu0_imm16b_readpipe_out),

    // --- ALU1 Inputs ---
    .alu1_ROBentry_ReadS(alu1_ROBentry_readpipe_out),
    .alu1_dest_ReadS(alu1_dest_readpipe_out),
    .alu1_operation_ReadS(alu1_operation_readpipe_out),
    .alu1_s1_index_ReadS(alu1_s1_index_readpipe_out),
    .alu1_bid_ReadS(alu1_bid_readpipe_out),
    .alu1_is_Itype_ReadS(alu1_is_Itype_readpipe_out),
    .alu1_s1_alu_forwarding_ReadS(alu1_s1_alu_forwarding_readpipe_out),
    .alu1_s2_alu_forwarding_ReadS(alu1_s2_alu_forwarding_readpipe_out),
    .alu1_s1_lsu_forwarding_ReadS(alu1_s1_lsu_forwarding_readpipe_out),
    .alu1_s2_lsu_forwarding_ReadS(alu1_s2_lsu_forwarding_readpipe_out),
    .alu1_s1_needforwarding_ReadS(alu1_s1_needforwarding_readpipe_out),
    .alu1_s2_needforwarding_ReadS(alu1_s2_needforwarding_readpipe_out),
    .alu1_imm16b_ReadS(alu1_imm16b_readpipe_out),

    // --- ALU2 Inputs ---
    .alu2_ROBentry_ReadS(alu2_ROBentry_readpipe_out),
    .alu2_dest_ReadS(alu2_dest_readpipe_out),
    .alu2_operation_ReadS(alu2_operation_readpipe_out),
    .alu2_s1_index_ReadS(alu2_s1_index_readpipe_out),
    .alu2_bid_ReadS(alu2_bid_readpipe_out),
    .alu2_is_Itype_ReadS(alu2_is_Itype_readpipe_out),
    .alu2_s1_alu_forwarding_ReadS(alu2_s1_alu_forwarding_readpipe_out),
    .alu2_s2_alu_forwarding_ReadS(alu2_s2_alu_forwarding_readpipe_out),
    .alu2_s1_lsu_forwarding_ReadS(alu2_s1_lsu_forwarding_readpipe_out),
    .alu2_s2_lsu_forwarding_ReadS(alu2_s2_lsu_forwarding_readpipe_out),
    .alu2_s1_needforwarding_ReadS(alu2_s1_needforwarding_readpipe_out),
    .alu2_s2_needforwarding_ReadS(alu2_s2_needforwarding_readpipe_out),
    .alu2_imm16b_ReadS(alu2_imm16b_readpipe_out),

    

    // --- Branch Unit (BU) Inputs ---
    .bu_ROBentry_ReadS(bu_ROBentry_readpipe_out),
    .bu_operation_ReadS(bu_operation_readpipe_out),
    .bu_imm_ReadS(bu_imm_readpipe_out),
    .bu_BID_ReadS(bu_BID_readpipe_out),
    .bu_prediction_ReadS(bu_prediction_readpipe_out),
    .bu_s1_index_ReadS(bu_s1_index_readpipe_out),
    .bu_s2_index_ReadS(bu_s2_index_readpipe_out),
    .bu_is_branch_ReadS(bu_is_branch_readpipe_out),
    .bu_is_Jr_ReadS(bu_is_Jr_readpipe_out),
    .bu_s1_alu_forwarding_ReadS(bu_s1_alu_forwarding_readpipe_out),
    .bu_s2_alu_forwarding_ReadS(bu_s2_alu_forwarding_readpipe_out),
    .bu_s1_lsu_forwarding_ReadS(bu_s1_lsu_forwarding_readpipe_out),
    .bu_s2_lsu_forwarding_ReadS(bu_s2_lsu_forwarding_readpipe_out),
    .bu_s1_needforwarding_ReadS(bu_s1_needforwarding_readpipe_out),
    .bu_s2_needforwarding_ReadS(bu_s2_needforwarding_readpipe_out),

    // --- LSU0 Inputs ---
    .lsu0_ROBentry_ReadS(lsu0_ROBentry_readpipe_out),
    .lsu0_operation_ReadS(lsu0_operation_readpipe_out),
    .lsu0_Rt_index_ReadS(lsu0_Rt_index_readpipe_out),
    .lsu0_Rs_index_ReadS(lsu0_Rs_index_readpipe_out),
    .lsu0_bid_ReadS(lsu0_bid_readpipe_out),
    .lsu0_Rt_alu_forwarding_ReadS(lsu0_Rt_alu_forwarding_readpipe_out),
    .lsu0_Rs_alu_forwarding_ReadS(lsu0_Rs_alu_forwarding_readpipe_out),
    .lsu0_Rt_lsu_forwarding_ReadS(lsu0_Rt_lsu_forwarding_readpipe_out),
    .lsu0_Rs_lsu_forwarding_ReadS(lsu0_Rs_lsu_forwarding_readpipe_out),
    .lsu0_Rt_needforwarding_ReadS(lsu0_Rt_needforwarding_readpipe_out),
    .lsu0_Rs_needforwarding_ReadS(lsu0_Rs_needforwarding_readpipe_out),
    .lsu0_imm_ReadS(lsu0_imm_readpipe_out),

    // --- LSU1 Inputs ---
    .lsu1_ROBentry_ReadS(lsu1_ROBentry_readpipe_out),
    .lsu1_operation_ReadS(lsu1_operation_readpipe_out),
    .lsu1_Rt_index_ReadS(lsu1_Rt_index_readpipe_out),
    .lsu1_Rs_index_ReadS(lsu1_Rs_index_readpipe_out),
    .lsu1_bid_ReadS(lsu1_bid_readpipe_out),
    .lsu1_Rt_alu_forwarding_ReadS(lsu1_Rt_alu_forwarding_readpipe_out),
    .lsu1_Rs_alu_forwarding_ReadS(lsu1_Rs_alu_forwarding_readpipe_out),
    .lsu1_Rt_lsu_forwarding_ReadS(lsu1_Rt_lsu_forwarding_readpipe_out),
    .lsu1_Rs_lsu_forwarding_ReadS(lsu1_Rs_lsu_forwarding_readpipe_out),
    .lsu1_Rt_needforwarding_ReadS(lsu1_Rt_needforwarding_readpipe_out),
    .lsu1_Rs_needforwarding_ReadS(lsu1_Rs_needforwarding_readpipe_out),
    .lsu1_imm_ReadS(lsu1_imm_readpipe_out),
	
	/////////////////////////////////////////////
	//PRF read inputs 
	/////////////////////////////////////////////
	.alu0_s1(alu0_s1_prf_out),
    .alu0_s2(alu0_s2_prf_out),
    .alu1_s1(alu1_s1_prf_out),
    .alu1_s2(alu1_s2_prf_out),
    .alu2_s1(alu2_s1_prf_out),
    .alu2_s2(alu2_s2_prf_out),

    .bu_s1(Bu_s1_prf_out),
    .bu_s2(Bu_s2_prf_out),
    
    .lsu0_Rt(lsu0_rt_prf_out),
    .lsu0_Rs(lsu0_rs_prf_out),
    .lsu1_Rt(lsu1_rt_prf_out),
    .lsu1_Rs(lsu1_rs_prf_out),



	
	/////////////////////////////////////////////
	//bypass network inputs 
	/////////////////////////////////////////////
	.alu0(alu0_result_ES[31:0]),
    .alu1(alu1_result_ES[31:0]),
    .alu2(alu2_result_ES[31:0]),
    
    .lsu0(lsu0_result_ES[31:0]),
    .lsu1(lsu1_result_ES[31:0]),	
	
	//==================================================================
    // Inputs from the branching unit
    //==================================================================
	
	.BIDs_flush(BIDs_flush),	
		
	//outputs 
	.alu0_source1(alu0_source1_exepipe_in),
    .alu0_source2(alu0_source2_exepipe_in),
    .alu1_source1(alu1_source1_exepipe_in),
    .alu1_source2(alu1_source2_exepipe_in),
    .alu2_source1(alu2_source1_exepipe_in),
    .alu2_source2(alu2_source2_exepipe_in),

	.alu0_operation(alu0_operation_exepipe_in),
	.alu1_operation(alu1_operation_exepipe_in),
	.alu2_operation(alu2_operation_exepipe_in),
	.alu0_BID(alu0_bid__exepipe_in),
	.alu1_BID(alu1_bid__exepipe_in),
	.alu2_BID(alu2_bid__exepipe_in), 
		
	.bu_operation(bu_operation_exepipe_in),
    .BU_source1(BU_source1_exepipe_in),
    .BU_source2(BU_source2_exepipe_in),
    .lsu0_Rt_source(lsu0_Rt_exepipe_in),
    .lsu0_address(lsu0_address_exepipe_in),
    .lsu1_Rt_source(lsu1_Rt_exepipe_in),
    .lsu1_address(lsu1_address_exepipe_in),
	
    .size_cache(size_cache_lsu),			    // output
	.number_of_commit(number_of_commit_lsu),    // output
	
	.dep_lw0_sw1(dep_lw0_sw1), .dep_sw0_sw1_mux(dep_sw0_sw1_mux),//
	.stall_LS(stall_LS),
	.valid_lsu0(valid_lsu0_read_out), .valid_lsu1(valid_lsu1_read_out),
	
	.dep_sw0_lw1(dep_sw0_lw1)
);


wire [5:0] source_v0, source_v1, source_v2, source_v3, source_v4, source_v5, source_v6, source_v7, source_v8, source_v9;
//incase the instruction was a branch then its other source will be in the location of the normal dest which is [27:22], the first source is always fixed in location [21:16]. 
mux2 #(6) source_v0mux (.in0(rsv_read_data0[15:10]), .in1(rsv_read_data0[27:22]), .sel(rsv_read_data0[33]), .out(source_v0));
mux2 #(6) source_v1mux (.in0(rsv_read_data1[15:10]), .in1(rsv_read_data1[27:22]), .sel(rsv_read_data1[33]), .out(source_v1));
mux2 #(6) source_v2mux (.in0(rsv_read_data2[15:10]), .in1(rsv_read_data2[27:22]), .sel(rsv_read_data2[33]), .out(source_v2));
mux2 #(6) source_v3mux (.in0(rsv_read_data3[15:10]), .in1(rsv_read_data3[27:22]), .sel(rsv_read_data3[33]), .out(source_v3));
mux2 #(6) source_v4mux (.in0(rsv_read_data4[15:10]), .in1(rsv_read_data4[27:22]), .sel(rsv_read_data4[33]), .out(source_v4));
mux2 #(6) source_v5mux (.in0(rsv_read_data5[15:10]), .in1(rsv_read_data5[27:22]), .sel(rsv_read_data5[33]), .out(source_v5));
mux2 #(6) source_v6mux (.in0(rsv_read_data6[15:10]), .in1(rsv_read_data6[27:22]), .sel(rsv_read_data6[33]), .out(source_v6));
mux2 #(6) source_v7mux (.in0(rsv_read_data7[15:10]), .in1(rsv_read_data7[27:22]), .sel(rsv_read_data7[33]), .out(source_v7));
mux2 #(6) source_v8mux (.in0(rsv_read_data8[15:10]), .in1(rsv_read_data8[27:22]), .sel(rsv_read_data8[33]), .out(source_v8));
mux2 #(6) source_v9mux (.in0(rsv_read_data9[15:10]), .in1(rsv_read_data9[27:22]), .sel(rsv_read_data9[33]), .out(source_v9));

// Instantiate the PRF modul				  
PRF PRF_inst (
    .clk(clk),  // Input: Clock signal
    .reset(rst),  // Input: Reset signal
    
    // Inputs: Data to be written in execute stage
    .ALU0writedata(alu0_result_ES),
    .ALU1writedata(alu1_result_ES),
    .ALU2writedata(alu2_result_ES),
    
    .LSU0writedata(lsu0_result_ES),
    .LSU1writedata(lsu1_result_ES),
    
    // Inputs: Write addresses for execute stage
    .WriteAddress0(alu0_dest_exepipe_out),
    .WriteAddress1(alu1_dest_exepipe_out),
    .WriteAddress2(alu2_dest_exepipe_out),
    
    .WriteAddress4(lsu0_dest_address),
    .WriteAddress5(lsu1_dest_address),
    
    // Inputs: Read addresses for scheduling stage
    // Read address wires plugged in
    .ReadAddress_Alu0_s1(alu0_s1_index_readpipe_out),
    .ReadAddress_Alu0_s2(alu0_imm16b_readpipe_out[15:10]),
    .ReadAddress_Alu1_s1(alu1_s1_index_readpipe_out),
    .ReadAddress_Alu1_s2(alu1_imm16b_readpipe_out[15:10]),
    .ReadAddress_Alu2_s1(alu2_s1_index_readpipe_out),
    .ReadAddress_Alu2_s2(alu2_imm16b_readpipe_out[15:10]),
    
    .ReadAddress_Bu_s1(bu_s1_index_readpipe_out),
    .ReadAddress_Bu_s2(bu_s2_index_readpipe_out),
    .ReadAddress_Lsu0_Rt(lsu0_Rt_index_readpipe_out),
    .ReadAddress_Lsu0_Rs(lsu0_Rs_index_readpipe_out),
    .ReadAddress_Lsu1_Rt(lsu1_Rt_index_readpipe_out),
    .ReadAddress_Lsu1_Rs(lsu1_Rs_index_readpipe_out),
    
	 
    // Inputs: Valid bits (RA_V) for schedule stage
	 //from the arithmetic stations
    .RA_V0(rsv_read_data0[21:16]),
    .RA_V1(source_v0),
    .RA_V2(rsv_read_data1[21:16]),
    .RA_V3(source_v1),
    .RA_V4(rsv_read_data2[21:16]),
    .RA_V5(source_v2),
    .RA_V6(rsv_read_data3[21:16]),
    .RA_V7(source_v3),
    .RA_V8(rsv_read_data4[21:16]),
    .RA_V9(source_v4),
    .RA_V10(rsv_read_data5[21:16]),
    .RA_V11(source_v5),
    .RA_V12(rsv_read_data6[21:16]),
    .RA_V13(source_v6),
    .RA_V14(rsv_read_data7[21:16]),
    .RA_V15(source_v7),
    .RA_V16(rsv_read_data8[21:16]),
    .RA_V17(source_v8),
    .RA_V18(rsv_read_data9[21:16]),
    .RA_V19(source_v9),
	 //from the loadstore stations
    .RA_V20(inst0_out_rsv_ls[27:22]),
    .RA_V21(inst0_out_rsv_ls[21:16]),
    .RA_V22(inst1_out_rsv_ls[27:22]),
    .RA_V23(inst1_out_rsv_ls[21:16]),
    .RA_V24(inst2_out_rsv_ls[27:22]),
    .RA_V25(inst2_out_rsv_ls[21:16]),
    .RA_V26(inst3_out_rsv_ls[27:22]),
    .RA_V27(inst3_out_rsv_ls[21:16]),

    // Outputs: Valid bits (RA_V) to schedule stage
	//these are for the arithmetic stations
    .RA_V0_out(rs0validsource1),
    .RA_V1_out(rs0validsource2),
    .RA_V2_out(rs1validsource1),
    .RA_V3_out(rs1validsource2),
    .RA_V4_out(rs2validsource1),
    .RA_V5_out(rs2validsource2),
    .RA_V6_out(rs3validsource1),
    .RA_V7_out(rs3validsource2),
    .RA_V8_out(rs4validsource1),
    .RA_V9_out(rs4validsource2),
    .RA_V10_out(rs5validsource1),
    .RA_V11_out(rs5validsource2),
    .RA_V12_out(rs6validsource1),
    .RA_V13_out(rs6validsource2),
    .RA_V14_out(rs7validsource1),
    .RA_V15_out(rs7validsource2),
    .RA_V16_out(rs8validsource1),
    .RA_V17_out(rs8validsource2),
    .RA_V18_out(rs9validsource1),
    .RA_V19_out(rs9validsource2),
	//these are for the loadstore stations
    .RA_V20_out(Rt0validsource),
    .RA_V21_out(Rs0validsource),
    .RA_V22_out(Rt1validsource),
    .RA_V23_out(Rs1validsource),
    .RA_V24_out(Rt2validsource),
    .RA_V25_out(Rs2validsource),
    .RA_V26_out(Rt3validsource),
    .RA_V27_out(Rs3validsource),

    // Outputs: Data read from PRF
    .Alu0_s1(alu0_s1_prf_out),
    .Alu0_s2(alu0_s2_prf_out),
    .Alu1_s1(alu1_s1_prf_out),
    .Alu1_s2(alu1_s2_prf_out),
    .Alu2_s1(alu2_s1_prf_out),
    .Alu2_s2(alu2_s2_prf_out),

    .Bu_s1(Bu_s1_prf_out),
    .Bu_s2(Bu_s2_prf_out),
    .Lsu0_Rt(lsu0_rt_prf_out),
    .Lsu0_Rs(lsu0_rs_prf_out),
    .Lsu1_Rt(lsu1_rt_prf_out),
    .Lsu1_Rs(lsu1_rs_prf_out),
	 
	.recovery_mt(recovery_reg_mt),
	.current_state_frpool(frpool_reg_out),
	.hit(hit), .is_branch_ES(is_branch_ES),
	
	
	//=========================================
	//COMMIT STAGE 
	//=========================================
	.commit_index0(commit_index0),
	.commit_index1(commit_index1),
	.commit_index2(commit_index2),
	.commit_index3(commit_index3),
	.commit_value0(commit_value0),
	.commit_value1(commit_value1),
	.commit_value2(commit_value2),
	.commit_value3(commit_value3),
	
 	//batch ready to commit
    .all_done(all_done_commit_out), // prf 
	//to return to the prf of registers from commit. 
	 .return_stale0(return_stale0_commit_out),
	 .return_stale1(return_stale1_commit_out),
	 .return_stale2(return_stale2_commit_out),
	 .return_stale3(return_stale3_commit_out),
	
	 .PNR0(PNR0_commit_out),//if active then the stale is valid to be returned, if not then the stale must not be returned.
	 .PNR1(PNR1_commit_out),
	 .PNR2(PNR2_commit_out),
	 .PNR3(PNR3_commit_out),
	
	 .jr_index_fs(fs_read_data_jr_prf_index),   //input from rat
	 .jr_address_prf(jr_address_prf),           //output to fetch stage 
	 
	 .valid_index_rat_in(valid_index_rat), // input from rat 
	 .valid_index_prf_out(valid_index_prf) // output from fetch stage 
	 

);



executepipe exe_pipe (
    .clk(clk),
    .rst(rst),

    /// ALU0
    .alu0_source1_in(alu0_source1_exepipe_in), .alu0_source2_in(alu0_source2_exepipe_in),
    .alu0_ROBentry_in(alu0_ROBentry_readpipe_out),
    .alu0_dest_in(alu0_dest_readpipe_out),
    .alu0_operation_in(alu0_operation_exepipe_in),
	.alu0_bid_in(alu0_bid__exepipe_in),//***********************************

    .alu0_source1_out(alu0_source1_exepipe_out), .alu0_source2_out(alu0_source2_exepipe_out),
    .alu0_ROBentry_out(alu0_ROBentry_exepipe_out),
    .alu0_dest_out(alu0_dest_exepipe_out),
    .alu0_operation_out(alu0_operation_exepipe_out),
	.alu0_bid_out(alu0_bid_exepipe_out),

    /// ALU1
    .alu1_source1_in(alu1_source1_exepipe_in), .alu1_source2_in(alu1_source2_exepipe_in),
    .alu1_ROBentry_in(alu1_ROBentry_readpipe_out),
    .alu1_dest_in(alu1_dest_readpipe_out),
    .alu1_operation_in(alu1_operation_exepipe_in),
	.alu1_bid_in(alu1_bid__exepipe_in),
	
    .alu1_source1_out(alu1_source1_exepipe_out), .alu1_source2_out(alu1_source2_exepipe_out),
    .alu1_ROBentry_out(alu1_ROBentry_exepipe_out),
    .alu1_dest_out(alu1_dest_exepipe_out),
    .alu1_operation_out(alu1_operation_exepipe_out),
	.alu1_bid_out(alu1_bid_exepipe_out),

    /// ALU2
    .alu2_source1_in(alu2_source1_exepipe_in), .alu2_source2_in(alu2_source2_exepipe_in),
    .alu2_ROBentry_in(alu2_ROBentry_readpipe_out),
    .alu2_dest_in(alu2_dest_readpipe_out),
    .alu2_operation_in(alu2_operation_exepipe_in),
	.alu2_bid_in(alu2_bid__exepipe_in),
	
    .alu2_source1_out(alu2_source1_exepipe_out), .alu2_source2_out(alu2_source2_exepipe_out),
    .alu2_ROBentry_out(alu2_ROBentry_exepipe_out),
    .alu2_dest_out(alu2_dest_exepipe_out),
    .alu2_operation_out(alu2_operation_exepipe_out),
	.alu2_bid_out(alu2_bid_exepipe_out),
	
    
	
    /// Branching Unit
    .BU_source1_in(BU_source1_exepipe_in), .BU_source2_in(BU_source2_exepipe_in),
    .BU_ROBentry_in(bu_ROBentry_readpipe_out),
    .BU_operation_in(bu_operation_exepipe_in),
    .BU_imm_in(bu_imm_readpipe_out),
    .BU_BID_in(bu_BID_readpipe_out),
	 .BU_prediction_in(bu_prediction_readpipe_out),
	
	
    .BU_source1_out(BU_source1_exepipe_out), .BU_source2_out(BU_source2_exepipe_out),
    .BU_ROBentry_out(BU_ROBentry_exepipe_out),
    .BU_operation_out(BU_operation_exepipe_out),
    .BU_imm_out(BU_imm_exepipe_out),
    .BU_BID_out(BU_BID_exepipe_out),
	.BU_prediction_out(BU_prediction_exepipe_out)
	
	 
	 
);	
// Instantiate the ExecuteStage module
ExecuteStage execute_stage_inst (
    .clk(clk),
    .rst(rst),

    // ALU0 connections
    .alu0_source1_ES(alu0_source1_exepipe_out),
    .alu0_source2_ES(alu0_source2_exepipe_out),
    .alu0_operation_ES(alu0_operation_exepipe_out),
	 .alu0_bid_ES_in(alu0_bid_exepipe_out),
	
    // ALU1 connections
    .alu1_source1_ES(alu1_source1_exepipe_out),
    .alu1_source2_ES(alu1_source2_exepipe_out),
    .alu1_operation_ES(alu1_operation_exepipe_out),
	.alu1_bid_ES_in(alu1_bid_exepipe_out),
	
    // ALU2 connections
    .alu2_source1_ES(alu2_source1_exepipe_out),
    .alu2_source2_ES(alu2_source2_exepipe_out),
    .alu2_operation_ES(alu2_operation_exepipe_out),
	.alu2_bid_ES_in(alu2_bid_exepipe_out),
	
    
	
    // Branching Unit connections
    .BU_source1_ES(BU_source1_exepipe_out),
    .BU_source2_ES(BU_source2_exepipe_out),
    .BU_operation_ES(BU_operation_exepipe_out),
	.BU_prediction_ES(BU_prediction_exepipe_out),
	.BU_imm_ES(BU_imm_exepipe_out),
	.BU_BID_ES(BU_BID_exepipe_out),
	 //LSU connections ***the LSU has an internal pipe register...thats why we connect the wires directly from the shcedule stage.
	 .lsu0_Rt_source(lsu0_Rt_exepipe_in),
	 .lsu0_address  (lsu0_address_exepipe_in),
	 .lsu0_ROBentry (lsu0_ROBentry_readpipe_out),
	 .lsu0_dest     (lsu0_Rt_index_readpipe_out),
	 .lsu0_operation_ReadS(lsu0_operation_readpipe_out),
	 .lsu0_bid_in(lsu0_bid_readpipe_out),
		
	.dep_lw0_sw1(dep_lw0_sw1), .dep_sw0_sw1_mux(dep_sw0_sw1_mux),//dependency checks
		
	 .lsu1_Rt_source(lsu1_Rt_exepipe_in),
	 .lsu1_address  (lsu1_address_exepipe_in),
	 .lsu1_ROBentry (lsu1_ROBentry_readpipe_out),
	 .lsu1_dest     (lsu1_Rt_index_readpipe_out),
	 .lsu1_operation_ReadS(lsu1_operation_readpipe_out),
	 .lsu1_bid_in(lsu1_bid_readpipe_out),
	 
	 .PNR_sw0(PNR_sw0),.PNR_sw1(PNR_sw1),
	 .ROB_commit0(ROB_sw_commit0),.ROB_commit1(ROB_sw_commit1),
    // Outputs
    .alu0_result_ES(alu0_result_ES),
    .alu1_result_ES(alu1_result_ES),
    .alu2_result_ES(alu2_result_ES),
   
	 
	 // Branch Unit Outputs
    .is_branch_ES(is_branch_ES),
	 .is_Jr(),
	 .hit(hit),
	 .address(address_B_Jr),
	 .BIDs_flush(BIDs_flush),
	 
	 //lsu outputs
	  .lsu0_result_ES(lsu0_result_ES), .lsu1_result_ES(lsu1_result_ES),
	  .lsu0_dest_out(lsu0_dest_address), .lsu1_dest_out(lsu1_dest_address),
	  .lsu0_ROBentry_out(lsu0_ROBentry_execute_out), .lsu1_ROBentry_out(lsu1_ROBentry_execute_out),//for ROB when its done...
	  .isfull(is_cache_full),
	  
	  .H(h_out_priority_table),	  
	  .M(m_out_priority_table),	  
	  .L(l_out_priority_table),
	  .size_cache(size_cache_lsu),			 // output
	  .number_of_commit(number_of_commit_lsu),   // output

     .valid_lsu0_in(valid_lsu0_read_out), // input from read stage 
     .valid_lsu1_in(valid_lsu1_read_out),  // input from read stage 

     .valid_lsu0_out(valid_lsu0_execute_out),//for ROB 
     .valid_lsu1_out(valid_lsu1_execute_out),//for ROB
	  .stall_ls(stall_LS),
	  .valid0_lw_sw_rob_out(valid0_lw_sw_rob_out),
	  .valid1_lw_sw_rob_out(valid1_lw_sw_rob_out),
	  .all_done(all_done_commit_out),
	  .dep_sw0_lw1(dep_sw0_lw1)

);


//====  ====//
Commit_Stage commit (
    .clk(clk),
    .rst(rst),
    
	//----------RENAME STAGE INPUTS---------//
    .valid_word(valid_word_id2),
	
	
	.is_store0_rename(is_store0_rename),
	.is_store1_rename(is_store1_rename),
	.is_store2_rename(is_store2_rename),
	.is_store3_rename(is_store3_rename),
	
	.is_branch0_rename(is_branch0_rename),
	.is_branch1_rename(is_branch1_rename),
	.is_branch2_rename(is_branch2_rename),
	.is_branch3_rename(is_branch3_rename),
	
	.arc0(rd0_out),
   .arc1(rd1_out),
   .arc2(rd2_out),												
   .arc3(rd3_out),
    
   .physicalreg0(allocate_rd0),
	.physicalreg1(allocate_rd1),
   .physicalreg2(allocate_rd2),
	.physicalreg3(allocate_rd3),
	
   .stale_inst0(stale_inst0_rename),
	.stale_inst1(stale_inst1_rename),
	.stale_inst2(stale_inst2_rename),
	.stale_inst3(stale_inst3_rename),
	
   .BID0(BID0_new_rename),
	.BID1(BID1_new_rename),
	.BID2(BID2_new_rename),
	.BID3(BID3_new_rename),
    
	// stall signals from rename stage
	.stall_reservation_station_LS(stall_reservation_station_LS ),
	.stall_reservation_station(stall_reservation_station),
	.mt_stall(mt_stall),

	//execute stage inputs
	 .ROBlsu0(lsu0_ROBentry_execute_out),
    .lsu0valid(valid0_lw_sw_rob_out),
    .ROBlsu1(lsu1_ROBentry_execute_out),
    .lsu1valid(valid1_lw_sw_rob_out),
    .ROBalu0(alu0_ROBentry_exepipe_out),
    .alu0valid(alu0_result_ES[32]),
    .ROBalu1(alu1_ROBentry_exepipe_out),
    .alu1valid(alu1_result_ES[32]),
    .ROBalu2(alu2_ROBentry_exepipe_out),
    .alu2valid(alu2_result_ES[32]),
    

    .ROBbu(BU_ROBentry_exepipe_out),
    .buvalid(is_branch_ES),
    .BID(BU_BID_exepipe_out),
    .resolution(hit),
	.BIDs_flush(BIDs_flush),

    
   .tail(tail),
    
   .stall(ROB_stall), // rename stall w ma qblaha 
	
	.PRFindex0(commit_index0),
	.PRFindex1(commit_index1),
	.PRFindex2(commit_index2),
	.PRFindex3(commit_index3),
	.PRFvalue0(commit_value0),
	.PRFvalue1(commit_value1),
	.PRFvalue2(commit_value2),
	.PRFvalue3(commit_value3),
	
	
	
	//batch ready to commit
	.all_done(all_done_commit_out), // frpool 
	//to return to the free list of registers. 
	.return_stale0(return_stale0_commit_out),
	.return_stale1(return_stale1_commit_out),
	.return_stale2(return_stale2_commit_out),
	.return_stale3(return_stale3_commit_out),
	.PNR0(PNR0_commit_out),//if active then the stale is valid to be returned, if not then the stale must not be returned.
	.PNR1(PNR1_commit_out),
	.PNR2(PNR2_commit_out),
	.PNR3(PNR3_commit_out),
	.ROB_sw_commit0(ROB_sw_commit0),
	.ROB_sw_commit1(ROB_sw_commit1),
	.PNR_sw0(PNR_sw0),//if active then the ROB_sw_commit must be commited to the DATAmemory... if and only if the all done signal was active 
	.PNR_sw1(PNR_sw1)
  
);

endmodule