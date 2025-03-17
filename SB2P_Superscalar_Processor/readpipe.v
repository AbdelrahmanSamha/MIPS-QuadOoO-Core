module readpipe (
    input clk, rst,

    // ALU0
    input [4:0]  alu0_ROBentry_readpipe_in,
    input [5:0]  alu0_dest_readpipe_in,
    input [3:0]  alu0_operation_readpipe_in,
    input [5:0]  alu0_s1_index_readpipe_in,
    input [1:0]  alu0_bid_readpipe_in,
    input        alu0_is_Itype_readpipe_in,
    input [1:0]  alu0_s1_alu_forwarding_readpipe_in,
    input [1:0]  alu0_s2_alu_forwarding_readpipe_in,
    input [1:0]  alu0_s1_lsu_forwarding_readpipe_in,
    input [1:0]  alu0_s2_lsu_forwarding_readpipe_in,
    input        alu0_s1_needforwarding_readpipe_in,
    input        alu0_s2_needforwarding_readpipe_in,
    input [15:0] alu0_imm16b_readpipe_in,

    // ALU1
    input [4:0]  alu1_ROBentry_readpipe_in,
    input [5:0]  alu1_dest_readpipe_in,
    input [3:0]  alu1_operation_readpipe_in,
    input [5:0]  alu1_s1_index_readpipe_in,
    input [1:0]  alu1_bid_readpipe_in,
    input        alu1_is_Itype_readpipe_in,
    input [1:0]  alu1_s1_alu_forwarding_readpipe_in,
    input [1:0]  alu1_s2_alu_forwarding_readpipe_in,
    input [1:0]  alu1_s1_lsu_forwarding_readpipe_in,
    input [1:0]  alu1_s2_lsu_forwarding_readpipe_in,
    input        alu1_s1_needforwarding_readpipe_in,
    input        alu1_s2_needforwarding_readpipe_in,
    input [15:0] alu1_imm16b_readpipe_in,

    // ALU2
    input [4:0]  alu2_ROBentry_readpipe_in,
    input [5:0]  alu2_dest_readpipe_in,
    input [3:0]  alu2_operation_readpipe_in,
    input [5:0]  alu2_s1_index_readpipe_in,
    input [1:0]  alu2_bid_readpipe_in,
    input        alu2_is_Itype_readpipe_in,
    input [1:0]  alu2_s1_alu_forwarding_readpipe_in,
    input [1:0]  alu2_s2_alu_forwarding_readpipe_in,
    input [1:0]  alu2_s1_lsu_forwarding_readpipe_in,
    input [1:0]  alu2_s2_lsu_forwarding_readpipe_in,
    input        alu2_s1_needforwarding_readpipe_in,
    input        alu2_s2_needforwarding_readpipe_in,
    input [15:0] alu2_imm16b_readpipe_in,

  

    // BU
    input [4:0]  bu_ROBentry_readpipe_in,
    input [2:0]  bu_operation_readpipe_in,
    input [9:0]  bu_imm_readpipe_in,
    input [1:0]  bu_BID_readpipe_in,
    input        bu_prediction_readpipe_in,
    input [5:0]  bu_s1_index_readpipe_in, bu_s2_index_readpipe_in,
    input        bu_is_branch_readpipe_in, bu_is_Jr_readpipe_in,
    input [1:0]  bu_s1_alu_forwarding_readpipe_in, bu_s2_alu_forwarding_readpipe_in,
    input [1:0]  bu_s1_lsu_forwarding_readpipe_in, bu_s2_lsu_forwarding_readpipe_in,
    input        bu_s1_needforwarding_readpipe_in, bu_s2_needforwarding_readpipe_in,

    // LSU0
    input [4:0]  lsu0_ROBentry_readpipe_in,
    
    input [1:0]  lsu0_operation_readpipe_in,
    input [5:0]  lsu0_Rt_index_readpipe_in,
    input [5:0]  lsu0_Rs_index_readpipe_in,
    input [1:0]  lsu0_bid_readpipe_in,
    input [1:0]  lsu0_Rt_alu_forwarding_readpipe_in,
    input [1:0]  lsu0_Rs_alu_forwarding_readpipe_in,
    input [1:0]  lsu0_Rt_lsu_forwarding_readpipe_in,
    input [1:0]  lsu0_Rs_lsu_forwarding_readpipe_in,
    input        lsu0_Rt_needforwarding_readpipe_in,
    input        lsu0_Rs_needforwarding_readpipe_in,
    input [15:0] lsu0_imm_readpipe_in,

    // LSU1
    input [4:0]  lsu1_ROBentry_readpipe_in,
    
    input [1:0]  lsu1_operation_readpipe_in,
    input [5:0]  lsu1_Rt_index_readpipe_in,
    input [5:0]  lsu1_Rs_index_readpipe_in,
    input [1:0]  lsu1_bid_readpipe_in,
    input [1:0]  lsu1_Rt_alu_forwarding_readpipe_in,
    input [1:0]  lsu1_Rs_alu_forwarding_readpipe_in,
    input [1:0]  lsu1_Rt_lsu_forwarding_readpipe_in,
    input [1:0]  lsu1_Rs_lsu_forwarding_readpipe_in,
    input        lsu1_Rt_needforwarding_readpipe_in,
    input        lsu1_Rs_needforwarding_readpipe_in,
    input [15:0] lsu1_imm_readpipe_in,
	 input stall_LS,
    // Outputs (reg)
    output reg [4:0]  alu0_ROBentry_readpipe_out,
    output reg [5:0]  alu0_dest_readpipe_out,
    output reg [3:0]  alu0_operation_readpipe_out,
    output reg [5:0]  alu0_s1_index_readpipe_out,
    output reg [1:0]  alu0_bid_readpipe_out,
    output reg        alu0_is_Itype_readpipe_out,
    output reg [1:0]  alu0_s1_alu_forwarding_readpipe_out,
    output reg [1:0]  alu0_s2_alu_forwarding_readpipe_out,
    output reg [1:0]  alu0_s1_lsu_forwarding_readpipe_out,
    output reg [1:0]  alu0_s2_lsu_forwarding_readpipe_out,
    output reg        alu0_s1_needforwarding_readpipe_out,
    output reg        alu0_s2_needforwarding_readpipe_out,
    output reg [15:0] alu0_imm16b_readpipe_out,

    output reg [4:0]  alu1_ROBentry_readpipe_out,
    output reg [5:0]  alu1_dest_readpipe_out,
    output reg [3:0]  alu1_operation_readpipe_out,
    output reg [5:0]  alu1_s1_index_readpipe_out,
    output reg [1:0]  alu1_bid_readpipe_out,
    output reg        alu1_is_Itype_readpipe_out,
    output reg [1:0]  alu1_s1_alu_forwarding_readpipe_out,
    output reg [1:0]  alu1_s2_alu_forwarding_readpipe_out,
    output reg [1:0]  alu1_s1_lsu_forwarding_readpipe_out,
    output reg [1:0]  alu1_s2_lsu_forwarding_readpipe_out,
    output reg        alu1_s1_needforwarding_readpipe_out,
    output reg        alu1_s2_needforwarding_readpipe_out,
    output reg [15:0] alu1_imm16b_readpipe_out,

    output reg [4:0]  alu2_ROBentry_readpipe_out,
    output reg [5:0]  alu2_dest_readpipe_out,
    output reg [3:0]  alu2_operation_readpipe_out,
    output reg [5:0]  alu2_s1_index_readpipe_out,
    output reg [1:0]  alu2_bid_readpipe_out,
    output reg        alu2_is_Itype_readpipe_out,
    output reg [1:0]  alu2_s1_alu_forwarding_readpipe_out,
    output reg [1:0]  alu2_s2_alu_forwarding_readpipe_out,
    output reg [1:0]  alu2_s1_lsu_forwarding_readpipe_out,
    output reg [1:0]  alu2_s2_lsu_forwarding_readpipe_out,
    output reg        alu2_s1_needforwarding_readpipe_out,
    output reg        alu2_s2_needforwarding_readpipe_out,
    output reg [15:0] alu2_imm16b_readpipe_out,

    

    output reg [4:0]  bu_ROBentry_readpipe_out,
    output reg [2:0]  bu_operation_readpipe_out,
    output reg [9:0]  bu_imm_readpipe_out,
    output reg [1:0]  bu_BID_readpipe_out,
    output reg        bu_prediction_readpipe_out,
    output reg [5:0]  bu_s1_index_readpipe_out, bu_s2_index_readpipe_out,
    output reg        bu_is_branch_readpipe_out, bu_is_Jr_readpipe_out,
    output reg [1:0]  bu_s1_alu_forwarding_readpipe_out, bu_s2_alu_forwarding_readpipe_out,
    output reg [1:0]  bu_s1_lsu_forwarding_readpipe_out, bu_s2_lsu_forwarding_readpipe_out,
    output reg        bu_s1_needforwarding_readpipe_out, bu_s2_needforwarding_readpipe_out,

    output reg [4:0]  lsu0_ROBentry_readpipe_out,
    
    output reg [1:0]  lsu0_operation_readpipe_out,
    output reg [5:0]  lsu0_Rt_index_readpipe_out,
    output reg [5:0]  lsu0_Rs_index_readpipe_out,
    output reg [1:0]  lsu0_bid_readpipe_out,
    output reg [1:0]  lsu0_Rt_alu_forwarding_readpipe_out,
    output reg [1:0]  lsu0_Rs_alu_forwarding_readpipe_out,
    output reg [1:0]  lsu0_Rt_lsu_forwarding_readpipe_out,
    output reg [1:0]  lsu0_Rs_lsu_forwarding_readpipe_out,
    output reg        lsu0_Rt_needforwarding_readpipe_out,
    output reg        lsu0_Rs_needforwarding_readpipe_out,
    output reg [15:0] lsu0_imm_readpipe_out,

    output reg [4:0]  lsu1_ROBentry_readpipe_out,
    
    output reg [1:0]  lsu1_operation_readpipe_out,
    output reg [5:0]  lsu1_Rt_index_readpipe_out,
    output reg [5:0]  lsu1_Rs_index_readpipe_out,
    output reg [1:0]  lsu1_bid_readpipe_out,
    output reg [1:0]  lsu1_Rt_alu_forwarding_readpipe_out,
    output reg [1:0]  lsu1_Rs_alu_forwarding_readpipe_out,
    output reg [1:0]  lsu1_Rt_lsu_forwarding_readpipe_out,
    output reg [1:0]  lsu1_Rs_lsu_forwarding_readpipe_out,
    output reg        lsu1_Rt_needforwarding_readpipe_out,
    output reg        lsu1_Rs_needforwarding_readpipe_out,
    output reg [15:0] lsu1_imm_readpipe_out
);


