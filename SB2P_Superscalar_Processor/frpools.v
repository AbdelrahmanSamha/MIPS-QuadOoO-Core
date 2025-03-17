module frpools (

	//inputs
	
   input wire clk,
   input wire rst,
   
	input write_on_rd0_out,
	input write_on_rd1_out,
	input write_on_rd2_out,
	input write_on_rd3_out,
	 
	input [63:0] recovery_reg_mt, // 64 bit 
	 
	input hit,
	input isbranchexe,
	 
	input stall_reservation_station,
	 
	input stall_reservation_station_LS,
	
	input ROB_stall,
	
	// inputs from commit stage 
	
	input all_done,
	  
	input [5:0] return_stale0 , return_stale1, return_stale2, return_stale3,
	
	input PNR0, PNR1, PNR2, PNR3,
	
	input stall_allocate_rd0, stall_allocate_rd1, stall_allocate_rd2, stall_allocate_rd3,
	input mt_stall,
	input [5:0] physical_way0, physical_way1, physical_way2, physical_way3,
	
	input [5:0] allocate_rd0_in, allocate_rd1_in, allocate_rd2_in, allocate_rd3_in,
 
	 // outputs 
	 
	output [5:0] out0_frpool,
	output [5:0] out1_frpool,
	output [5:0] out2_frpool,
	output [5:0] out3_frpool,
	 
	output [63:0] frpool_reg_out,

	output out0_fr_is_zero, out1_fr_is_zero, out2_fr_is_zero, out3_fr_is_zero
	

);

	wire stall;
	assign stall = stall_reservation_station | stall_reservation_station_LS | mt_stall | ROB_stall;

	wire iswrite0_rename, iswrite1_rename, iswrite2_rename, iswrite3_rename;
		
	assign iswrite0_rename = (!((!write_on_rd0_out && stall_allocate_rd0) | stall | (!hit && isbranchexe)) && (allocate_rd0_in == 6'b0)) ? 1'b1 : 1'b0;
	assign iswrite1_rename = (!((!write_on_rd1_out && stall_allocate_rd1) | stall | (!hit && isbranchexe)) && (allocate_rd1_in == 6'b0)) ? 1'b1 : 1'b0;
	assign iswrite2_rename = (!((!write_on_rd2_out && stall_allocate_rd2) | stall | (!hit && isbranchexe)) && (allocate_rd2_in == 6'b0)) ? 1'b1 : 1'b0;
	assign iswrite3_rename = (!((!write_on_rd3_out && stall_allocate_rd3) | stall | (!hit && isbranchexe)) && (allocate_rd3_in == 6'b0)) ? 1'b1 : 1'b0;
	
	
// commit 

	reg [63:0] commit_word_64;
	wire [63:0] recovery_reg;
	
	assign recovery_reg = commit_word_64 | recovery_reg_mt;
	
always @(*) begin 
	commit_word_64 = 64'b0;
	if (all_done) begin 
		if (PNR0) begin
		commit_word_64[return_stale0] = 1'b1;
		end
		if (PNR1) begin
		commit_word_64[return_stale1] = 1'b1;
		end
		if (PNR2) begin
		commit_word_64[return_stale2] = 1'b1;
		end
		if (PNR3) begin
		commit_word_64[return_stale3] = 1'b1;
		end
	end
end


 priority_encoders_64in u_priority_encoders_64in (
   .clk(clk),
   .reset(rst),
   .write_0(write_on_rd0_out | iswrite0_rename),
   .write_1(write_on_rd1_out | iswrite1_rename),
   .write_2(write_on_rd2_out | iswrite2_rename),
   .write_3(write_on_rd3_out | iswrite3_rename),
	
   .in_branch(recovery_reg),
	
	.commit_enable(all_done),
   
	.recovery_enable(!hit && isbranchexe),
	
	.physical_way0(physical_way0),
	.physical_way1(physical_way1),
	.physical_way2(physical_way2),
	.physical_way3(physical_way3),
	
	.in(frpool_reg_out),
	
	.stall(stall),
   
	.pos0(out0_frpool),
	.pos1(out1_frpool),
	.pos2(out2_frpool),
	.pos3(out3_frpool), 
   
	.in_zero_enc64_0(out0_fr_is_zero),
	.in_zero_enc64_1(out1_fr_is_zero),	
   .in_zero_enc64_2(out2_fr_is_zero),
	.in_zero_enc64_3(out3_fr_is_zero)
	
);



/*

		/// return from mt 
frpool_4reg0 frpool_0(
                .clk(clk),
                .reset(rst),
                .write(write_on_rd0_out),
                .in_branch(recovery_reg[15:0]),
					 .all_done(all_done),
                .re_turn(!hit),
					 .physical_way0(physical_way0),
                .out(out0_frpool),
					 .in(frpool_reg_out0),
					 .stall(stall)                 //input 
        );

        frpool_4reg1 frpool_1(
                .clk(clk),
                .reset(rst),
                .write(write_on_rd1_out ),
                .in_branch(recovery_reg[31:16]),
					 .all_done(all_done),
                .re_turn(!hit),
					 .physical_way1(physical_way1),
                .out(out1_frpool),
					 .in(frpool_reg_out1),
					 .stall(stall)                //input 
        );

        frpool_4reg2 frpool_2(
                .clk(clk),
                .reset(rst),
                .write(write_on_rd2_out ),
                .in_branch(recovery_reg[47:32]),
					 .all_done(all_done),
                .re_turn(!hit),
					 .physical_way2(physical_way2),
                .out(out2_frpool),
					 .in(frpool_reg_out2),
					 .stall(stall)                  //input 
        );

        frpool_4reg3 frpool_3(
                .clk(clk),
                .reset(rst),
                .write(write_on_rd3_out),
                .in_branch(recovery_reg[63:48]),
					 .all_done(all_done),
                .re_turn(!hit),
                .out(out3_frpool),
					 .physical_way3(physical_way3),
					 .in(frpool_reg_out3),
					 .stall(stall)                 //input 
        );
		  
		  
		  */
endmodule 	