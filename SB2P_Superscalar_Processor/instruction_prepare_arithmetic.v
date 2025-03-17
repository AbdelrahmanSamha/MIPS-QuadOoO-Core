
module instruction_prepare_arithmetic (
    input [50:0] instruction_alu0, instruction_alu1, instruction_alu2, instruction_alu3, instruction_bu,
    input [31:0] inst0source1, inst0source2,
    input [31:0] inst1source1, inst1source2,
    input [31:0] inst2source1, inst2source2,
    input [31:0] inst3source1, inst3source2,
    input [31:0] inst4source1, inst4source2,
    output reg [88:0] instructionout_alu0, instructionout_alu1, instructionout_alu2, instructionout_alu3,
	 output reg [94:0] instructionout_bu
);


/*this module just prepares the instruction based on its type and concatinates the source values from the PRF with it along side the instruction metadata.
it allows for handeling R-type and I-type arithmetic instructions. 

*/


/*the recieved instruction should be with the following format:
5bits for the ROBentry
2bits for BRANCHID --00 if no speculation

2bits to indicate if instruciton is either R-type, I-type, or branch or jr
4bits for operation

6 bits for destination
6 bits for source1 index 
4 bits for ALU forwarding (split as 2+2)
4 bits for LSU forwarding (split as 2+2)
2 bits to indicate if the instruction needs forwarding (split as 1+1)
16bit for imm value (6 MSB contains Source2 if R-type)
*/

/* 
the output format of the instrucition that will enter the ALUs: 
	ROB 5 
	aluoperation 4 
	dest 6 bits 
	muxalus1 2bits 
	muxalus2 2bits 
	muxlsus1 2bits
	muxlsus2 2bits 
	isforwards1 1bit 
	isforwards2 1bit 
	source1 from PRF 32bits
	source2 from PRF || immediate value 32bits
	total bits in the wire for the ALUS = 89.
	
	the instruction assembly for the ALU:
	
	88:84	ROBentry 
	83:80 operation
	79:74	dest 
	73:42 source1 
	41:10 source2 or imm
	9:8   s1_alu_forwarding
	7:6   s2_alu_forwarding
	5:4   s1_lsu_forwarding
	3:2   s2_lsu_forwarding
	1	   s1_needforwarding
	0		s2_needforwarding
*/ 


/*

the operation bits repreasent what operation must be done on the instruciton, and since there is 4 bits we can repreasent 16 cases, 
we need 10 for the ALU, 
2 to tell if its BEQ, BNE
2 to tell if its load or store
1 to tell if its Jr
1 to indicate that there is nothing
in this module we care about the ALU operations and the branch and JR operations, the Load store operations will be ignored here because we are not preparing any instruction for that here. 

the indicator are 2 bits that repreasent if the isntructions is a branch a JR an R-type or I-type.

*/


//---------------------------------------------------------------------
// Instruction 0 Processing
//---------------------------------------------------------------------
wire [4:0] ROBentry0;
wire is_Itype0;
wire [3:0] operation0;
wire [5:0] destination0;
wire [1:0] s1_alu_forwarding0;
wire [1:0] s2_alu_forwarding0;
wire [1:0] s1_lsu_forwarding0;
wire [1:0] s2_lsu_forwarding0;
wire       s1_needforwarding0;
wire       s2_needforwarding0;
wire [31:0] immediate0;

assign ROBentry0          = instruction_alu0[50:46];
assign is_Itype0          = instruction_alu0[42];
assign operation0         = instruction_alu0[41:38];
assign destination0       = instruction_alu0[37:32];
assign s1_alu_forwarding0 = instruction_alu0[25:24];
assign s2_alu_forwarding0 = instruction_alu0[23:22];
assign s1_lsu_forwarding0 = instruction_alu0[21:20];
assign s2_lsu_forwarding0 = instruction_alu0[19:18];
assign s1_needforwarding0 = instruction_alu0[17];
assign s2_needforwarding0 = instruction_alu0[16];
assign immediate0         = {{16{instruction_alu0[15]}}, instruction_alu0[15:0]};
	

	
	always @(*) begin
		if (operation0 != 0) begin
			if (!is_Itype0) begin // R-type
				instructionout_alu0 = {
					ROBentry0,
					operation0,
					destination0,
					inst0source1,
					inst0source2,
					s1_alu_forwarding0,
					s2_alu_forwarding0,
					s1_lsu_forwarding0,
					s2_lsu_forwarding0,
					s1_needforwarding0,
					s2_needforwarding0
				};
			end else begin // I-type 
				instructionout_alu0 = {
					ROBentry0,
					operation0,
					destination0,
					inst0source1,
					immediate0,
					s1_alu_forwarding0,
					s2_alu_forwarding0,
					s1_lsu_forwarding0,
					s2_lsu_forwarding0,
					s1_needforwarding0,
					1'b0
				};
			end
		end else begin
			instructionout_alu0 = 89'b0;
		end
	end
	
	//---------------------------------------------------------------------