// ALU0 always block

always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu0_ROBentry_readpipe_out <= 5'b0;
        alu0_dest_readpipe_out <= 6'b0;
        alu0_operation_readpipe_out <= 4'b0;
        alu0_s1_index_readpipe_out <= 6'b0;
        alu0_bid_readpipe_out <= 2'b0;
        alu0_is_Itype_readpipe_out <= 1'b0;
        alu0_s1_alu_forwarding_readpipe_out <= 2'b0;
        alu0_s2_alu_forwarding_readpipe_out <= 2'b0;
        alu0_s1_lsu_forwarding_readpipe_out <= 2'b0;
        alu0_s2_lsu_forwarding_readpipe_out <= 2'b0;
        alu0_s1_needforwarding_readpipe_out <= 1'b0;
        alu0_s2_needforwarding_readpipe_out <= 1'b0;
        alu0_imm16b_readpipe_out <= 16'b0;
    end else begin
        alu0_ROBentry_readpipe_out <= alu0_ROBentry_readpipe_in;
        alu0_dest_readpipe_out <= alu0_dest_readpipe_in;
        alu0_operation_readpipe_out <= alu0_operation_readpipe_in;
        alu0_s1_index_readpipe_out <= alu0_s1_index_readpipe_in;
        alu0_bid_readpipe_out <= alu0_bid_readpipe_in;
        alu0_is_Itype_readpipe_out <= alu0_is_Itype_readpipe_in;
        alu0_s1_alu_forwarding_readpipe_out <= alu0_s1_alu_forwarding_readpipe_in;
        alu0_s2_alu_forwarding_readpipe_out <= alu0_s2_alu_forwarding_readpipe_in;
        alu0_s1_lsu_forwarding_readpipe_out <= alu0_s1_lsu_forwarding_readpipe_in;
        alu0_s2_lsu_forwarding_readpipe_out <= alu0_s2_lsu_forwarding_readpipe_in;
        alu0_s1_needforwarding_readpipe_out <= alu0_s1_needforwarding_readpipe_in;
        alu0_s2_needforwarding_readpipe_out <= alu0_s2_needforwarding_readpipe_in;
        alu0_imm16b_readpipe_out <= alu0_imm16b_readpipe_in;
    end
