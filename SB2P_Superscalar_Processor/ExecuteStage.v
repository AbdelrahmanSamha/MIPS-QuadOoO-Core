module ExecuteStage (
    input clk,
    input rst,

    // ALU0
    input [31:0] alu0_source1_ES, alu0_source2_ES,
    input [3:0]  alu0_operation_ES,
	 input [1:0]  alu0_bid_ES_in,

    // ALU1
    input [31:0] alu1_source1_ES, alu1_source2_ES,
    input [3:0]  alu1_operation_ES,
	 input [1:0]  alu1_bid_ES_in,
	 
    // ALU2
    input [31:0] alu2_source1_ES, alu2_source2_ES,
    input [3:0]  alu2_operation_ES,
	 input [1:0]  alu2_bid_ES_in,
	 
    
	 
    // Branching Unit
    input [31:0] BU_source1_ES, BU_source2_ES,
    input [2:0]  BU_operation_ES,
	 input BU_prediction_ES,
	 input [9:0]  BU_imm_ES,
	 input [1:0] BU_BID_ES,
	
	//Load Store Unit
	input [31:0] lsu0_Rt_source,lsu0_address,
	input [4:0]  lsu0_ROBentry,
	input [5:0]  lsu0_dest,
	input [1:0]  lsu0_operation_ReadS,
	input[1:0] lsu0_bid_in,
	
	input [31:0] lsu1_Rt_source,lsu1_address,
	input [4:0]  lsu1_ROBentry,
	input [5:0]  lsu1_dest,
	input [1:0]  lsu1_operation_ReadS,
	input[1:0] lsu1_bid_in,
	
	input PNR_sw0,PNR_sw1,
	input [4:0]ROB_commit0,ROB_commit1,
	
	input [1:0] H,
	input [1:0] M,
	input [1:0] L,

	input valid_lsu0_in, // input from read stage 
	input valid_lsu1_in,
	
	input stall_ls,
	
   input all_done, 
	input dep_lw0_sw1, dep_sw0_sw1_mux,//dependency check between lsu inputs, considered a part of the read stage...
	
	
	 output valid_lsu0_out, valid_lsu1_out,
	 
    // ALU Outputs
    output reg[32:0] alu0_result_ES,
    output reg[32:0] alu1_result_ES,
    output reg[32:0] alu2_result_ES,
    
	 //new branch IDs
	 
	 output reg [1:0] alu0_bid_ES_out, alu1_bid_ES_out, alu2_bid_ES_out, lsu0_bid_ES_out, lsu1_bid_ES_out,

    // Branch Unit Outputs
    output is_branch_ES,
	 output is_Jr,
	 output hit,
	 output [9:0]address,
	 output [6:0] BIDs_flush,
	 
	 
	 //LW_SW Unit output
	 output [32:0] lsu0_result_ES, lsu1_result_ES,
	 output [5:0] lsu0_dest_out, lsu1_dest_out,
	 output [4:0] lsu0_ROBentry_out, lsu1_ROBentry_out,
	 output isfull,
	 output [2:0] size_cache,
	 output [1:0] number_of_commit,
	 output valid0_lw_sw_rob_out, valid1_lw_sw_rob_out,
	 input dep_sw0_lw1


	 );
	
	wire[32:0] alu0_result, alu1_result,alu2_result ,alu3_result;
	
    // ALU Instances
    ALU alu0 (
        .operand1(alu0_source1_ES),
        .operand2(alu0_source2_ES),
        .opSel(alu0_operation_ES),
        .result(alu0_result)
    );
	 
	 always @(*) begin
	  alu0_result_ES = alu0_result;
	  alu0_bid_ES_out = alu0_bid_ES_in;
	  if(BIDs_flush[6])begin 
			if (BIDs_flush[{1'b0,alu0_bid_ES_in}]) alu0_bid_ES_out = BIDs_flush[5:4];
	  end 
	  else begin 
			if (BIDs_flush[{1'b0,alu0_bid_ES_in}]) alu0_result_ES[32] = 1'b0;
	  end 
	  
	 end	

    ALU alu1 (
        .operand1(alu1_source1_ES),
        .operand2(alu1_source2_ES),
        .opSel(alu1_operation_ES),
        .result(alu1_result)
    );
	 
	 
	
	always @(*) begin
	  alu1_result_ES = alu1_result;
	  alu1_bid_ES_out = alu1_bid_ES_in;
	  if(BIDs_flush[6])begin 
			if (BIDs_flush[{1'b0,alu1_bid_ES_in}]) alu1_bid_ES_out = BIDs_flush[5:4];
	  end 
	  else begin 
			if (BIDs_flush[{1'b0,alu1_bid_ES_in}]) alu1_result_ES[32] = 1'b0;
	  end 
	  
	 end	
	
    ALU alu2 (
        .operand1(alu2_source1_ES),
        .operand2(alu2_source2_ES),
        .opSel(alu2_operation_ES),
        .result(alu2_result)
    );
	 
	 always @(*) begin
	  alu2_result_ES = alu2_result;
	  alu2_bid_ES_out = alu2_bid_ES_in;
	  if(BIDs_flush[6])begin 
			if (BIDs_flush[{1'b0,alu2_bid_ES_in}]) alu2_bid_ES_out = BIDs_flush[5:4];
			end 
	  else begin 
			if (BIDs_flush[{1'b0,alu2_bid_ES_in}]) alu2_result_ES[32] = 1'b0;
		end 
	  
	 end	

   
	 
	 

    // Branch Unit Instance
    branchUnit bu (
        .operand1(BU_source1_ES),
        .operand2(BU_source2_ES),
        .operation(BU_operation_ES),
		  .prediction(BU_prediction_ES),
		  .immediate(BU_imm_ES),
		  .BID(BU_BID_ES),
		  .H(H), .M(M),.L(L),
        .is_branch(is_branch_ES),
        .is_Jr(is_Jr),
		  .address(address),
		  .hit(hit),
		  .BIDs_flush(BIDs_flush)
    );
	 
	 
	 //Load Store unit instance here 
	 reg [1:0] lsu0_operation, lsu1_operation; 
	 reg [1:0] lsu0_bid_checked, lsu1_bid_checked;
	 //making the operation 00 when a misprediction happens, these wires belong to the readstage, we handle the execute stage LSU flush inside the LSU module. 
	 /*always @(*) begin
		lsu0_operation = lsu0_operation_ReadS;
		lsu1_operation = lsu1_operation_ReadS;
		
		if (BIDs_flush[lsu0_bid]) lsu0_operation= 2'b00 ;
		if (BIDs_flush[lsu1_bid]) lsu1_operation= 2'b00 ;
	 end*/
	 
	 
	 always @(*) begin
	   lsu0_operation = lsu0_operation_ReadS;
		lsu0_bid_checked = lsu0_bid_in;
		
	   lsu1_operation = lsu1_operation_ReadS;
		lsu1_bid_checked = lsu1_bid_in;
		
			if(BIDs_flush[6])begin 
					if (BIDs_flush[{1'b0,lsu0_bid_in}]) lsu0_bid_checked = BIDs_flush[5:4];
					if (BIDs_flush[{1'b0,lsu1_bid_in}]) lsu1_bid_checked = BIDs_flush[5:4];
			end 
			else begin 
					if (BIDs_flush[{1'b0,lsu0_bid_in}]) lsu0_operation= 2'b00 ;
					if (BIDs_flush[{1'b0,lsu1_bid_in}]) lsu1_operation= 2'b00 ;
			end 
	  
	 end	

	 
	 wire Write0,Write1,rden0,rden1; 
	 assign Write0 = ((lsu0_operation == 2'b10) && !stall_ls) ? 1'b1 : 1'b0 ;
	 assign rden0 = ((lsu0_operation == 2'b01) && !stall_ls) ? 1'b1 : 1'b0 ;
	 
	 assign Write1 = ((lsu1_operation == 2'b10) && !stall_ls) ? 1'b1 : 1'b0 ;
	 assign rden1 = ((lsu1_operation == 2'b01) && !stall_ls) ? 1'b1 : 1'b0 ;
	 
	     wire [4:0] lsu0_ROBentry_after_stall, lsu1_ROBentry_after_stall;

	
	//wire [31:0] lsu0_Rt_source_mux, lsu1_Rt_source_mux;
		
	 //mux2 #(32) source0_mux (.in0(lsu0_Rt_source), .in1(32'b0), .sel(stall_ls), .out(lsu0_Rt_source_mux));
	 //mux2 #(32) source1_mux (.in0(lsu1_Rt_source), .in1(32'b0), .sel(stall_ls), .out(lsu1_Rt_source_mux));	
	
    mux2 #(5) lsu0_ROBentry_mux (.in0(lsu0_ROBentry), .in1(5'b0), .sel(stall_ls), .out(lsu0_ROBentry_after_stall));
    mux2 #(5) lsu1_ROBentry_mux (.in0(lsu1_ROBentry), .in1(5'b0), .sel(stall_ls), .out(lsu1_ROBentry_after_stall));
	 
	 
	 
	 
	 
	 
  // Muxes for swapping LSU0 and LSU1 inputs based on dep_lw0_sw1
    wire [31:0] lsu0_Rt_swapped, lsu1_Rt_swapped;
    mux2 #(32) mux_lsu0_Rt (.in0(lsu0_Rt_source), .in1(lsu1_Rt_source), .sel(dep_lw0_sw1), .out(lsu0_Rt_swapped));
    mux2 #(32) mux_lsu1_Rt (.in0(lsu1_Rt_source), .in1(lsu0_Rt_source), .sel(dep_lw0_sw1), .out(lsu1_Rt_swapped));

    wire [31:0] lsu0_addr_swapped, lsu1_addr_swapped;
    mux2 #(32) mux_lsu0_addr (.in0(lsu0_address), .in1(lsu1_address), .sel(dep_lw0_sw1), .out(lsu0_addr_swapped));
    mux2 #(32) mux_lsu1_addr (.in0(lsu1_address), .in1(lsu0_address), .sel(dep_lw0_sw1), .out(lsu1_addr_swapped));

    wire [5:0] lsu0_dest_swapped, lsu1_dest_swapped;
    mux2 #(6) mux_lsu0_dest (.in0(lsu0_dest), .in1(lsu1_dest), .sel(dep_lw0_sw1), .out(lsu0_dest_swapped));
    mux2 #(6) mux_lsu1_dest (.in0(lsu1_dest), .in1(lsu0_dest), .sel(dep_lw0_sw1), .out(lsu1_dest_swapped));



    wire [4:0] lsu0_ROB_swapped, lsu1_ROB_swapped;
    mux2 #(5) mux_lsu0_rob (.in0(lsu0_ROBentry_after_stall), .in1(lsu1_ROBentry_after_stall), .sel(dep_lw0_sw1), .out(lsu0_ROB_swapped));
    mux2 #(5) mux_lsu1_rob (.in0(lsu1_ROBentry_after_stall), .in1(lsu0_ROBentry_after_stall), .sel(dep_lw0_sw1), .out(lsu1_ROB_swapped));

    wire [1:0] lsu0_op_swapped, lsu1_op_swapped;
    mux2 #(2) mux_lsu0_op (.in0(lsu0_operation_ReadS), .in1(lsu1_operation_ReadS), .sel(dep_lw0_sw1), .out(lsu0_op_swapped));
    mux2 #(2) mux_lsu1_op (.in0(lsu1_operation_ReadS), .in1(lsu0_operation_ReadS), .sel(dep_lw0_sw1), .out(lsu1_op_swapped));

    wire [1:0] lsu0_bid_swapped, lsu1_bid_swapped;
    mux2 #(2) mux_lsu0_bid (.in0(lsu0_bid_in), .in1(lsu1_bid_in), .sel(dep_lw0_sw1), .out(lsu0_bid_swapped));
    mux2 #(2) mux_lsu1_bid (.in0(lsu1_bid_in), .in1(lsu0_bid_in), .sel(dep_lw0_sw1), .out(lsu1_bid_swapped));

    wire valid_lsu0_swapped, valid_lsu1_swapped;
    mux2 #(1) mux_valid0 (.in0(valid_lsu0_in), .in1(valid_lsu1_in), .sel(dep_lw0_sw1), .out(valid_lsu0_swapped));
    mux2 #(1) mux_valid1 (.in0(valid_lsu1_in), .in1(valid_lsu0_in), .sel(dep_lw0_sw1), .out(valid_lsu1_swapped));
	 
	 wire rden0_swapped, rden1_swapped;
	 mux2 #(1) mux_rden0 (.in0(rden0), .in1(rden1), .sel(dep_lw0_sw1), .out(rden0_swapped));
    mux2 #(1) mux_rden1 (.in0(rden1), .in1(rden0), .sel(dep_lw0_sw1), .out(rden1_swapped));
    
	 wire Write0_swapped,Write1_swapped;
	 mux2 #(1) mux_Write0 (.in0(Write0), .in1(Write1), .sel(dep_lw0_sw1), .out(Write0_swapped));
	 mux2 #(1) mux_Write1 (.in0(Write1), .in1(Write0), .sel(dep_lw0_sw1), .out(Write1_swapped));
 

	 
	 /////////
	 
	 LW_SWpass lw_swpass(
			  .clk(clk),.reset(rst),
			  .lsu0_Rt_source(lsu0_Rt_swapped),
           .lsu1_Rt_source(lsu1_Rt_swapped),
			  
           .inpaddress0(lsu0_addr_swapped),
           .inpaddress1(lsu1_addr_swapped),
			  
           .lsu0_dest(lsu0_dest_swapped),
           .lsu1_dest(lsu1_dest_swapped),
			  
			  .write0(Write0_swapped),
			  .write1(Write1_swapped),
			  
			  .rden0(rden0_swapped),
			  .rden1(rden1_swapped),
			  
           .lsu0_ROBentry(lsu0_ROB_swapped),
           .lsu1_ROBentry(lsu1_ROB_swapped),
			  
           .lsu0_bid(lsu0_bid_swapped),
           .lsu1_bid(lsu1_bid_swapped),
			  
			  .BIDs_flush(BIDs_flush),
			  .PNR_sw0(PNR_sw0),.PNR_sw1(PNR_sw1),
			  .ROB_commit0(ROB_commit0),.ROB_commit1(ROB_commit1),
			  .dep_lw0_sw1(dep_lw0_sw1), .dep_sw0_sw1_mux(dep_sw0_sw1_mux),
			  //outputs 
			  .lsu0_dest_out_flip_dep(lsu0_dest_out),.lsu1_dest_out_flip_dep(lsu1_dest_out),
			  .lsu0_ROBentry_out_flip_dep(lsu0_ROBentry_out), .lsu1_ROBentry_out_flip_dep(lsu1_ROBentry_out),
			  .lsu0_result_ES_flip_dep(lsu0_result_ES),.lsu1_result_ES_flip_dep_final_out(lsu1_result_ES),
			  .size_cache(size_cache),
			  .number_of_commit(number_of_commit),
			  .isfull(isfull),
			  
           .valid_lsu0_in(valid_lsu0_swapped),
           .valid_lsu1_in(valid_lsu1_swapped),
			  
			  .valid_lsu0_out(valid_lsu0_out),
			  .valid_lsu1_out(valid_lsu1_out),
			  .valid0_lw_sw_rob_out_flip_dep(valid0_lw_sw_rob_out),
			  .valid1_lw_sw_rob_out_flip_dep(valid1_lw_sw_rob_out),
			  .all_done(all_done) ,
			  .dep_sw0_lw1(dep_sw0_lw1)

			  );
			

endmodule