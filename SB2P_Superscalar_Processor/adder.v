module adder #(parameter size=32) (
input signed [size-1:0] in0,in1,
output [size-1:0] out);

assign out =in0 + in1; 

endmodule