end

// ALU1 always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu1_ROBentry_readpipe_out <= 5'b0;
        alu1_dest_readpipe_out <= 6'b0;
        alu1_operation_readpipe_out <= 4'b0;
        alu1_s1_index_readpipe_out <= 6'b0;
        alu1_bid_readpipe_out <= 2'b0;
        alu1_is_Itype_readpipe_out <= 1'b0;
        alu1_s1_alu_forwarding_readpipe_out <= 2'b0;
        alu1_s2_alu_forwarding_readpipe_out <= 2'b0;
        alu1_s1_lsu_forwarding_readpipe_out <= 2'b0;
        alu1_s2_lsu_forwarding_readpipe_out <= 2'b0;
        alu1_s1_needforwarding_readpipe_out <= 1'b0;
        alu1_s2_needforwarding_readpipe_out <= 1'b0;
        alu1_imm16b_readpipe_out <= 16'b0;
    end else begin
        alu1_ROBentry_readpipe_out <= alu1_ROBentry_readpipe_in;
        alu1_dest_readpipe_out <= alu1_dest_readpipe_in;
        alu1_operation_readpipe_out <= alu1_operation_readpipe_in;
        alu1_s1_index_readpipe_out <= alu1_s1_index_readpipe_in;
        alu1_bid_readpipe_out <= alu1_bid_readpipe_in;
        alu1_is_Itype_readpipe_out <= alu1_is_Itype_readpipe_in;
        alu1_s1_alu_forwarding_readpipe_out <= alu1_s1_alu_forwarding_readpipe_in;
        alu1_s2_alu_forwarding_readpipe_out <= alu1_s2_alu_forwarding_readpipe_in;
        alu1_s1_lsu_forwarding_readpipe_out <= alu1_s1_lsu_forwarding_readpipe_in;
        alu1_s2_lsu_forwarding_readpipe_out <= alu1_s2_lsu_forwarding_readpipe_in;
        alu1_s1_needforwarding_readpipe_out <= alu1_s1_needforwarding_readpipe_in;
        alu1_s2_needforwarding_readpipe_out <= alu1_s2_needforwarding_readpipe_in;
        alu1_imm16b_readpipe_out <= alu1_imm16b_readpipe_in;
    end
