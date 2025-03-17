module MUX11to1 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in0, in1, in2, in3, in4, 
                       in5, in6, in7, in8, in9, 
    input  [3:0] sel, // 4-bit selector (since 11 values require at least 4 bits)
    output reg [WIDTH-1:0] out
);

always @(*) begin
    case (sel)
        4'd0  : out = in0;
        4'd1  : out = in1;
        4'd2  : out = in2;
        4'd3  : out = in3;
        4'd4  : out = in4;
        4'd5  : out = in5;
        4'd6  : out = in6;
        4'd7  : out = in7;
        4'd8  : out = in8;
        4'd9  : out = in9;
        default: out = {WIDTH{1'b0}}; // Default to zero if invalid selection
    endcase
end

endmodule
