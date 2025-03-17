module instruction_prepare_LoadStore (
	 input [44:0] instruction_lsu0, instruction_lsu1, 
	 
    input [31:0] lsu0_Rt, lsu0_Rs,
    input [31:0] lsu1_Rt, lsu1_Rs,
    
    output [118:0] instruction_lsu0out, instruction_lsu1out
);


/*
this module just prepares the instruction and concatinates the source values from the PRF with it along side the instruction metadata.

the recieved instruction : 
[44:40] ROB
[39:38] op
[37:32] Rt
[31:26] Rs
[25:24] aluselmuxs1
[23:22] aluselmuxs2
[21:20] lsuselmuxs1
[19:18] lseselmuxs2
[17] isforwardRt
[16] isforwardRs
[15:0]imm

the full instruction assembly must be 

[118:114]	ROB
[113:112]	op
[111:106]	Rt as destination if LW
[105:74]	Rt input to the module
[73:42]	Rs input to the module
[41:40] aluselmuxs1
[39:38] aluselmuxs2
[37:36] lsuselmuxs1
[35:34] lseselmuxs2
[33] isforwardRt
[32] isforwardRs
[31:0]imm	

*/

// Wires for extracted fields from instruction_lsu0
wire [4:0]  ROB_lsu0        = instruction_lsu0[44:40];
wire [1:0]  op_lsu0         = instruction_lsu0[39:38];
wire [5:0]  Rt_lsu0         = instruction_lsu0[37:32];
wire [1:0]  aluselmuxs1_lsu0 = instruction_lsu0[25:24];
wire [1:0]  aluselmuxs2_lsu0 = instruction_lsu0[23:22];
wire [1:0]  lsuselmuxs1_lsu0 = instruction_lsu0[21:20];
wire [1:0]  lseselmuxs2_lsu0 = instruction_lsu0[19:18];
wire        isforwardRt_lsu0 = instruction_lsu0[17];
wire        isforwardRs_lsu0 = instruction_lsu0[16];

// Sign-extend the immediate values to 32 bits
wire [31:0] imm_lsu0_ext = {{16{instruction_lsu0[15]}}, instruction_lsu0[15:0]};  // Sign extension

assign instruction_lsu0out = {ROB_lsu0,Rt_lsu0, op_lsu0, lsu0_Rt, lsu0_Rs, aluselmuxs1_lsu0, aluselmuxs2_lsu0, 
                        lsuselmuxs1_lsu0, lseselmuxs2_lsu0, isforwardRt_lsu0, isforwardRs_lsu0, imm_lsu0_ext};

// Wires for extracted fields from instruction_lsu1
wire [4:0]  ROB_lsu1        = instruction_lsu1[44:40];
wire [1:0]  op_lsu1         = instruction_lsu1[39:38];
wire [5:0]  Rt_lsu1         = instruction_lsu1[37:32];
wire [1:0]  aluselmuxs1_lsu1 = instruction_lsu1[25:24];
wire [1:0]  aluselmuxs2_lsu1 = instruction_lsu1[23:22];
wire [1:0]  lsuselmuxs1_lsu1 = instruction_lsu1[21:20];
wire [1:0]  lseselmuxs2_lsu1 = instruction_lsu1[19:18];
wire        isforwardRt_lsu1 = instruction_lsu1[17];
wire        isforwardRs_lsu1 = instruction_lsu1[16];


// Sign-extend the immediate values to 32 bits

wire [31:0] imm_lsu1_ext = {{16{instruction_lsu1[15]}}, instruction_lsu1[15:0]};  // Sign extension

assign instruction_lsu1out = {ROB_lsu1, Rt_lsu1 ,op_lsu1, lsu1_Rt, lsu1_Rs, aluselmuxs1_lsu1, aluselmuxs2_lsu1, 
                        lsuselmuxs1_lsu1, lseselmuxs2_lsu1, isforwardRt_lsu1, isforwardRs_lsu1, imm_lsu1_ext};


endmodule