end

// ALU2 always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu2_ROBentry_readpipe_out <= 5'b0;
        alu2_dest_readpipe_out <= 6'b0;
        alu2_operation_readpipe_out <= 4'b0;
        alu2_s1_index_readpipe_out <= 6'b0;
        alu2_bid_readpipe_out <= 2'b0;
        alu2_is_Itype_readpipe_out <= 1'b0;
        alu2_s1_alu_forwarding_readpipe_out <= 2'b0;
        alu2_s2_alu_forwarding_readpipe_out <= 2'b0;
        alu2_s1_lsu_forwarding_readpipe_out <= 2'b0;
        alu2_s2_lsu_forwarding_readpipe_out <= 2'b0;
        alu2_s1_needforwarding_readpipe_out <= 1'b0;
        alu2_s2_needforwarding_readpipe_out <= 1'b0;
        alu2_imm16b_readpipe_out <= 16'b0;
    end else begin
        alu2_ROBentry_readpipe_out <= alu2_ROBentry_readpipe_in;
        alu2_dest_readpipe_out <= alu2_dest_readpipe_in;
        alu2_operation_readpipe_out <= alu2_operation_readpipe_in;
        alu2_s1_index_readpipe_out <= alu2_s1_index_readpipe_in;
        alu2_bid_readpipe_out <= alu2_bid_readpipe_in;
        alu2_is_Itype_readpipe_out <= alu2_is_Itype_readpipe_in;
        alu2_s1_alu_forwarding_readpipe_out <= alu2_s1_alu_forwarding_readpipe_in;
        alu2_s2_alu_forwarding_readpipe_out <= alu2_s2_alu_forwarding_readpipe_in;
        alu2_s1_lsu_forwarding_readpipe_out <= alu2_s1_lsu_forwarding_readpipe_in;
        alu2_s2_lsu_forwarding_readpipe_out <= alu2_s2_lsu_forwarding_readpipe_in;
        alu2_s1_needforwarding_readpipe_out <= alu2_s1_needforwarding_readpipe_in;
        alu2_s2_needforwarding_readpipe_out <= alu2_s2_needforwarding_readpipe_in;
        alu2_imm16b_readpipe_out <= alu2_imm16b_readpipe_in;
    end
