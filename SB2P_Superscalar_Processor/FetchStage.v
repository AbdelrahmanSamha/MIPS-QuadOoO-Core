module FetchStage(clk,reset,
						Address_Branch,hit,is_branchexe,
						pc0_out,pc1_out,inst0, inst1 , inst2, inst3,
						branching_flush0, branching_flush1, branching_flush2, branching_flush3,Stall,
						jr_index_out, jr_address_prf,
						write_on_rd0_decode,
						write_on_rd1_decode,
						write_on_rd2_decode,
						write_on_rd3_decode,
						rd0_decode,
						rd1_decode,
						rd2_decode,
						rd3_decode,
						stall_branching_unit,
						valid_index_prf_in,
						valid_index_fs_out,
						stop_fetch
);
		

	 output valid_index_fs_out; 

	 input valid_index_prf_in;
	 output reg stop_fetch;
	
		
	 input clk,reset;
	 input [9:0]Address_Branch;
	 input hit;
	 input is_branchexe;
	 input Stall;
	 output [31:0] inst0, inst1 , inst2, inst3; // Instructions
	 output stall_branching_unit;
	 
	 ///////////////////////////// jr
	 output [4:0] jr_index_out;
	 input [10:0] jr_address_prf;
	 
	 input write_on_rd0_decode;
	 input write_on_rd1_decode;
	 input write_on_rd2_decode;
	 input write_on_rd3_decode;
	 
	 input [4:0] rd0_decode; 
	 input [4:0] rd1_decode; 
	 input [4:0] rd2_decode; 
	 input [4:0] rd3_decode; 
	 
	 
	 wire stall_fetch_sum ;
	 assign stall_fetch_sum = ((Stall | stall_branching_unit) && (!(!hit && is_branchexe)));
  
	 wire addres_mux_pc_jump_sel;
	 
	 
	 wire [31:0] instruction0, instruction1, instruction2, instruction3; // Instructions
	 wire [31:0] addi; // Instructions

	 wire [31:0]inst0_new, inst1_new, inst2_new, inst3_new;
	 
	 wire [1:0]mux0_sel, mux1_sel, mux2_sel, mux3_sel;
	// Wires and signals
    wire [127:0] fetched_word0;       // Output from InstructionMemory
    wire [127:0] fetched_word1;       // Output from InstructionMemory;
	 
	 wire [9:0] jump_address;

	 
	 output [7:0] pc0_out, pc1_out;               // Updated PC
             
    wire [1:0] offset;               // Offset for aligning instructions


	 output branching_flush0, branching_flush1, branching_flush2, branching_flush3; // Flush signals for `SB2P_Branching_Unit`
	 
	 wire [3:0] prediction;
	 
	 
	 wire [7:0] pc0_next,pc1_next, pc0_mux,pc1_mux;
	
	
		 
	PC pc(.pc_next(pc0_mux),
	.pc0_out(pc0_out),
	.pc1_out(pc1_out),
	.reset(reset),
	.clk(clk),
	.Stall(stall_fetch_sum)
	); 
		 

	 
	 assign pc0_next = pc0_out + 8'b1 ;
	 assign pc1_mux = pc0_mux + 8'b1 ;

	 
	 
	 mux3 #(32) mux_inst_out0(
    .in0(instruction0),  
    .in1(addi),  
    .in2(inst0_new), 
    .sel(mux0_sel),      
    .out(inst0));
	 
	 mux3 #(32) mux_inst_out1(
    .in0(instruction1),  
    .in1(addi),  
    .in2(inst1_new), 
    .sel(mux1_sel),      
    .out(inst1));
	 
	 mux3 #(32) mux_inst_out2(
    .in0(instruction2),  
    .in1(addi),  
    .in2(inst2_new), 
    .sel(mux2_sel),      
    .out(inst2));
	 
	 mux3 #(32) mux_inst_out3(
    .in0(instruction3),  
    .in1(addi),  
    .in2(inst3_new), 
    .sel(mux3_sel),      
    .out(inst3));
	 
	 ////
	instruction_memory_2ports mem (
	.address_a(pc0_mux),
	.address_b(pc1_mux),
	.addressstall_a(stall_fetch_sum),
	.addressstall_b(stall_fetch_sum),
	.clock(clk),
	.q_a(fetched_word0),
	.q_b(fetched_word1)
	);
	 /*
	     instruction_memory_reg imem (
		  .rst(reset),
        .clk(clk), 
        .address0(pc0_out), 
        .address1(pc1_out), 
        .instruction0(fetched_word0),
        .instruction1(fetched_word1)
		  );
	 */
	 /////
    // Branching Unit Instance
	 SB2P_Branch_Prediction Branch_pred(
    .clk(clk),
    .reset(reset),
    .branch(is_branchexe),            
    .taken(hit),          
    .Branch_offset0(instruction0[9:0]),        
    .Branch_offset1(instruction1[9:0]),
    .Branch_offset2(instruction2[9:0]),
    .Branch_offset3(instruction3[9:0]),
	 
	 .Branch_op0(instruction0[31:26]),
	 .Branch_op1(instruction1[31:26]),
	 .Branch_op2(instruction2[31:26]),
	 .Branch_op3(instruction3[31:26]),
	 
	 .pc(pc0_out),
    .prediction(prediction)    // Predictions for 4 branches
);

    SB2P_Branching_Unit branching_unit (
        .instruction0(instruction0),
        .instruction1(instruction1),
        .instruction2(instruction2),
        .instruction3(instruction3),
		  .Address_Branch(Address_Branch),
			
		  .is_branchexe(is_branchexe),
		  .hit(hit),

		  .prediction(prediction),
        .flush0(branching_flush0),
        .flush1(branching_flush1),
        .flush2(branching_flush2),
        .flush3(branching_flush3),

		  
        .offset(offset),
		  .clk(clk),
		  .reset(reset),
		  
		  .new_branch_inst0(inst0_new),.new_branch_inst1(inst1_new),.new_branch_inst2(inst2_new),.new_branch_inst3(inst3_new),
	 
		  .mux0_sel(mux0_sel),.mux1_sel(mux1_sel),.mux2_sel(mux2_sel),.mux3_sel(mux3_sel),
		  
		  .addi(addi),
		  
		  .pc_in(pc0_out),
		  
		  .jump_address(jump_address),
		  
		  .addres_mux_pc_jump_sel(addres_mux_pc_jump_sel),
		  
		  .jr_index_out(jr_index_out), //  output
		  
		  .jr_address_prf(jr_address_prf), // input 
		  
		  .write_on_rd0_decode(write_on_rd0_decode),
		  .write_on_rd1_decode(write_on_rd1_decode),
		  .write_on_rd2_decode(write_on_rd2_decode),
		  .write_on_rd3_decode(write_on_rd3_decode),
	 
	 
		  .rd0_decode(rd0_decode),
		  .rd1_decode(rd1_decode),
		  .rd2_decode(rd2_decode),
		  .rd3_decode(rd3_decode),
		  
		  .stall(stall_branching_unit),
		  
		  
		  .valid_index_fs_out(valid_index_fs_out),

		  .valid_index_prf_in(valid_index_prf_in),
		  
		  .stall_in(Stall)

    );

    // Instruction Aligner Instance
    instruction_aligner aligner (
        .fetched_word0(fetched_word0),
        .fetched_word1(fetched_word1),
        .offset(offset),
        .instruction0(instruction0),
        .instruction1(instruction1),
        .instruction2(instruction2),
        .instruction3(instruction3)
    );

	 

	  mux2 #(8) next_address_mex(
    .in0(pc0_next),  
    .in1(jump_address[9:2]),   
    .sel(addres_mux_pc_jump_sel),      
    .out(pc0_mux));
	 
    always @(*) begin
    if (instruction0 == 32'h00000000 && instruction1 == 32'h00000000 &&
        instruction2 == 32'h00000000 && instruction3 == 32'h00000000) 
    begin
        stop_fetch = 1;
    end else begin
        stop_fetch = 0;
    end
end
	 
	 
endmodule