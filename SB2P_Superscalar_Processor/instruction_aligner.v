module instruction_aligner (
    fetched_word0, 
    fetched_word1, 
    offset, 
    instruction0, instruction1, instruction2, instruction3
);

    // Input Signals
    input [127:0] fetched_word0;  // Fetched 128-bit word
    input [127:0] fetched_word1;  // Fetched 128-bit word
    input [1:0] offset;          // Offset for starting instruction

    // Output Signals
    output reg [31:0] instruction0; // Aligned instruction slot 0
    output reg [31:0] instruction1; // Aligned instruction slot 1
    output reg [31:0] instruction2; // Aligned instruction slot 2
    output reg [31:0] instruction3; // Aligned instruction slot 3


	 
  	always@(*)begin
        // Align instructions based on offset
        case (offset)
            2'b00: begin
                instruction0 = fetched_word0[31:0];
                instruction1 = fetched_word0[63:32];
                instruction2 = fetched_word0[95:64];
                instruction3 = fetched_word0[127:96];
            end
            2'b01: begin
                instruction0 = fetched_word0[63:32];
                instruction1 = fetched_word0[95:64];
                instruction2 = fetched_word0[127:96];
                instruction3 = fetched_word1[31:0];
            end
            2'b10: begin
                instruction0 = fetched_word0[95:64];
                instruction1 = fetched_word0[127:96];
                instruction2 = fetched_word1[31:0];
                instruction3 = fetched_word1[63:32];
            end
            2'b11: begin
                instruction0 = fetched_word0[127:96];
                instruction1 = fetched_word1[31:0];
                instruction2 = fetched_word1[63:32];
                instruction3 = fetched_word1[95:64];
            end
        endcase
    end
endmodule