end



// BU always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bu_ROBentry_readpipe_out <= 5'b0;
        bu_operation_readpipe_out <= 3'b0;
        bu_imm_readpipe_out <= 10'b0;
        bu_BID_readpipe_out <= 2'b0;
        bu_prediction_readpipe_out <= 1'b0;
        bu_s1_index_readpipe_out <= 6'b0;
        bu_s2_index_readpipe_out <= 6'b0;
        bu_is_branch_readpipe_out <= 1'b0;
        bu_is_Jr_readpipe_out <= 1'b0;
        bu_s1_alu_forwarding_readpipe_out <= 2'b0;
        bu_s2_alu_forwarding_readpipe_out <= 2'b0;
        bu_s1_lsu_forwarding_readpipe_out <= 2'b0;
        bu_s2_lsu_forwarding_readpipe_out <= 2'b0;
        bu_s1_needforwarding_readpipe_out <= 1'b0;
        bu_s2_needforwarding_readpipe_out <= 1'b0;
    end else begin
        bu_ROBentry_readpipe_out <= bu_ROBentry_readpipe_in;
        bu_operation_readpipe_out <= bu_operation_readpipe_in;
        bu_imm_readpipe_out <= bu_imm_readpipe_in;
        bu_BID_readpipe_out <= bu_BID_readpipe_in;
        bu_prediction_readpipe_out <= bu_prediction_readpipe_in;
        bu_s1_index_readpipe_out <= bu_s1_index_readpipe_in;
        bu_s2_index_readpipe_out <= bu_s2_index_readpipe_in;
        bu_is_branch_readpipe_out <= bu_is_branch_readpipe_in;
        bu_is_Jr_readpipe_out <= bu_is_Jr_readpipe_in;
        bu_s1_alu_forwarding_readpipe_out <= bu_s1_alu_forwarding_readpipe_in;
        bu_s2_alu_forwarding_readpipe_out <= bu_s2_alu_forwarding_readpipe_in;
        bu_s1_lsu_forwarding_readpipe_out <= bu_s1_lsu_forwarding_readpipe_in;
        bu_s2_lsu_forwarding_readpipe_out <= bu_s2_lsu_forwarding_readpipe_in;
        bu_s1_needforwarding_readpipe_out <= bu_s1_needforwarding_readpipe_in;
        bu_s2_needforwarding_readpipe_out <= bu_s2_needforwarding_readpipe_in;
    end
