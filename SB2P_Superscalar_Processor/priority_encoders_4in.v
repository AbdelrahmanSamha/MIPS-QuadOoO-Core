module priority_encoders_4in(
    input [3:0] in,                   // 4-bit input
    output reg [1:0] pos0, pos1, pos2, pos3, // Positions of the 1s
    output reg in_zero_enc4_0, in_zero_enc4_1, in_zero_enc4_2, in_zero_enc4_3 // Write enable signals
);

    reg valid0, valid1, valid2, valid3; // Valid signals for each read
    reg [3:0] masked_in;                // Masked input

    always @(*) begin
        // Initialize outputs to default
        pos0 = 2'b00; pos1 = 2'b00; pos2 = 2'b00; pos3 = 2'b00;
        in_zero_enc4_0 = 1'b0; in_zero_enc4_1 = 1'b0; in_zero_enc4_2 = 1'b0; in_zero_enc4_3 = 1'b0;
        valid0 = 1'b0; valid1 = 1'b0; valid2 = 1'b0; valid3 = 1'b0;
        masked_in = in;

        // First priority encoder (LSB first)
        if (masked_in[0]) begin pos0 = 2'b00; valid0 = 1; end
        else if (masked_in[1]) begin pos0 = 2'b01; valid0 = 1; end
        else if (masked_in[2]) begin pos0 = 2'b10; valid0 = 1; end
        else if (masked_in[3]) begin pos0 = 2'b11; valid0 = 1; end
        in_zero_enc4_0 = ~valid0;

        // Mask the first '1' if found
        if (valid0) masked_in[pos0] = 1'b0;

        // Second priority encoder
        if (masked_in[0]) begin pos1 = 2'b00; valid1 = 1; end
        else if (masked_in[1]) begin pos1 = 2'b01; valid1 = 1; end
        else if (masked_in[2]) begin pos1 = 2'b10; valid1 = 1; end
        else if (masked_in[3]) begin pos1 = 2'b11; valid1 = 1; end
        in_zero_enc4_1 = ~valid1;

        // Mask the second '1' if found
        if (valid1) masked_in[pos1] = 1'b0;

        // Third priority encoder
        if (masked_in[0]) begin pos2 = 2'b00; valid2 = 1; end
        else if (masked_in[1]) begin pos2 = 2'b01; valid2 = 1; end
        else if (masked_in[2]) begin pos2 = 2'b10; valid2 = 1; end
        else if (masked_in[3]) begin pos2 = 2'b11; valid2 = 1; end
        in_zero_enc4_2 = ~valid2;

        // Mask the third '1' if found
        if (valid2) masked_in[pos2] = 1'b0;

        // Fourth priority encoder
        if (masked_in[0]) begin pos3 = 2'b00; valid3 = 1; end
        else if (masked_in[1]) begin pos3 = 2'b01; valid3 = 1; end
        else if (masked_in[2]) begin pos3 = 2'b10; valid3 = 1; end
        else if (masked_in[3]) begin pos3 = 2'b11; valid3 = 1; end
        in_zero_enc4_3 = ~valid3;
    end

endmodule
