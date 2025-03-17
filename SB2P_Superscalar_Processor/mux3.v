module mux3 #(parameter WIDTH = 32 )// Default data width
(
    input  [WIDTH-1:0] in0,  // Input 0
    input  [WIDTH-1:0] in1,  // Input 1
    input  [WIDTH-1:0] in2,  // Input 2
    input  [1:0] sel,        // 2-bit select signal (only values 0,1,2 are valid)
    output reg [WIDTH-1:0] out // MUX output
);

always @(*) begin
    case (sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        default: out = {WIDTH{1'b0}}; // Default case: output zero
    endcase
end

endmodule