// Instruction 1 Processing
//---------------------------------------------------------------------
wire [4:0] ROBentry1;
wire is_Itype1;
wire [3:0] operation1;
wire [5:0] destination1;
wire [1:0] s1_alu_forwarding1;
wire [1:0] s2_alu_forwarding1;
wire [1:0] s1_lsu_forwarding1;
wire [1:0] s2_lsu_forwarding1;
wire       s1_needforwarding1;
wire       s2_needforwarding1;
wire [31:0] immediate1;

assign ROBentry1          = instruction_alu1[50:46];
assign is_Itype1          = instruction_alu1[42];
assign operation1         = instruction_alu1[41:38];
assign destination1       = instruction_alu1[37:32];
assign s1_alu_forwarding1 = instruction_alu1[25:24];
assign s2_alu_forwarding1 = instruction_alu1[23:22];
assign s1_lsu_forwarding1 = instruction_alu1[21:20];
assign s2_lsu_forwarding1 = instruction_alu1[19:18];
assign s1_needforwarding1 = instruction_alu1[17];
assign s2_needforwarding1 = instruction_alu1[16];
assign immediate1         = {{16{instruction_alu1[15]}}, instruction_alu1[15:0]};

always @(*) begin
	if (operation1 != 0) begin
		if (!is_Itype1) begin // R-type
			instructionout_alu1 =
				{ROBentry1,
				operation1,
				destination1,
				inst1source1,
				inst1source2,
				s1_alu_forwarding1,
				s2_alu_forwarding1,
				s1_lsu_forwarding1,
				s2_lsu_forwarding1,
				s1_needforwarding1,
				s2_needforwarding1
				};
		end else begin // I-type 
			instructionout_alu1 =
				{ROBentry1,
				operation1,
				destination1,
				inst1source1,
				immediate1,
				s1_alu_forwarding1,
				s2_alu_forwarding1,
				s1_lsu_forwarding1,
				s2_lsu_forwarding1,
				s1_needforwarding1,
				1'b0};
		end
	end else begin
		instructionout_alu1 = 89'b0;
	end
end
	
//---------------------------------------------------------------------
// Instruction 2 Processing
//---------------------------------------------------------------------
wire [4:0] ROBentry2;
wire is_Itype2;
wire [3:0] operation2;
wire [5:0] destination2;
wire [1:0] s1_alu_forwarding2;
wire [1:0] s2_alu_forwarding2;
wire [1:0] s1_lsu_forwarding2;
wire [1:0] s2_lsu_forwarding2;
wire       s1_needforwarding2;
wire       s2_needforwarding2;
wire [31:0] immediate2;

assign ROBentry2          = instruction_alu2[50:46];
assign is_Itype2          = instruction_alu2[42];
assign operation2         = instruction_alu2[41:38];
assign destination2       = instruction_alu2[37:32];
assign s1_alu_forwarding2 = instruction_alu2[25:24];
assign s2_alu_forwarding2 = instruction_alu2[23:22];
assign s1_lsu_forwarding2 = instruction_alu2[21:20];
assign s2_lsu_forwarding2 = instruction_alu2[19:18];
assign s1_needforwarding2 = instruction_alu2[17];
assign s2_needforwarding2 = instruction_alu2[16];
assign immediate2         = {{16{instruction_alu2[15]}}, instruction_alu2[15:0]};

always @(*) begin
    if (operation2 != 0) begin
        if (!is_Itype2) begin // R-type
            instructionout_alu2 = {
                ROBentry2,
                operation2,
                destination2,
                inst2source1,
                inst2source2,
                s1_alu_forwarding2,
                s2_alu_forwarding2,
                s1_lsu_forwarding2,
                s2_lsu_forwarding2,
                s1_needforwarding2,
                s2_needforwarding2
            };
        end else begin // I-type 
            instructionout_alu2 = {
                ROBentry2,
                operation2,
                destination2,
                inst2source1,
                immediate2,
                s1_alu_forwarding2,
                s2_alu_forwarding2,
                s1_lsu_forwarding2,
                s2_lsu_forwarding2,
                s1_needforwarding2,
                1'b0
            };
        end
    end else begin
        instructionout_alu2 = 89'b0;
    end
end
	
	//---------------------------------------------------------------------
// Instruction 3 Processing
//---------------------------------------------------------------------
wire [4:0] ROBentry3;
wire 		  is_Itype3;
wire [3:0] operation3;
wire [5:0] destination3;
wire [1:0] s1_alu_forwarding3;
wire [1:0] s2_alu_forwarding3;
wire [1:0] s1_lsu_forwarding3;
wire [1:0] s2_lsu_forwarding3;
wire       s1_needforwarding3;
wire       s2_needforwarding3;
wire [31:0]immediate3;

assign ROBentry3          = instruction_alu3[50:46];
assign is_Itype3          = instruction_alu3[42];
assign operation3         = instruction_alu3[41:38];
assign destination3       = instruction_alu3[37:32];
assign s1_alu_forwarding3 = instruction_alu3[25:24];
assign s2_alu_forwarding3 = instruction_alu3[23:22];
assign s1_lsu_forwarding3 = instruction_alu3[21:20];
assign s2_lsu_forwarding3 = instruction_alu3[19:18];
assign s1_needforwarding3 = instruction_alu3[17];
assign s2_needforwarding3 = instruction_alu3[16];
assign immediate3         = {{16{instruction_alu3[15]}}, instruction_alu3[15:0]};

always @(*) begin
    if (operation3 != 0) begin
        if (!is_Itype3) begin // R-type
            instructionout_alu3 = {
                ROBentry3,
                operation3,
                destination3,
                inst3source1,
                inst3source2,
                s1_alu_forwarding3,
                s2_alu_forwarding3,
                s1_lsu_forwarding3,
                s2_lsu_forwarding3,
                s1_needforwarding3,
                s2_needforwarding3
            };
        end else begin // I-type 
            instructionout_alu3 = {
                ROBentry3,
                operation3,
                destination3,
                inst3source1,
                immediate3,
                s1_alu_forwarding3,
                s2_alu_forwarding3,
                s1_lsu_forwarding3,
                s2_lsu_forwarding3,
                s1_needforwarding3,
                1'b0
            };
        end
    end else begin
        instructionout_alu3 = 89'b0;
    end
end
	
	
	
	
	
	
	//---------------------------------------------------------------------
	// Instruction 4 Processing (Branch )
	//---------------------------------------------------------------------
	/*
	for the branch unit we need the following information 
	5 bits ROBentry 
	2 bits for BID
	3 bits operation //the codes for the branch are 1011 BNE, 1100 BEQ, 1111 JR, we can take only the 3LSB bits of the operation since they will be suffiecent   
	32 bits for source 1
	32 bits for source 2 
	muxalus1 2bits 
	muxalus2 2bits 
	muxlsus1 2bits
	muxlsus2 2bits 
	isforwards1 1bit 
	isforwards2 1bit 
	immediate value 16bits, ******note, we can discard this if we calculate the address and store it in the fetch stage, but for now we are assuming that this immediate 
											value is the calculated address thats the opposet to the pridiction. meaning if we predicted taken this immediate value must be the PC+1
											and if we predicted not taken then this immediate value must be the jump address. 
 
	the output format for a branch instruction is a total of a 94 bits as the following 
		
		
	[94:90]	ROBentry4
	[89:88]	BIDbu
	[87:85]	operation4
	[84:53]	inst4source1
	[52:21]	inst4source2
	[20:19]	s1_alu_forwarding4
	[18:17]	s2_alu_forwarding4
	[16:15]	s1_lsu_forwarding4
	[14:13]	s2_lsu_forwarding4
	12 s1_needforwarding4
	11 s2_needforwarding4
	10 prediction
	[9:0] imm
	
	
	
	
	for the jr format, we only care about the ROB, operation, source1 which is rs and the forwarding signals for it.
	*/
	
	
	wire [4:0] ROBentry4;
	wire 	is_branch;
	wire is_Jr;
	wire [1:0] BIDbu;   
	wire [2:0] operation4;
	wire [1:0] s1_alu_forwarding4 ;
	wire [1:0] s2_alu_forwarding4 ;
	wire [1:0] s1_lsu_forwarding4 ;
	wire [1:0] s2_lsu_forwarding4 ; 
	wire       s1_needforwarding4 ;
	wire       s2_needforwarding4 ;
	wire prediction;
	wire [9:0]immediate4  ;
	
	assign ROBentry4 = instruction_bu[50:46];
	assign BIDbu = instruction_bu[45:44];
	
	assign is_branch = (instruction_bu[43:42] == 2'b10);
	assign is_Jr     = (instruction_bu[43:42] == 2'b11);
	
	assign prediction = (instruction_bu[10]);
	
	assign operation4 = instruction_bu[40:38];
	assign s1_alu_forwarding4 = instruction_bu[25:24];
	assign s2_alu_forwarding4 = instruction_bu[23:22];
	assign s1_lsu_forwarding4 = instruction_bu[21:20];
	assign s2_lsu_forwarding4 = instruction_bu[19:18];
	assign s1_needforwarding4 = instruction_bu[17];
	assign s2_needforwarding4 = instruction_bu[16];
	assign immediate4 = instruction_bu[9:0];
	
	always @(*) begin
	instructionout_bu = 95'b0;
		if (operation4 != 0) begin
			if(is_branch)begin 
				instructionout_bu = {
					ROBentry4,
					BIDbu,
					operation4,
					inst4source1,
					inst4source2,
					s1_alu_forwarding4,
					s2_alu_forwarding4,
					s1_lsu_forwarding4,
					s2_lsu_forwarding4,
					s1_needforwarding4,
					s2_needforwarding4,
					prediction,
					immediate4
				};
				
			end 	
			if (is_Jr)begin 
				instructionout_bu = {
					ROBentry4,
					BIDbu,
					operation4,
					inst4source1,
					32'b0,
					s1_alu_forwarding4,
					2'b0,
					s1_lsu_forwarding4,
					2'b0,
					s1_needforwarding4,
					1'b0,
					1'b0,
					10'b0
			
				};
			end
		end
		
		
	
	end

endmodule