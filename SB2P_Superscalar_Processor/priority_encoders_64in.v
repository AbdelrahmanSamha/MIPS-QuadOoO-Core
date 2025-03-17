module priority_encoders_64in(
	 input clk,
	 input reset,
	 
	 input [5:0] physical_way0,
	 input [5:0] physical_way1,
	 input [5:0] physical_way2,
	 input [5:0] physical_way3,
	 
	 input wire write_0,
	 input wire write_1,
	 input wire write_2,
	 input wire write_3,
	 
	 input [63:0]in_branch,
	 
	 input recovery_enable,
	 
	 input commit_enable,
	 
	 input stall,
    
	 output reg [5:0] pos0, pos1, pos2, pos3, 
    
	 output reg in_zero_enc64_0, in_zero_enc64_1, in_zero_enc64_2, in_zero_enc64_3,
	 
	 output reg [63:0] in
);


	
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in = 64'b1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000; 
        end
		  else if (stall) begin
				in = in;
		  end
		  else if (recovery_enable) begin // !hit
				in = in_branch;
				in[physical_way0] = 1'b0;
				in[physical_way1] = 1'b0;
				in[physical_way2] = 1'b0;
				in[physical_way3] = 1'b0;
		  end
		  else if(commit_enable)begin  // all_done
				in = in | in_branch;
			if (write_0) in[pos0] = 1'b0; 
		   if (write_1) in[pos1] = 1'b0; 
		   if (write_2) in[pos2] = 1'b0;
		   if (write_3) in[pos3] = 1'b0;
		  end
		  else  begin
			if (write_0) in[pos0] = 1'b0; 
		   if (write_1) in[pos1] = 1'b0; 
		   if (write_2) in[pos2] = 1'b0;
		   if (write_3) in[pos3] = 1'b0;
		  end
    end

    reg valid0, valid1, valid2, valid3; // Valid signals for each read
    reg [63:0] masked_in0, masked_in1, masked_in2,masked_in3;               // Masked input
 

    always @(*) begin
        // Initialize outputs to default
        pos0 = 6'b000000;
        pos1 = 6'b000000;
        pos2 = 6'b000000;
        pos3 = 6'b000000;
        in_zero_enc64_0 = 1'b0;
        in_zero_enc64_1 = 1'b0;
        in_zero_enc64_2 = 1'b0;
        in_zero_enc64_3 = 1'b0;
        valid0 = 1'b0;
        valid1 = 1'b0;
        valid2 = 1'b0;
        valid3 = 1'b0;

        masked_in0 = in;
		  masked_in1 = in & (in - 1);         // Clear lowest set bit
		  masked_in2 = masked_in1 & (masked_in1 - 1);   // Clear next lowest
		  masked_in3 = masked_in2 & (masked_in2 - 1);   // And so on...

        // First priority encoder (LSB first)
        if (masked_in0[0]) begin pos0 = 6'd0; valid0 = 1'b1; end
        else if (masked_in0[1]) begin pos0 = 6'd1; valid0 = 1'b1; end
        else if (masked_in0[2]) begin pos0 = 6'd2; valid0 = 1'b1; end
        else if (masked_in0[3]) begin pos0 = 6'd3; valid0 = 1'b1; end
        else if (masked_in0[4]) begin pos0 = 6'd4; valid0 = 1'b1; end
        else if (masked_in0[5]) begin pos0 = 6'd5; valid0 = 1'b1; end
        else if (masked_in0[6]) begin pos0 = 6'd6; valid0 = 1'b1; end
        else if (masked_in0[7]) begin pos0 = 6'd7; valid0 = 1'b1; end
        else if (masked_in0[8]) begin pos0 = 6'd8; valid0 = 1'b1; end
        else if (masked_in0[9]) begin pos0 = 6'd9; valid0 = 1'b1; end
        else if (masked_in0[10]) begin pos0 = 6'd10; valid0 = 1'b1; end
        else if (masked_in0[11]) begin pos0 = 6'd11; valid0 = 1'b1; end
        else if (masked_in0[12]) begin pos0 = 6'd12; valid0 = 1'b1; end
        else if (masked_in0[13]) begin pos0 = 6'd13; valid0 = 1'b1; end
        else if (masked_in0[14]) begin pos0 = 6'd14; valid0 = 1'b1; end
        else if (masked_in0[15]) begin pos0 = 6'd15; valid0 = 1'b1; end
        else if (masked_in0[16]) begin pos0 = 6'd16; valid0 = 1'b1; end
        else if (masked_in0[17]) begin pos0 = 6'd17; valid0 = 1'b1; end
        else if (masked_in0[18]) begin pos0 = 6'd18; valid0 = 1'b1; end
        else if (masked_in0[19]) begin pos0 = 6'd19; valid0 = 1'b1; end
        else if (masked_in0[20]) begin pos0 = 6'd20; valid0 = 1'b1; end
        else if (masked_in0[21]) begin pos0 = 6'd21; valid0 = 1'b1; end
        else if (masked_in0[22]) begin pos0 = 6'd22; valid0 = 1'b1; end
        else if (masked_in0[23]) begin pos0 = 6'd23; valid0 = 1'b1; end
        else if (masked_in0[24]) begin pos0 = 6'd24; valid0 = 1'b1; end
        else if (masked_in0[25]) begin pos0 = 6'd25; valid0 = 1'b1; end
        else if (masked_in0[26]) begin pos0 = 6'd26; valid0 = 1'b1; end
        else if (masked_in0[27]) begin pos0 = 6'd27; valid0 = 1'b1; end
        else if (masked_in0[28]) begin pos0 = 6'd28; valid0 = 1'b1; end
        else if (masked_in0[29]) begin pos0 = 6'd29; valid0 = 1'b1; end
        else if (masked_in0[30]) begin pos0 = 6'd30; valid0 = 1'b1; end
        else if (masked_in0[31]) begin pos0 = 6'd31; valid0 = 1'b1; end
        else if (masked_in0[32]) begin pos0 = 6'd32; valid0 = 1'b1; end
        else if (masked_in0[33]) begin pos0 = 6'd33; valid0 = 1'b1; end
        else if (masked_in0[34]) begin pos0 = 6'd34; valid0 = 1'b1; end
        else if (masked_in0[35]) begin pos0 = 6'd35; valid0 = 1'b1; end
        else if (masked_in0[36]) begin pos0 = 6'd36; valid0 = 1'b1; end
        else if (masked_in0[37]) begin pos0 = 6'd37; valid0 = 1'b1; end
        else if (masked_in0[38]) begin pos0 = 6'd38; valid0 = 1'b1; end
        else if (masked_in0[39]) begin pos0 = 6'd39; valid0 = 1'b1; end
        else if (masked_in0[40]) begin pos0 = 6'd40; valid0 = 1'b1; end
        else if (masked_in0[41]) begin pos0 = 6'd41; valid0 = 1'b1; end
        else if (masked_in0[42]) begin pos0 = 6'd42; valid0 = 1'b1; end
        else if (masked_in0[43]) begin pos0 = 6'd43; valid0 = 1'b1; end
        else if (masked_in0[44]) begin pos0 = 6'd44; valid0 = 1'b1; end
        else if (masked_in0[45]) begin pos0 = 6'd45; valid0 = 1'b1; end
        else if (masked_in0[46]) begin pos0 = 6'd46; valid0 = 1'b1; end
        else if (masked_in0[47]) begin pos0 = 6'd47; valid0 = 1'b1; end
        else if (masked_in0[48]) begin pos0 = 6'd48; valid0 = 1'b1; end
        else if (masked_in0[49]) begin pos0 = 6'd49; valid0 = 1'b1; end
        else if (masked_in0[50]) begin pos0 = 6'd50; valid0 = 1'b1; end
        else if (masked_in0[51]) begin pos0 = 6'd51; valid0 = 1'b1; end
        else if (masked_in0[52]) begin pos0 = 6'd52; valid0 = 1'b1; end
        else if (masked_in0[53]) begin pos0 = 6'd53; valid0 = 1'b1; end
        else if (masked_in0[54]) begin pos0 = 6'd54; valid0 = 1'b1; end
        else if (masked_in0[55]) begin pos0 = 6'd55; valid0 = 1'b1; end
        else if (masked_in0[56]) begin pos0 = 6'd56; valid0 = 1'b1; end
        else if (masked_in0[57]) begin pos0 = 6'd57; valid0 = 1'b1; end
        else if (masked_in0[58]) begin pos0 = 6'd58; valid0 = 1'b1; end
        else if (masked_in0[59]) begin pos0 = 6'd59; valid0 = 1'b1; end
        else if (masked_in0[60]) begin pos0 = 6'd60; valid0 = 1'b1; end
        else if (masked_in0[61]) begin pos0 = 6'd61; valid0 = 1'b1; end
        else if (masked_in0[62]) begin pos0 = 6'd62; valid0 = 1'b1; end
        else if (masked_in0[63]) begin pos0 = 6'd63; valid0 = 1'b1; end
        in_zero_enc64_0 = ~valid0;
		  
        // Mask the first '1' if found
       // if (valid0) masked_in[pos0] = 1'b0;
		  
		  // Second priority encoder
		  

        if (masked_in1[0]) begin pos1 = 6'd0; valid1 = 1'b1; end
        else if (masked_in1[1]) begin pos1 = 6'd1; valid1 = 1'b1; end
        else if (masked_in1[2]) begin pos1 = 6'd2; valid1 = 1'b1; end
        else if (masked_in1[3]) begin pos1 = 6'd3; valid1 = 1'b1; end
        else if (masked_in1[4]) begin pos1 = 6'd4; valid1 = 1'b1; end
        else if (masked_in1[5]) begin pos1 = 6'd5; valid1 = 1'b1; end
        else if (masked_in1[6]) begin pos1 = 6'd6; valid1 = 1'b1; end
        else if (masked_in1[7]) begin pos1 = 6'd7; valid1 = 1'b1; end
        else if (masked_in1[8]) begin pos1 = 6'd8; valid1 = 1'b1; end
        else if (masked_in1[9]) begin pos1 = 6'd9; valid1 = 1'b1; end
        else if (masked_in1[10]) begin pos1 = 6'd10; valid1 = 1'b1; end
        else if (masked_in1[11]) begin pos1 = 6'd11; valid1 = 1'b1; end
        else if (masked_in1[12]) begin pos1 = 6'd12; valid1 = 1'b1; end
        else if (masked_in1[13]) begin pos1 = 6'd13; valid1 = 1'b1; end
        else if (masked_in1[14]) begin pos1 = 6'd14; valid1 = 1'b1; end
        else if (masked_in1[15]) begin pos1 = 6'd15; valid1 = 1'b1; end
        else if (masked_in1[16]) begin pos1 = 6'd16; valid1 = 1'b1; end
        else if (masked_in1[17]) begin pos1 = 6'd17; valid1 = 1'b1; end
        else if (masked_in1[18]) begin pos1 = 6'd18; valid1 = 1'b1; end
        else if (masked_in1[19]) begin pos1 = 6'd19; valid1 = 1'b1; end
        else if (masked_in1[20]) begin pos1 = 6'd20; valid1 = 1'b1; end
        else if (masked_in1[21]) begin pos1 = 6'd21; valid1 = 1'b1; end
        else if (masked_in1[22]) begin pos1 = 6'd22; valid1 = 1'b1; end
        else if (masked_in1[23]) begin pos1 = 6'd23; valid1 = 1'b1; end
        else if (masked_in1[24]) begin pos1 = 6'd24; valid1 = 1'b1; end
        else if (masked_in1[25]) begin pos1 = 6'd25; valid1 = 1'b1; end
        else if (masked_in1[26]) begin pos1 = 6'd26; valid1 = 1'b1; end
        else if (masked_in1[27]) begin pos1 = 6'd27; valid1 = 1'b1; end
        else if (masked_in1[28]) begin pos1 = 6'd28; valid1 = 1'b1; end
        else if (masked_in1[29]) begin pos1 = 6'd29; valid1 = 1'b1; end
        else if (masked_in1[30]) begin pos1 = 6'd30; valid1 = 1'b1; end
        else if (masked_in1[31]) begin pos1 = 6'd31; valid1 = 1'b1; end
        else if (masked_in1[32]) begin pos1 = 6'd32; valid1 = 1'b1; end
        else if (masked_in1[33]) begin pos1 = 6'd33; valid1 = 1'b1; end
        else if (masked_in1[34]) begin pos1 = 6'd34; valid1 = 1'b1; end
        else if (masked_in1[35]) begin pos1 = 6'd35; valid1 = 1'b1; end
        else if (masked_in1[36]) begin pos1 = 6'd36; valid1 = 1'b1; end
        else if (masked_in1[37]) begin pos1 = 6'd37; valid1 = 1'b1; end
        else if (masked_in1[38]) begin pos1 = 6'd38; valid1 = 1'b1; end
        else if (masked_in1[39]) begin pos1 = 6'd39; valid1 = 1'b1; end
        else if (masked_in1[40]) begin pos1 = 6'd40; valid1 = 1'b1; end
        else if (masked_in1[41]) begin pos1 = 6'd41; valid1 = 1'b1; end
        else if (masked_in1[42]) begin pos1 = 6'd42; valid1 = 1'b1; end
        else if (masked_in1[43]) begin pos1 = 6'd43; valid1 = 1'b1; end
        else if (masked_in1[44]) begin pos1 = 6'd44; valid1 = 1'b1; end
        else if (masked_in1[45]) begin pos1 = 6'd45; valid1 = 1'b1; end
        else if (masked_in1[46]) begin pos1 = 6'd46; valid1 = 1'b1; end
        else if (masked_in1[47]) begin pos1 = 6'd47; valid1 = 1'b1; end
        else if (masked_in1[48]) begin pos1 = 6'd48; valid1 = 1'b1; end
        else if (masked_in1[49]) begin pos1 = 6'd49; valid1 = 1'b1; end
        else if (masked_in1[50]) begin pos1 = 6'd50; valid1 = 1'b1; end
        else if (masked_in1[51]) begin pos1 = 6'd51; valid1 = 1'b1; end
        else if (masked_in1[52]) begin pos1 = 6'd52; valid1 = 1'b1; end
        else if (masked_in1[53]) begin pos1 = 6'd53; valid1 = 1'b1; end
        else if (masked_in1[54]) begin pos1 = 6'd54; valid1 = 1'b1; end
        else if (masked_in1[55]) begin pos1 = 6'd55; valid1 = 1'b1; end
        else if (masked_in1[56]) begin pos1 = 6'd56; valid1 = 1'b1; end
        else if (masked_in1[57]) begin pos1 = 6'd57; valid1 = 1'b1; end
        else if (masked_in1[58]) begin pos1 = 6'd58; valid1 = 1'b1; end
        else if (masked_in1[59]) begin pos1 = 6'd59; valid1 = 1'b1; end
        else if (masked_in1[60]) begin pos1 = 6'd60; valid1 = 1'b1; end
        else if (masked_in1[61]) begin pos1 = 6'd61; valid1 = 1'b1; end
        else if (masked_in1[62]) begin pos1 = 6'd62; valid1 = 1'b1; end
        else if (masked_in1[63]) begin pos1 = 6'd63; valid1 = 1'b1; end
        in_zero_enc64_1 = ~valid1;

		  
		  // Mask the second '1' if found
      //  if (valid1) masked_in[pos1] = 1'b0;
		  
               if (masked_in2[0]) begin pos2 = 6'd0; valid2 = 1'b1; end
        else if (masked_in2[1]) begin pos2 = 6'd1; valid2 = 1'b1; end
        else if (masked_in2[2]) begin pos2 = 6'd2; valid2 = 1'b1; end
        else if (masked_in2[3]) begin pos2 = 6'd3; valid2 = 1'b1; end
        else if (masked_in2[4]) begin pos2 = 6'd4; valid2 = 1'b1; end
        else if (masked_in2[5]) begin pos2 = 6'd5; valid2 = 1'b1; end
        else if (masked_in2[6]) begin pos2 = 6'd6; valid2 = 1'b1; end
        else if (masked_in2[7]) begin pos2 = 6'd7; valid2 = 1'b1; end
        else if (masked_in2[8]) begin pos2 = 6'd8; valid2 = 1'b1; end
        else if (masked_in2[9]) begin pos2 = 6'd9; valid2 = 1'b1; end
        else if (masked_in2[10]) begin pos2 = 6'd10; valid2 = 1'b1; end
        else if (masked_in2[11]) begin pos2 = 6'd11; valid2 = 1'b1; end
        else if (masked_in2[12]) begin pos2 = 6'd12; valid2 = 1'b1; end
        else if (masked_in2[13]) begin pos2 = 6'd13; valid2 = 1'b1; end
        else if (masked_in2[14]) begin pos2 = 6'd14; valid2 = 1'b1; end
        else if (masked_in2[15]) begin pos2 = 6'd15; valid2 = 1'b1; end
        else if (masked_in2[16]) begin pos2 = 6'd16; valid2 = 1'b1; end
        else if (masked_in2[17]) begin pos2 = 6'd17; valid2 = 1'b1; end
        else if (masked_in2[18]) begin pos2 = 6'd18; valid2 = 1'b1; end
        else if (masked_in2[19]) begin pos2 = 6'd19; valid2 = 1'b1; end
        else if (masked_in2[20]) begin pos2 = 6'd20; valid2 = 1'b1; end
        else if (masked_in2[21]) begin pos2 = 6'd21; valid2 = 1'b1; end
        else if (masked_in2[22]) begin pos2 = 6'd22; valid2 = 1'b1; end
        else if (masked_in2[23]) begin pos2 = 6'd23; valid2 = 1'b1; end
        else if (masked_in2[24]) begin pos2 = 6'd24; valid2 = 1'b1; end
        else if (masked_in2[25]) begin pos2 = 6'd25; valid2 = 1'b1; end
        else if (masked_in2[26]) begin pos2 = 6'd26; valid2 = 1'b1; end
        else if (masked_in2[27]) begin pos2 = 6'd27; valid2 = 1'b1; end
        else if (masked_in2[28]) begin pos2 = 6'd28; valid2 = 1'b1; end
        else if (masked_in2[29]) begin pos2 = 6'd29; valid2 = 1'b1; end
        else if (masked_in2[30]) begin pos2 = 6'd30; valid2 = 1'b1; end
        else if (masked_in2[31]) begin pos2 = 6'd31; valid2 = 1'b1; end
        else if (masked_in2[32]) begin pos2 = 6'd32; valid2 = 1'b1; end
        else if (masked_in2[33]) begin pos2 = 6'd33; valid2 = 1'b1; end
        else if (masked_in2[34]) begin pos2 = 6'd34; valid2 = 1'b1; end
        else if (masked_in2[35]) begin pos2 = 6'd35; valid2 = 1'b1; end
        else if (masked_in2[36]) begin pos2 = 6'd36; valid2 = 1'b1; end
        else if (masked_in2[37]) begin pos2 = 6'd37; valid2 = 1'b1; end
        else if (masked_in2[38]) begin pos2 = 6'd38; valid2 = 1'b1; end
        else if (masked_in2[39]) begin pos2 = 6'd39; valid2 = 1'b1; end
        else if (masked_in2[40]) begin pos2 = 6'd40; valid2 = 1'b1; end
        else if (masked_in2[41]) begin pos2 = 6'd41; valid2 = 1'b1; end
        else if (masked_in2[42]) begin pos2 = 6'd42; valid2 = 1'b1; end
        else if (masked_in2[43]) begin pos2 = 6'd43; valid2 = 1'b1; end
        else if (masked_in2[44]) begin pos2 = 6'd44; valid2 = 1'b1; end
        else if (masked_in2[45]) begin pos2 = 6'd45; valid2 = 1'b1; end
        else if (masked_in2[46]) begin pos2 = 6'd46; valid2 = 1'b1; end
        else if (masked_in2[47]) begin pos2 = 6'd47; valid2 = 1'b1; end
        else if (masked_in2[48]) begin pos2 = 6'd48; valid2 = 1'b1; end
        else if (masked_in2[49]) begin pos2 = 6'd49; valid2 = 1'b1; end
        else if (masked_in2[50]) begin pos2 = 6'd50; valid2 = 1'b1; end
        else if (masked_in2[51]) begin pos2 = 6'd51; valid2 = 1'b1; end
        else if (masked_in2[52]) begin pos2 = 6'd52; valid2 = 1'b1; end
        else if (masked_in2[53]) begin pos2 = 6'd53; valid2 = 1'b1; end
        else if (masked_in2[54]) begin pos2 = 6'd54; valid2 = 1'b1; end
        else if (masked_in2[55]) begin pos2 = 6'd55; valid2 = 1'b1; end
        else if (masked_in2[56]) begin pos2 = 6'd56; valid2 = 1'b1; end
        else if (masked_in2[57]) begin pos2 = 6'd57; valid2 = 1'b1; end
        else if (masked_in2[58]) begin pos2 = 6'd58; valid2 = 1'b1; end
        else if (masked_in2[59]) begin pos2 = 6'd59; valid2 = 1'b1; end
        else if (masked_in2[60]) begin pos2 = 6'd60; valid2 = 1'b1; end
        else if (masked_in2[61]) begin pos2 = 6'd61; valid2 = 1'b1; end
        else if (masked_in2[62]) begin pos2 = 6'd62; valid2 = 1'b1; end
        else if (masked_in2[63]) begin pos2 = 6'd63; valid2 = 1'b1; end
        in_zero_enc64_2 = ~valid2;

        // Mask the third '1' if found
      //  if (valid2) masked_in[pos2] = 1'b0;
		          if (masked_in3[0]) begin pos3 = 6'd0; valid3 = 1'b1; end
        else if (masked_in3[1]) begin pos3 = 6'd1; valid3 = 1'b1; end
        else if (masked_in3[2]) begin pos3 = 6'd2; valid3 = 1'b1; end
        else if (masked_in3[3]) begin pos3 = 6'd3; valid3 = 1'b1; end
        else if (masked_in3[4]) begin pos3 = 6'd4; valid3 = 1'b1; end
        else if (masked_in3[5]) begin pos3 = 6'd5; valid3 = 1'b1; end
        else if (masked_in3[6]) begin pos3 = 6'd6; valid3 = 1'b1; end
        else if (masked_in3[7]) begin pos3 = 6'd7; valid3 = 1'b1; end
        else if (masked_in3[8]) begin pos3 = 6'd8; valid3 = 1'b1; end
        else if (masked_in3[9]) begin pos3 = 6'd9; valid3 = 1'b1; end
        else if (masked_in3[10]) begin pos3 = 6'd10; valid3 = 1'b1; end
        else if (masked_in3[11]) begin pos3 = 6'd11; valid3 = 1'b1; end
        else if (masked_in3[12]) begin pos3 = 6'd12; valid3 = 1'b1; end
        else if (masked_in3[13]) begin pos3 = 6'd13; valid3 = 1'b1; end
        else if (masked_in3[14]) begin pos3 = 6'd14; valid3 = 1'b1; end
        else if (masked_in3[15]) begin pos3 = 6'd15; valid3 = 1'b1; end
        else if (masked_in3[16]) begin pos3 = 6'd16; valid3 = 1'b1; end
        else if (masked_in3[17]) begin pos3 = 6'd17; valid3 = 1'b1; end
        else if (masked_in3[18]) begin pos3 = 6'd18; valid3 = 1'b1; end
        else if (masked_in3[19]) begin pos3 = 6'd19; valid3 = 1'b1; end
        else if (masked_in3[20]) begin pos3 = 6'd20; valid3 = 1'b1; end
        else if (masked_in3[21]) begin pos3 = 6'd21; valid3 = 1'b1; end
        else if (masked_in3[22]) begin pos3 = 6'd22; valid3 = 1'b1; end
        else if (masked_in3[23]) begin pos3 = 6'd23; valid3 = 1'b1; end
        else if (masked_in3[24]) begin pos3 = 6'd24; valid3 = 1'b1; end
        else if (masked_in3[25]) begin pos3 = 6'd25; valid3 = 1'b1; end
        else if (masked_in3[26]) begin pos3 = 6'd26; valid3 = 1'b1; end
        else if (masked_in3[27]) begin pos3 = 6'd27; valid3 = 1'b1; end
        else if (masked_in3[28]) begin pos3 = 6'd28; valid3 = 1'b1; end
        else if (masked_in3[29]) begin pos3 = 6'd29; valid3 = 1'b1; end
        else if (masked_in3[30]) begin pos3 = 6'd30; valid3 = 1'b1; end
        else if (masked_in3[31]) begin pos3 = 6'd31; valid3 = 1'b1; end
        else if (masked_in3[32]) begin pos3 = 6'd32; valid3 = 1'b1; end
        else if (masked_in3[33]) begin pos3 = 6'd33; valid3 = 1'b1; end
        else if (masked_in3[34]) begin pos3 = 6'd34; valid3 = 1'b1; end
        else if (masked_in3[35]) begin pos3 = 6'd35; valid3 = 1'b1; end
        else if (masked_in3[36]) begin pos3 = 6'd36; valid3 = 1'b1; end
        else if (masked_in3[37]) begin pos3 = 6'd37; valid3 = 1'b1; end
        else if (masked_in3[38]) begin pos3 = 6'd38; valid3 = 1'b1; end
        else if (masked_in3[39]) begin pos3 = 6'd39; valid3 = 1'b1; end
        else if (masked_in3[40]) begin pos3 = 6'd40; valid3 = 1'b1; end
        else if (masked_in3[41]) begin pos3 = 6'd41; valid3 = 1'b1; end
        else if (masked_in3[42]) begin pos3 = 6'd42; valid3 = 1'b1; end
        else if (masked_in3[43]) begin pos3 = 6'd43; valid3 = 1'b1; end
        else if (masked_in3[44]) begin pos3 = 6'd44; valid3 = 1'b1; end
        else if (masked_in3[45]) begin pos3 = 6'd45; valid3 = 1'b1; end
        else if (masked_in3[46]) begin pos3 = 6'd46; valid3 = 1'b1; end
        else if (masked_in3[47]) begin pos3 = 6'd47; valid3 = 1'b1; end
        else if (masked_in3[48]) begin pos3 = 6'd48; valid3 = 1'b1; end
        else if (masked_in3[49]) begin pos3 = 6'd49; valid3 = 1'b1; end
        else if (masked_in3[50]) begin pos3 = 6'd50; valid3 = 1'b1; end
        else if (masked_in3[51]) begin pos3 = 6'd51; valid3 = 1'b1; end
        else if (masked_in3[52]) begin pos3 = 6'd52; valid3 = 1'b1; end
        else if (masked_in3[53]) begin pos3 = 6'd53; valid3 = 1'b1; end
        else if (masked_in3[54]) begin pos3 = 6'd54; valid3 = 1'b1; end
        else if (masked_in3[55]) begin pos3 = 6'd55; valid3 = 1'b1; end
        else if (masked_in3[56]) begin pos3 = 6'd56; valid3 = 1'b1; end
        else if (masked_in3[57]) begin pos3 = 6'd57; valid3 = 1'b1; end
        else if (masked_in3[58]) begin pos3 = 6'd58; valid3 = 1'b1; end
        else if (masked_in3[59]) begin pos3 = 6'd59; valid3 = 1'b1; end
        else if (masked_in3[60]) begin pos3 = 6'd60; valid3 = 1'b1; end
        else if (masked_in3[61]) begin pos3 = 6'd61; valid3 = 1'b1; end
        else if (masked_in3[62]) begin pos3 = 6'd62; valid3 = 1'b1; end
        else if (masked_in3[63]) begin pos3 = 6'd63; valid3 = 1'b1; end
        in_zero_enc64_3 = ~valid3;
end 
endmodule 
		  
		  
		  
		  