module frpool_4reg1 (
    input wire clk,
    input wire reset,
    input wire write,
	 input [15:0]in_branch,
	 input re_turn,
	 input all_done,
	 input stall,
	 input [5:0] physical_way1, 
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
				in[physical_way1] = 1'b0;
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
        in[0]:  out = 6'b010000; // MSB - 16
        in[1]:  out = 6'b010001; // 17
        in[2]:  out = 6'b010010; // 18
        in[3]:  out = 6'b010011; // 19
        in[4]:  out = 6'b010100; // 20
        in[5]:  out = 6'b010101; // 21
        in[6]:  out = 6'b010110; // 22
        in[7]:  out = 6'b010111; // 23
        in[8]:  out = 6'b011000; // 24
        in[9]:  out = 6'b011001; // 25
        in[10]: out = 6'b011010; // 26
        in[11]: out = 6'b011011; // 27
        in[12]: out = 6'b011100; // 28
        in[13]: out = 6'b011101; // 29
        in[14]: out = 6'b011110; // 30
        in[15]: out = 6'b011111; // LSB - 31
        default: out = 6'b000000; // Default: No input is high
    endcase
    end
endmodule
