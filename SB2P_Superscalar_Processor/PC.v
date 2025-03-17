module PC(pc_next,pc0_out,pc1_out,Stall,reset,clk);
	input clk,reset;
	input  [7:0]pc_next;
	input Stall;
	output reg [7:0]pc0_out;
	output reg [7:0]pc1_out;

	always @(posedge clk , posedge reset)begin
		if(reset) begin
			pc0_out <= 8'hFF;
			pc1_out <= 8'h0;
		end
		else if(Stall)begin
			pc0_out <= pc0_out;
			pc1_out <= pc0_out + 8'b1 ;
		end
		else begin
			pc0_out <= pc_next;
			pc1_out <= pc_next + 8'b1 ;
		end
	end
endmodule