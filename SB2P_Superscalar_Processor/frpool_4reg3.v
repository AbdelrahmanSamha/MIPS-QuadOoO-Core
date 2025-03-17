module frpool_4reg3 (
    input wire clk,
    input wire reset,
    input wire write,
	 input [15:0]in_branch,
	 input re_turn,
	 input all_done,
	 input stall,
	 input[5:0] physical_way3,
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
				in[physical_way3] = 1'b0;
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
        in[0]:  out = 6'b110000; // MSB - 48
        in[1]:  out = 6'b110001; // 49
        in[2]:  out = 6'b110010; // 50
        in[3]:  out = 6'b110011; // 51
        in[4]:  out = 6'b110100; // 52
        in[5]:  out = 6'b110101; // 53
        in[6]:  out = 6'b110110; // 54
        in[7]:  out = 6'b110111; // 55
        in[8]:  out = 6'b111000; // 56
        in[9]:  out = 6'b111001; // 57
        in[10]: out = 6'b111010; // 58
        in[11]: out = 6'b111011; // 59
        in[12]: out = 6'b111100; // 60
        in[13]: out = 6'b111101; // 61
        in[14]: out = 6'b111110; // 62
        in[15]: out = 6'b111111; // LSB - 63
        default: out = 6'b000000; // Default: No input is high
    endcase
end
endmodule
