module pipe_SW_cache(
input clk,reset,
input [31:0] Data_in0,Data_in1,Address_in0,Address_in1,
input [4:0] lsu0_ROBentry, lsu1_ROBentry,
input [5:0]lsu0_dest_in,lsu1_dest_in,
input rden0in, rden1in,
input write0in, write1in,

input [1:0] BID_PASS0,BID_PASS1,


input valid_lsu0_in, valid_lsu1_in,		
output reg valid_lsu0_out, valid_lsu1_out,

input dep_lw0_sw1_in, 

output reg dep_lw0_sw1_out,		

output reg [31:0] Data_out0,Data_out1,Address_out0,Address_out1,
output reg [5:0] lsu0_dest_out,lsu1_dest_out,
output reg [4:0] lsu0_ROBentry_out, lsu1_ROBentry_out,
output reg write0out, write1out,
output reg rden0out, rden1out,
output reg [1:0] BID_PASS0_out,BID_PASS1_out,

input dep_sw0_lw1,
output reg dep_sw0_lw1_out,

input dep_sw0_sw1_mux,

output reg dep_sw0_sw1_mux_out

);

always @(posedge clk ,posedge reset) begin 
			if(reset) begin 
				Data_out0 <= 32'b0;
				Data_out1 <= 32'b0; 
				Address_out0 <= 32'b0; 
				Address_out1 <= 32'b0;
				lsu0_dest_out <= 6'b0;
				lsu1_dest_out <= 6'b0;
				lsu0_ROBentry_out<= 5'b0;
				lsu1_ROBentry_out <= 5'b0;
				write0out<= 1'b0;
				write1out <= 1'b0;
				rden0out<= 1'b0;
				rden1out <= 1'b0;
				BID_PASS0_out <= 2'b00;
				BID_PASS1_out <= 2'b00;
				valid_lsu0_out <= 1'b0;
				valid_lsu1_out <= 1'b0;
				dep_lw0_sw1_out <= 1'b0;
				
				dep_sw0_lw1_out <= 1'b0 ;
				
				dep_sw0_sw1_mux_out <= 1'b0;
			end 
			else begin
				Data_out0 <= Data_in0;
				Data_out1 <= Data_in1; 
				Address_out0 <= Address_in0; 
				Address_out1 <= Address_in1;
				lsu0_dest_out <= lsu0_dest_in;
				lsu1_dest_out <= lsu1_dest_in;
				
				lsu0_ROBentry_out<= lsu0_ROBentry;
				lsu1_ROBentry_out <= lsu1_ROBentry;
				
				write0out<= write0in;
				write1out <= write1in;
				rden0out<=rden0in;
				rden1out<=rden1in;
				
				BID_PASS0_out <= BID_PASS0;
				BID_PASS1_out <= BID_PASS1;
				
				valid_lsu0_out <= valid_lsu0_in;
				valid_lsu1_out <= valid_lsu1_in;
				
				dep_lw0_sw1_out <= dep_lw0_sw1_in;
				
								dep_sw0_lw1_out <= dep_sw0_lw1 ;
								
												dep_sw0_sw1_mux_out <= dep_sw0_sw1_mux;



			end 
end
endmodule 
