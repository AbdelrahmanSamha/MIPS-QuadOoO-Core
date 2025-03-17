module FRPOOL(clk ,rst ,reg_out_0 ,reg_out_1,reg_out_2,reg_out_3);

	input wire clk;
    input wire rst;
    output reg [5:0] reg_out_0;
    output reg [5:0] reg_out_1;
    output reg [5:0] reg_out_2;
    output reg [5:0] reg_out_3;
	
    reg [5:0] reg_array [31:0]; // 32 registers, each 6 bits wide
    reg [4:0] start_index;      // To index the 32 registers

    initial begin
        reg_array[0]  = 6'b100000;
        reg_array[1]  = 6'b100001;
        reg_array[2]  = 6'b100010;
        reg_array[3]  = 6'b100011;
        reg_array[4]  = 6'b100100;
        reg_array[5]  = 6'b100101;
        reg_array[6]  = 6'b100110;
        reg_array[7]  = 6'b100111;
        reg_array[8]  = 6'b101000;
        reg_array[9]  = 6'b101001;
        reg_array[10] = 6'b101010;
        reg_array[11] = 6'b101011;
        reg_array[12] = 6'b101100;
        reg_array[13] = 6'b101101;
        reg_array[14] = 6'b101110;
        reg_array[15] = 6'b101111;
        reg_array[16] = 6'b110000;
        reg_array[17] = 6'b110001;
        reg_array[18] = 6'b110010;
        reg_array[19] = 6'b110011;
        reg_array[20] = 6'b110100;
        reg_array[21] = 6'b110101;
        reg_array[22] = 6'b110110;
        reg_array[23] = 6'b110111;
        reg_array[24] = 6'b111000;
        reg_array[25] = 6'b111001;
        reg_array[26] = 6'b111010;
        reg_array[27] = 6'b111011;
        reg_array[28] = 6'b111100;
        reg_array[29] = 6'b111101;
        reg_array[30] = 6'b111110;
        reg_array[31] = 6'b111111;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_index <= 5'd0; // Reset the starting index to 0
        end else begin
            if (start_index + 4 >= 32) begin
                start_index <= 5'd0; // Wrap around if index goes out of bounds
            end else begin
                start_index <= start_index + 5'b00100; // Increment by 4
            end
        end
    end

    always @(*) begin
        reg_out_0 = reg_array[start_index];
        reg_out_1 = reg_array[start_index + 1];
        reg_out_2 = reg_array[start_index + 2];
        reg_out_3 = reg_array[start_index + 3];
    end
endmodule
