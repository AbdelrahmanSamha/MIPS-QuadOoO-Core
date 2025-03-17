module executepipe(
    input clk,
    input rst,

    /// ALU0
    input [31:0] alu0_source1_in, alu0_source2_in,
    input [4:0] alu0_ROBentry_in,
    input [5:0] alu0_dest_in,
    input [3:0] alu0_operation_in,
	 input [1:0] alu0_bid_in,
	
    output reg [31:0] alu0_source1_out, alu0_source2_out,
    output reg [4:0] alu0_ROBentry_out,
    output reg [5:0] alu0_dest_out,
    output reg [3:0] alu0_operation_out,
	 output reg [1:0] alu0_bid_out,
	 
    /// ALU1
    input [31:0] alu1_source1_in, alu1_source2_in,
    input [4:0] alu1_ROBentry_in,
    input [5:0] alu1_dest_in,
    input [3:0] alu1_operation_in,
	 input [1:0] alu1_bid_in,
	 
    output reg [31:0] alu1_source1_out, alu1_source2_out,
    output reg [4:0] alu1_ROBentry_out,
    output reg [5:0] alu1_dest_out,
    output reg [3:0] alu1_operation_out,
	 output reg [1:0] alu1_bid_out,
	 
    /// ALU2
    input [31:0] alu2_source1_in, alu2_source2_in,
    input [4:0] alu2_ROBentry_in,
    input [5:0] alu2_dest_in,
    input [3:0] alu2_operation_in,
	 input [1:0] alu2_bid_in,
	
    output reg [31:0] alu2_source1_out, alu2_source2_out,
    output reg [4:0] alu2_ROBentry_out,
    output reg [5:0] alu2_dest_out,
    output reg [3:0] alu2_operation_out,
	 output reg [1:0] alu2_bid_out,
	 
    
	 
    /// Branching Unit
    input [31:0] BU_source1_in, BU_source2_in,
    input [4:0] BU_ROBentry_in,
    input [2:0] BU_operation_in,
    input [9:0] BU_imm_in,
    input [1:0] BU_BID_in,
	 input BU_prediction_in,

    output reg [31:0] BU_source1_out, BU_source2_out,
    output reg [4:0] BU_ROBentry_out,
    output reg [2:0] BU_operation_out,
    output reg [9:0] BU_imm_out,
    output reg [1:0] BU_BID_out,
	 output reg BU_prediction_out
);

// ALU0 Pipeline Register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu0_source1_out <= 0;
        alu0_source2_out <= 0;
        alu0_ROBentry_out <= 0;
        alu0_dest_out <= 0;
        alu0_operation_out <= 0;
		  alu0_bid_out <= 0;
    end else begin
        alu0_source1_out <= alu0_source1_in;
        alu0_source2_out <= alu0_source2_in;
        alu0_ROBentry_out <= alu0_ROBentry_in;
        alu0_dest_out <= alu0_dest_in;
        alu0_operation_out <= alu0_operation_in;
		  alu0_bid_out <= alu0_bid_in;
    end
end

// ALU1 Pipeline Register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu1_source1_out <= 0;
        alu1_source2_out <= 0;
        alu1_ROBentry_out <= 0;
        alu1_dest_out <= 0;
        alu1_operation_out <= 0;
		  alu1_bid_out <= 0;
    end else begin
        alu1_source1_out <= alu1_source1_in;
        alu1_source2_out <= alu1_source2_in;
        alu1_ROBentry_out <= alu1_ROBentry_in;
        alu1_dest_out <= alu1_dest_in;
        alu1_operation_out <= alu1_operation_in;
		  alu1_bid_out <= alu1_bid_in;
    end
end

// ALU2 Pipeline Register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu2_source1_out <= 0;
        alu2_source2_out <= 0;
        alu2_ROBentry_out <= 0;
        alu2_dest_out <= 0;
        alu2_operation_out <= 0;
		  alu2_bid_out <= 0;
    end else begin
        alu2_source1_out <= alu2_source1_in;
        alu2_source2_out <= alu2_source2_in;
        alu2_ROBentry_out <= alu2_ROBentry_in;
        alu2_dest_out <= alu2_dest_in;
        alu2_operation_out <= alu2_operation_in;
		  alu2_bid_out <= alu2_bid_in;
    end
end



// Branching Unit Pipeline Register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        BU_source1_out <= 0;
        BU_source2_out <= 0;
        BU_ROBentry_out <= 0;
        BU_operation_out <= 0;
        BU_imm_out <= 0;
        BU_BID_out <= 0;
		  BU_prediction_out<= 0; 
    end else begin
        BU_source1_out <= BU_source1_in;
        BU_source2_out <= BU_source2_in;
        BU_ROBentry_out <= BU_ROBentry_in;
        BU_operation_out <= BU_operation_in;
        BU_imm_out <= BU_imm_in;
        BU_BID_out <= BU_BID_in;
		  BU_prediction_out <= BU_prediction_in;
    end
end

endmodule