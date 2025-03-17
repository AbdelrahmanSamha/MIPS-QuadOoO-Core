module instruction_memory_reg (
	 rst,
    clk,                   // Clock signal
    address0,         // 8-bit address (for 256 words)
    address1,         // 8-bit address (for 256 words)
    instruction0,    // 128-bit wide instruction word
    instruction1    // 128-bit wide instruction word
);

	input clk,rst;
	input [7:0] address0;
	input [7:0] address1;
	output reg [127:0]instruction0;
	output reg [127:0]instruction1;


		
    // Declare memory array (256 words, each 128-bit wide)
    reg [127:0] mem [0:255];

    // Load memory contents from an external file using readmemh
    initial begin
        $readmemh("instruction_memory.mif", mem);  // Initialize memory from hex file
    end

    // Read operation on the rising edge of the clock
    always @(posedge clk or posedge rst) begin
	 if (rst) begin 
	 instruction0 <= 128'b0;
	 instruction1= 128'b0;
	 end 
		else begin
        instruction0 <= mem[address0];
        instruction1 <= mem[address1];
    end
	 end

endmodule
