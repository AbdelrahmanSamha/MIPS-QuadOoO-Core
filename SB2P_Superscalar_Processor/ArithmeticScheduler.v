module ArithmeticScheduler(
    input  ready0, ready1, ready2, ready3, 
    input  ready4, ready5, ready6, ready7, 
    input  ready8, ready9,
    input  isbranch0, isbranch1, isbranch2, isbranch3,
    input  isbranch4, isbranch5, isbranch6, isbranch7,
    input  isbranch8, isbranch9,
	 input [9:0]current_status,
    output reg [3:0] sel_branch, sel0, sel1, sel2,
    output reg [9:0] ready
);

    reg [9:0] next_ready;
    wire [9:0] is_branch = {isbranch9, isbranch8, isbranch7, isbranch6,
                           isbranch5, isbranch4, isbranch3, isbranch2,
                           isbranch1, isbranch0};

    always @(*) begin
        // Initialize all selectors to invalid
        sel_branch = 4'b1111;
        sel0 = 4'b1111;
        sel1 = 4'b1111;
        sel2 = 4'b1111;
        

        // Combine ready signals (ready0 = LSB)
        next_ready = current_status;

        // --- Branch Selection (Highest Priority) ---
       if (ready0 && is_branch[0]) begin
            sel_branch = 4'd0;
            next_ready[0] = 1'b1;
        end
        else if (ready1 && is_branch[1]) begin
            sel_branch = 4'd1;
            next_ready[1] = 1'b1;
        end
        else if (ready2 && is_branch[2]) begin
            sel_branch = 4'd2;
            next_ready[2] = 1'b1;
        end
        else if (ready3 && is_branch[3]) begin
            sel_branch = 4'd3;
            next_ready[3] = 1'b1;
        end
        else if (ready4 && is_branch[4]) begin
            sel_branch = 4'd4;
            next_ready[4] = 1'b1;
        end
        else if (ready5 && is_branch[5]) begin
            sel_branch = 4'd5;
            next_ready[5] = 1'b1;
        end
        else if (ready6 && is_branch[6]) begin
            sel_branch = 4'd6;
            next_ready[6] = 1'b1;
        end
        else if (ready7 && is_branch[7]) begin
            sel_branch = 4'd7;
            next_ready[7] = 1'b1;
        end
        else if (ready8 && is_branch[8]) begin
            sel_branch = 4'd8;
            next_ready[8] = 1'b1;
        end
        else if (ready9 && is_branch[9]) begin
            sel_branch = 4'd9;
            next_ready[9] = 1'b1;
        end

        // --- Arithmetic Selection (Non-Branch Instructions) ---
        // Station 0 (highest priority)
        if (ready0 && !is_branch[0]) begin
            sel0 = 4'd0;
            next_ready[0] = 1'b1;
        end

        // Station 1
        if (ready1 && !is_branch[1]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd1;
                next_ready[1] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd1;
                next_ready[1] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd1;
                next_ready[1] = 1'b1;
            end 
        end

        // Station 2
        if (ready2 && !is_branch[2]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd2;
                next_ready[2] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd2;
                next_ready[2] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd2;
                next_ready[2] = 1'b1;
            end 
        end

        // Station 3
        if (ready3 && !is_branch[3]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd3;
                next_ready[3] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd3;
                next_ready[3] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd3;
                next_ready[3] = 1'b1;
            end 
        end

        // Station 4
        if (ready4 && !is_branch[4]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd4;
                next_ready[4] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd4;
                next_ready[4] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd4;
                next_ready[4] = 1'b1;
            end 
        end

        // Station 5
        if (ready5 && !is_branch[5]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd5;
                next_ready[5] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd5;
                next_ready[5] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd5;
                next_ready[5] = 1'b1;
            end 
        end

        // Station 6
        if (ready6 && !is_branch[6]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd6;
                next_ready[6] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd6;
                next_ready[6] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd6;
                next_ready[6] = 1'b1;
            end 
        end

        // Station 7
        if (ready7 && !is_branch[7]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd7;
                next_ready[7] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd7;
                next_ready[7] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd7;
                next_ready[7] = 1'b1;
            end 
        end

        // Station 8
        if (ready8 && !is_branch[8]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd8;
                next_ready[8] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd8;
                next_ready[8] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd8;
                next_ready[8] = 1'b1;
            end 
        end

        // Station 9 (lowest priority)
        if (ready9 && !is_branch[9]) begin
            if (sel0 == 4'b1111) begin
                sel0 = 4'd9;
                next_ready[9] = 1'b1;
            end else if (sel1 == 4'b1111) begin
                sel1 = 4'd9;
                next_ready[9] = 1'b1;
            end else if (sel2 == 4'b1111) begin
                sel2 = 4'd9;
                next_ready[9] = 1'b1;
            end 
        end

        ready = next_ready;
    end

endmodule