end

// LSU0 always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lsu0_ROBentry_readpipe_out <= 5'b0;
        
        lsu0_operation_readpipe_out <= 2'b0;
        lsu0_Rt_index_readpipe_out <= 6'b0;
        lsu0_Rs_index_readpipe_out <= 6'b0;
        lsu0_bid_readpipe_out <= 2'b0;
        lsu0_Rt_alu_forwarding_readpipe_out <= 2'b0;
        lsu0_Rs_alu_forwarding_readpipe_out <= 2'b0;
        lsu0_Rt_lsu_forwarding_readpipe_out <= 2'b0;
        lsu0_Rs_lsu_forwarding_readpipe_out <= 2'b0;
        lsu0_Rt_needforwarding_readpipe_out <= 1'b0;
        lsu0_Rs_needforwarding_readpipe_out <= 1'b0;
        lsu0_imm_readpipe_out <= 16'b0;
    end 
	 else if(stall_LS)begin
		lsu0_ROBentry_readpipe_out <= lsu0_ROBentry_readpipe_out;
        
        lsu0_operation_readpipe_out <= lsu0_operation_readpipe_out;
        lsu0_Rt_index_readpipe_out <= lsu0_Rt_index_readpipe_out;
        lsu0_Rs_index_readpipe_out <= lsu0_Rs_index_readpipe_out;
		  
        lsu0_bid_readpipe_out <= lsu0_bid_readpipe_out;
		  
        lsu0_Rt_alu_forwarding_readpipe_out <= lsu0_Rt_alu_forwarding_readpipe_out;
        lsu0_Rs_alu_forwarding_readpipe_out <= lsu0_Rs_alu_forwarding_readpipe_out;
        lsu0_Rt_lsu_forwarding_readpipe_out <= lsu0_Rt_lsu_forwarding_readpipe_out;
		  
        lsu0_Rs_lsu_forwarding_readpipe_out <= lsu0_Rs_lsu_forwarding_readpipe_out;
        lsu0_Rt_needforwarding_readpipe_out <= lsu0_Rt_needforwarding_readpipe_out;
        lsu0_Rs_needforwarding_readpipe_out <= lsu0_Rs_needforwarding_readpipe_out;
        lsu0_imm_readpipe_out <= lsu0_imm_readpipe_out;
	 
	 
	 end
	 else begin
        lsu0_ROBentry_readpipe_out <= lsu0_ROBentry_readpipe_in;
        
        lsu0_operation_readpipe_out <= lsu0_operation_readpipe_in;
        lsu0_Rt_index_readpipe_out <= lsu0_Rt_index_readpipe_in;
        lsu0_Rs_index_readpipe_out <= lsu0_Rs_index_readpipe_in;
        lsu0_bid_readpipe_out <= lsu0_bid_readpipe_in;
        lsu0_Rt_alu_forwarding_readpipe_out <= lsu0_Rt_alu_forwarding_readpipe_in;
        lsu0_Rs_alu_forwarding_readpipe_out <= lsu0_Rs_alu_forwarding_readpipe_in;
        lsu0_Rt_lsu_forwarding_readpipe_out <= lsu0_Rt_lsu_forwarding_readpipe_in;
        lsu0_Rs_lsu_forwarding_readpipe_out <= lsu0_Rs_lsu_forwarding_readpipe_in;
        lsu0_Rt_needforwarding_readpipe_out <= lsu0_Rt_needforwarding_readpipe_in;
        lsu0_Rs_needforwarding_readpipe_out <= lsu0_Rs_needforwarding_readpipe_in;
        lsu0_imm_readpipe_out <= lsu0_imm_readpipe_in;
    end
