module frpool_4reg0 (
    input wire clk,
    input wire reset,
    input wire write,
	 input [15:0]in_branch,
	 input re_turn,
	 input all_done,
	 input stall,
	 input [5:0] physical_way0,
    output reg [5:0] out,
	 output reg [15:0] in
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in = 16'b1010_1010_1010_1000; 
        end
		  else if (stall) begin
				in = in;
		  end
		  else if (re_turn) begin
				in = in_branch;
				in[physical_way0] = 1'b0;
				
		  end
		  else if(all_done)begin
				in = in | in_branch;
				if (write) begin
				  // in <= in & ~(16'b1 << out);
					in[out[3:0]] = 1'b0; // out[3:0] ==> out % 16 
				end
		  end
		  else if (write) begin
           // in <= in & ~(16'b1 << out);
				in[out[3:0]] = 1'b0; // out[3:0] ==> out % 16 
        end
    end
 
always @(*) begin
    case (1'b1)
        in[0]:  out = 6'b000000; // MSB - 0
        in[1]:  out = 6'b000001; // 1
        in[2]:  out = 6'b000010; // 2
        in[3]:  out = 6'b000011; // 3
        in[4]:  out = 6'b000100; // 4
        in[5]:  out = 6'b000101; // 5
        in[6]:  out = 6'b000110; // 6
        in[7]:  out = 6'b000111; // 7
        in[8]:  out = 6'b001000; // 8
        in[9]:  out = 6'b001001; // 9
        in[10]: out = 6'b001010; // 10
        in[11]: out = 6'b001011; // 11
        in[12]: out = 6'b001100; // 12
        in[13]: out = 6'b001101; // 13
        in[14]: out = 6'b001110; // 14
        in[15]: out = 6'b001111; // LSB - 15
        default: out = 6'b000000; // Default: No input is high
    endcase
    end
endmodule