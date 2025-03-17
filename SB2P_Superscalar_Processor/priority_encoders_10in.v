module priority_encoders_10in(
    input [9:0] in,                   // 10-bit input
    output reg [3:0] pos0, pos1, pos2, pos3, // Positions of the 1s
    output reg in_zero_enc10_0, in_zero_enc10_1, in_zero_enc10_2, in_zero_enc10_3 // Write enable signals
);

    reg valid0, valid1, valid2, valid3; // Valid signals for each read
    reg [9:0] masked_in;                // Masked input

    always @(*) begin
        // Initialize outputs to default
        pos0 = 4'b0000; pos1 = 4'b0000; pos2 = 4'b0000; pos3 = 4'b0000;
        in_zero_enc10_0 = 1'b0; in_zero_enc10_1 = 1'b0; in_zero_enc10_2 = 1'b0; in_zero_enc10_3 = 1'b0;
        valid0 = 1'b0; valid1 = 1'b0; valid2 = 1'b0; valid3 = 1'b0;
      
		  masked_in = in;

        // First priority encoder (LSB first)
        if (masked_in[0]) begin pos0 = 4'b0000; valid0 = 1; end
        else if (masked_in[1]) begin pos0 = 4'b0001; valid0 = 1; end
        else if (masked_in[2]) begin pos0 = 4'b0010; valid0 = 1; end
        else if (masked_in[3]) begin pos0 = 4'b0011; valid0 = 1; end
        else if (masked_in[4]) begin pos0 = 4'b0100; valid0 = 1; end
        else if (masked_in[5]) begin pos0 = 4'b0101; valid0 = 1; end
        else if (masked_in[6]) begin pos0 = 4'b0110; valid0 = 1; end
        else if (masked_in[7]) begin pos0 = 4'b0111; valid0 = 1; end
        else if (masked_in[8]) begin pos0 = 4'b1000; valid0 = 1; end
        else if (masked_in[9]) begin pos0 = 4'b1001; valid0 = 1; end
        in_zero_enc10_0 = ~valid0;

        // Mask the first '1' if found
        if (valid0) masked_in[pos0] = 1'b0;

        // Second priority encoder
        if (masked_in[0]) begin pos1 = 4'b0000; valid1 = 1; end
        else if (masked_in[1]) begin pos1 = 4'b0001; valid1 = 1; end
        else if (masked_in[2]) begin pos1 = 4'b0010; valid1 = 1; end
        else if (masked_in[3]) begin pos1 = 4'b0011; valid1 = 1; end
        else if (masked_in[4]) begin pos1 = 4'b0100; valid1 = 1; end
        else if (masked_in[5]) begin pos1 = 4'b0101; valid1 = 1; end
        else if (masked_in[6]) begin pos1 = 4'b0110; valid1 = 1; end
        else if (masked_in[7]) begin pos1 = 4'b0111; valid1 = 1; end
        else if (masked_in[8]) begin pos1 = 4'b1000; valid1 = 1; end
        else if (masked_in[9]) begin pos1 = 4'b1001; valid1 = 1; end
        in_zero_enc10_1 = ~valid1;

        // Mask the second '1' if found
        if (valid1) masked_in[pos1] = 1'b0;

        // Third priority encoder
        if (masked_in[0]) begin pos2 = 4'b0000; valid2 = 1; end
        else if (masked_in[1]) begin pos2 = 4'b0001; valid2 = 1; end
        else if (masked_in[2]) begin pos2 = 4'b0010; valid2 = 1; end
        else if (masked_in[3]) begin pos2 = 4'b0011; valid2 = 1; end
        else if (masked_in[4]) begin pos2 = 4'b0100; valid2 = 1; end
        else if (masked_in[5]) begin pos2 = 4'b0101; valid2 = 1; end
        else if (masked_in[6]) begin pos2 = 4'b0110; valid2 = 1; end
        else if (masked_in[7]) begin pos2 = 4'b0111; valid2 = 1; end
        else if (masked_in[8]) begin pos2 = 4'b1000; valid2 = 1; end
        else if (masked_in[9]) begin pos2 = 4'b1001; valid2 = 1; end
        in_zero_enc10_2 = ~valid2;

        // Mask the third '1' if found
        if (valid2) masked_in[pos2] = 1'b0;

        // Fourth priority encoder
        if (masked_in[0]) begin pos3 = 4'b0000; valid3 = 1; end
        else if (masked_in[1]) begin pos3 = 4'b0001; valid3 = 1; end
        else if (masked_in[2]) begin pos3 = 4'b0010; valid3 = 1; end
        else if (masked_in[3]) begin pos3 = 4'b0011; valid3 = 1; end
        else if (masked_in[4]) begin pos3 = 4'b0100; valid3 = 1; end
        else if (masked_in[5]) begin pos3 = 4'b0101; valid3 = 1; end
        else if (masked_in[6]) begin pos3 = 4'b0110; valid3 = 1; end
        else if (masked_in[7]) begin pos3 = 4'b0111; valid3 = 1; end
        else if (masked_in[8]) begin pos3 = 4'b1000; valid3 = 1; end
        else if (masked_in[9]) begin pos3 = 4'b1001; valid3 = 1; end
        in_zero_enc10_3 = ~valid3;
    end

endmodule