end

// LSU1 always block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lsu1_ROBentry_readpipe_out <= 5'b0;
        
        lsu1_operation_readpipe_out <= 2'b0;
        lsu1_Rt_index_readpipe_out <= 6'b0;
        lsu1_Rs_index_readpipe_out <= 6'b0;
        lsu1_bid_readpipe_out <= 2'b0;
        lsu1_Rt_alu_forwarding_readpipe_out <= 2'b0;
        lsu1_Rs_alu_forwarding_readpipe_out <= 2'b0;
        lsu1_Rt_lsu_forwarding_readpipe_out <= 2'b0;
        lsu1_Rs_lsu_forwarding_readpipe_out <= 2'b0;
        lsu1_Rt_needforwarding_readpipe_out <= 1'b0;
        lsu1_Rs_needforwarding_readpipe_out <= 1'b0;
        lsu1_imm_readpipe_out <= 16'b0;
    end 
	 else if(stall_LS)begin
		lsu1_ROBentry_readpipe_out <= lsu1_ROBentry_readpipe_out;
        
        lsu1_operation_readpipe_out <= lsu1_operation_readpipe_out;
        lsu1_Rt_index_readpipe_out <= lsu1_Rt_index_readpipe_out;
        lsu1_Rs_index_readpipe_out <= lsu1_Rs_index_readpipe_out;
        lsu1_bid_readpipe_out <= lsu1_bid_readpipe_out;
        lsu1_Rt_alu_forwarding_readpipe_out <= lsu1_Rt_alu_forwarding_readpipe_out;
        lsu1_Rs_alu_forwarding_readpipe_out <= lsu1_Rs_alu_forwarding_readpipe_out;
        lsu1_Rt_lsu_forwarding_readpipe_out <= lsu1_Rt_lsu_forwarding_readpipe_out;
        lsu1_Rs_lsu_forwarding_readpipe_out <= lsu1_Rs_lsu_forwarding_readpipe_out;
        lsu1_Rt_needforwarding_readpipe_out <= lsu1_Rt_needforwarding_readpipe_out;
        lsu1_Rs_needforwarding_readpipe_out <= lsu1_Rs_needforwarding_readpipe_out;
        lsu1_imm_readpipe_out <= lsu1_imm_readpipe_out;
	 end
	 else begin
        lsu1_ROBentry_readpipe_out <= lsu1_ROBentry_readpipe_in;
        
        lsu1_operation_readpipe_out <= lsu1_operation_readpipe_in;
        lsu1_Rt_index_readpipe_out <= lsu1_Rt_index_readpipe_in;
        lsu1_Rs_index_readpipe_out <= lsu1_Rs_index_readpipe_in;
        lsu1_bid_readpipe_out <= lsu1_bid_readpipe_in;
        lsu1_Rt_alu_forwarding_readpipe_out <= lsu1_Rt_alu_forwarding_readpipe_in;
        lsu1_Rs_alu_forwarding_readpipe_out <= lsu1_Rs_alu_forwarding_readpipe_in;
        lsu1_Rt_lsu_forwarding_readpipe_out <= lsu1_Rt_lsu_forwarding_readpipe_in;
        lsu1_Rs_lsu_forwarding_readpipe_out <= lsu1_Rs_lsu_forwarding_readpipe_in;
        lsu1_Rt_needforwarding_readpipe_out <= lsu1_Rt_needforwarding_readpipe_in;
        lsu1_Rs_needforwarding_readpipe_out <= lsu1_Rs_needforwarding_readpipe_in;
        lsu1_imm_readpipe_out <= lsu1_imm_readpipe_in;
    end
end

endmodule



