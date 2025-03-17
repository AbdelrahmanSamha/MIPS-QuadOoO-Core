module MUX5to1 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in0, in1, in2, in3,in4,
    input  [2:0] sel, // 4-bit selector (since 11 values require at least 4 bits)
    output reg [WIDTH-1:0] out
);

always @(*) begin
    case (sel)
        3'd0  : out = in0;
        3'd1  : out = in1;
        3'd2  : out = in2;
        3'd3  : out = in3;
        3'd4  : out = in4;
        default: out = {WIDTH{1'b0}}; // Default to zero if invalid selection
    endcase
end

endmodule
