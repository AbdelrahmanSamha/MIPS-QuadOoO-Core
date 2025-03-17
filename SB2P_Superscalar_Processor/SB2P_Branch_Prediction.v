module SB2P_Branch_Prediction (
    input clk,
    input reset,
    input branch,
    input taken,             // Actual outcomes
    input signed [9:0] Branch_offset0,        // Branch operation codes for each instruction
    input signed [9:0] Branch_offset1,
    input signed [9:0] Branch_offset2,
    input signed [9:0] Branch_offset3,
	 
	 input [5:0] Branch_op0,
	 input [5:0] Branch_op1,
	 input [5:0] Branch_op2,
	 input [5:0] Branch_op3,
	 input signed [7:0]pc,
    output reg [3:0] prediction    // Predictions for 4 branches
);

    reg [1:0] state; // 2-bit saturating counters
    reg direction0, direction1, direction2, direction3;

    // Determine if the branch is backward (1) or forward (0)
    //assign direction0 = (Branch_offset0 < pc)  ? 1'b1 : 1'b0;
    //assign direction1 = (Branch_offset1 < pc) ? 1'b1 : 1'b0;
    //assign direction2 = (Branch_offset2 < pc) ? 1'b1 : 1'b0;
    //assign direction3 = (Branch_offset3 < pc) ? 1'b1 : 1'b0;

	
	
	
	wire [9:0]branch_target0,branch_target1,branch_target2,branch_target3;
	assign branch_target0 = Branch_offset0 + {pc,2'b00} + 10'b1;
	assign branch_target1 = Branch_offset1 + {pc,2'b01} + 10'b1;
	assign branch_target2 = Branch_offset2 + {pc,2'b10} + 10'b1;
	assign branch_target3 = Branch_offset3 + {pc,2'b11} + 10'b1;
	
	 wire  states0,states1,states2,states3;
	 assign states0 = branch_target0 < ({pc,2'b00});
	 assign states1 = branch_target1 < ({pc,2'b01});
	 assign states2 = branch_target2 < ({pc,2'b10});
	 assign states3 = branch_target3 < ({pc,2'b11});
	 
	 always @(*)begin 
		direction0 = 1'b0;
		direction1 = 1'b0;
		direction2 = 1'b0;
		direction3 = 1'b0;
		if((Branch_op0 == 6'h05) | (Branch_op0 == 6'h04))begin
			if(states0)begin
				direction0 = 1'b1;
			end
		end
		if((Branch_op1 == 6'h05) | (Branch_op1 == 6'h04))begin
			if(states1)begin
				direction1 = 1'b1;
			end
		end
		if((Branch_op2 == 6'h05) | (Branch_op2 == 6'h04))begin
			if(states2)begin
				direction2 = 1'b1;
			end
		end
		if((Branch_op3 == 6'h05) | (Branch_op3 == 6'h04))begin
			if(states3)begin
				direction3 = 1'b1;
			end
		end
		
	 
	 end
	 
always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b10; // Start with a weakly taken state
        end 
        else if (branch) begin
            case (state)
                2'b00: state <= (taken) ? 2'b01 : 2'b00;
                2'b01: state <= (taken) ? 2'b10 : 2'b00;
                2'b10: state <= (taken) ? 2'b11 : 2'b01;
                2'b11: state <= (taken) ? 2'b11 : 2'b10;
            endcase
        end
    end

    always @(*) begin
        prediction[0] = (direction0) ? (state[1] == 1'b1) : (state[1] == 1'b0);
        prediction[1] = (direction1) ? (state[1] == 1'b1) : (state[1] == 1'b0);
        prediction[2] = (direction2) ? (state[1] == 1'b1) : (state[1] == 1'b0);
        prediction[3] = (direction3) ? (state[1] == 1'b1) : (state[1] == 1'b0);
    end

endmodule