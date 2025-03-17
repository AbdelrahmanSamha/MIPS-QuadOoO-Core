module frpool_4reg2 (
    input wire clk,
    input wire reset,
    input wire write,
	 input [15:0]in_branch,
	 input re_turn,
	 input all_done,
	 input stall,
	 input [5:0] physical_way2, 
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
				in[physical_way2] = 1'b0;
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
        in[0]:  out = 6'b100000; // MSB - 32
        in[1]:  out = 6'b100001; // 33
        in[2]:  out = 6'b100010; // 34
        in[3]:  out = 6'b100011; // 35
        in[4]:  out = 6'b100100; // 36
        in[5]:  out = 6'b100101; // 37
        in[6]:  out = 6'b100110; // 38
        in[7]:  out = 6'b100111; // 39
        in[8]:  out = 6'b101000; // 40
        in[9]:  out = 6'b101001; // 41
        in[10]: out = 6'b101010; // 42
        in[11]: out = 6'b101011; // 43
        in[12]: out = 6'b101100; // 44
        in[13]: out = 6'b101101; // 45
        in[14]: out = 6'b101110; // 46
        in[15]: out = 6'b101111; // LSB - 47
        default: out = 6'b000000; // Default: No input is high
    endcase
end
endmodule
