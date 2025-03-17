// need optimaization + + jal + j offset after change the memor to 2 ports 

module SB2P_Branching_Unit(
    instruction0, instruction1, instruction2, instruction3,
	 
	 Address_Branch,
	 
	 is_branchexe,
	 hit,
	 
	 prediction,

    flush0, flush1, flush2, flush3, 
	 
    offset, clk, reset, 
	 
	 new_branch_inst0, new_branch_inst1, new_branch_inst2, new_branch_inst3,
	 
	 mux0_sel, mux1_sel, mux2_sel, mux3_sel,
	 
	 addi,
	 
	 pc_in,
	 
	 jump_address,
	 
	 addres_mux_pc_jump_sel,
	 
	 /////////////////////////// JR 
	 write_on_rd0_decode,
	 write_on_rd1_decode,
	 write_on_rd2_decode,
	 write_on_rd3_decode,
	 
	 
	 rd0_decode,
	 rd1_decode,
	 rd2_decode,
	 rd3_decode,
	 
	 stall, // output 
	 
	 stall_in,
	 		  
	 jr_index_out, //  output
		  
	 jr_address_prf, // input 
	 
	 valid_index_fs_out,// output
	 
	 valid_index_prf_in // input 
	 
);

	input clk ,reset; 
	input [3:0]prediction;
   input wire [31:0] instruction0;      // Instruction 0 (32-bit)
   input wire [31:0] instruction1;      // Instruction 1 (32-bit)
   input wire [31:0] instruction2;      // Instruction 2 (32-bit)
   input wire [31:0] instruction3;      // Instruction 3 (32-bit)

	input [9:0] Address_Branch;
	
	input is_branchexe;
	
	input hit;
	 
	input [7:0] pc_in; 
 
	output addres_mux_pc_jump_sel;
	
 /******************************************************/
	input [10:0] jr_address_prf;
	
	output reg [4:0] jr_index_out;
 
 	input write_on_rd0_decode;
	input write_on_rd1_decode;
	input write_on_rd2_decode;
	input write_on_rd3_decode;
	
	input [4:0] rd0_decode; 
	input [4:0] rd1_decode; 
	input [4:0] rd2_decode; 
	input [4:0] rd3_decode; 
 
	input stall_in;
/*****************************************************/
   output reg flush0, flush1, flush2, flush3; // Flush signals for each pipeline
	
   output reg [1:0] offset;             // Offset value
	 
	wire is_jal0, is_jal1, is_jal2, is_jal3;
	 	
	wire [5:0] funct0, funct1, funct2, funct3; 
	 
	reg [1:0] offset_inst0, offset_inst1, offset_inst2, offset_inst3;
	 
	wire [9:0] branch_offset0, branch_offset1, branch_offset2, branch_offset3;
	 
	reg  [9:0] branch_return_address; 
	 
	output [1:0] mux0_sel, mux1_sel, mux2_sel, mux3_sel; // 00 => inst aligner ... 01 => addi ... 10 => branch
	 
	output [31:0] addi;
	
	output [31:0] new_branch_inst0, new_branch_inst1, new_branch_inst2, new_branch_inst3; 
	 
	output reg [9:0] jump_address; 
	 	
	output reg stall;
	
	output reg valid_index_fs_out; // This index is used to ensure that the correct data (address) is read from PRF.  
							  // The stall signal remains active until "valid_index_prf_in" becomes active.  
							  // Once active, the valid bit determines whether the stall signal is cleared.  
					
	
	input valid_index_prf_in; // the data (address) will only be true when this bit is active 
	
	 assign branch_offset0 = instruction0[9:0];
    assign branch_offset1 = instruction1[9:0];
    assign branch_offset2 = instruction2[9:0];
    assign branch_offset3 = instruction3[9:0];
	
	 wire is_branch0,is_branch1,is_branch2,is_branch3;
	 wire [5:0] opcode0, opcode1, opcode2, opcode3;
		  
    assign is_branch0 = (opcode0 == 6'h4 | opcode0 == 6'h5) ? 1'b1 : 1'b0; 
    assign is_branch1 = (opcode1 == 6'h4 | opcode1 == 6'h5) ? 1'b1 : 1'b0; 
    assign is_branch2 = (opcode2 == 6'h4 | opcode2 == 6'h5) ? 1'b1 : 1'b0;
    assign is_branch3 = (opcode3 == 6'h4 | opcode3 == 6'h5) ? 1'b1 : 1'b0;
	 
    // Decode opcodes and jump targets for each instruction

    assign opcode0 = instruction0[31:26];
    assign opcode1 = instruction1[31:26];
    assign opcode2 = instruction2[31:26];
    assign opcode3 = instruction3[31:26];
	 
	 assign funct0 = instruction0[5:0];
    assign funct1 = instruction1[5:0];
    assign funct2 = instruction2[5:0];
    assign funct3 = instruction3[5:0];

    wire [9:0] jump_target0, jump_target1, jump_target2, jump_target3;
    assign jump_target0 = instruction0[9:0];
    assign jump_target1 = instruction1[9:0];
    assign jump_target2 = instruction2[9:0];
    assign jump_target3 = instruction3[9:0];

    // Identify `jump`, `jal`, and `jr` instructions
    wire is_jump0, is_jump1, is_jump2, is_jump3;
	wire is_jump;

    assign is_jump0 = (opcode0 == 6'b000010); // Jump
    assign is_jump1 = (opcode1 == 6'b000010);
    assign is_jump2 = (opcode2 == 6'b000010);
    assign is_jump3 = (opcode3 == 6'b000010);

	 assign is_jump = (is_jump0 | is_jump1 | is_jump2 | is_jump3);

    assign is_jal0 = (opcode0 == 6'b000011);  // JAL
    assign is_jal1 = (opcode1 == 6'b000011);
    assign is_jal2 = (opcode2 == 6'b000011);
    assign is_jal3 = (opcode3 == 6'b000011);
   
   
 //   reg [7:0] link_pcpc;
   // wire [1:0] jal_offset;


	reg [2:0] new_offset_bit; 
	 		  
		 
	reg optimized_bit;
	reg [9:0] reg31_address,jal_next_pc;
	
	wire is_jal;
	wire is_branch;
	
	assign is_branch = ((is_branch0 && prediction[0] ) | (is_branch1 && prediction[1])| (is_branch2 && prediction[2])| (is_branch3 && prediction[3]));

	assign is_jal = (is_jal0 | is_jal1 | is_jal2 | is_jal3);
	
	
	
	/*************************************/   //jr 
	
	wire [4:0] rd0_fetch, rd1_fetch, rd2_fetch, rd3_fetch;
	
	wire is_jr_not_r31_0, is_jr_not_r31_1, is_jr_not_r31_2, is_jr_not_r31_3;

	wire is_jr_r31_0, is_jr_r31_1, is_jr_r31_2,is_jr_r31_3;	
 
	wire is_jr_not_r31;
	wire is_jr_r31;

    assign is_jr_not_r31_0 = ((opcode0 == 6'b0) && (funct0 == 6'b001000) && (!(rd0_fetch == 5'b11111)));   // JR reg 31 
    assign is_jr_not_r31_1 = ((opcode1 == 6'b0) && (funct1 == 6'b001000) && (!(rd1_fetch == 5'b11111)));
    assign is_jr_not_r31_2 = ((opcode2 == 6'b0) && (funct2 == 6'b001000) && (!(rd2_fetch == 5'b11111)));
    assign is_jr_not_r31_3 = ((opcode3 == 6'b0) && (funct3 == 6'b001000) && (!(rd3_fetch == 5'b11111)));


    assign is_jr_r31_0 = ((opcode0 == 6'b0) && (funct0 == 6'b001000) && (rd0_fetch == 5'b11111));   // JR reg 31 
    assign is_jr_r31_1 = ((opcode1 == 6'b0) && (funct1 == 6'b001000) && (rd1_fetch == 5'b11111));
    assign is_jr_r31_2 = ((opcode2 == 6'b0) && (funct2 == 6'b001000) && (rd2_fetch == 5'b11111));
    assign is_jr_r31_3 = ((opcode3 == 6'b0) && (funct3 == 6'b001000) && (rd3_fetch == 5'b11111));


	assign is_jr_not_r31 = (is_jr_not_r31_0 | is_jr_not_r31_1 | is_jr_not_r31_2 | is_jr_not_r31_3) ? 1'b1 : 1'b0;
	assign is_jr_r31 = (is_jr_r31_0 | is_jr_r31_1 | is_jr_r31_2 | is_jr_r31_3) ? 1'b1 : 1'b0;



	wire [5:0] sw_inst = 6'h2b;

	wire write_on_rd0_fetch, write_on_rd1_fetch, write_on_rd2_fetch, write_on_rd3_fetch;


    assign rd0_fetch = instruction0[25:21];
    assign rd1_fetch = instruction1[25:21];
    assign rd2_fetch = instruction2[25:21];
    assign rd3_fetch = instruction3[25:21];
	

	assign write_on_rd0_fetch = ((opcode0 == sw_inst) | (is_branch0)) ? 1'b0 : 1'b1; // threre is no need to check if rd0 == 0 
	assign write_on_rd1_fetch = ((opcode1 == sw_inst) | (is_branch1)) ? 1'b0 : 1'b1; 
	assign write_on_rd2_fetch = ((opcode2 == sw_inst) | (is_branch2)) ? 1'b0 : 1'b1;
	assign write_on_rd3_fetch = ((opcode3 == sw_inst) | (is_branch3)) ? 1'b0 : 1'b1; 

	
	// optimized_bit disable 


/////////// jr rd 
reg optimized_bit_reg;


wire [4:0] jr_rd;


assign jr_rd = (is_jr_r31_0 | is_jr_not_r31_0) ? rd0_fetch :
		  (is_jr_r31_1 | is_jr_not_r31_1) ? rd1_fetch :
		  (is_jr_r31_2 | is_jr_not_r31_2) ? rd2_fetch :
        (is_jr_r31_3 | is_jr_not_r31_3) ? rd3_fetch : 5'b0;



	// stall logic 

	reg stall_jr; //it will be activated only when there is jr and it has the highest priority 



	// index
always @(*) begin 

	jr_index_out = 5'b0;
	valid_index_fs_out =1'b0;
	
 	if (is_jr_not_r31_0 | (is_jr_r31_0 && !optimized_bit_reg)) begin 
		jr_index_out = rd0_fetch;
		valid_index_fs_out =1'b1;
	end
	if (is_jr_not_r31_1 | (is_jr_r31_1 && !optimized_bit_reg)) begin 
		jr_index_out = rd1_fetch;
		valid_index_fs_out =1'b1;
	end
	if (is_jr_not_r31_2 | (is_jr_r31_2 && !optimized_bit_reg)) begin 
		jr_index_out = rd2_fetch;
		valid_index_fs_out =1'b1;
	end
	if (is_jr_not_r31_3 | (is_jr_r31_3 && !optimized_bit_reg)) begin 
		jr_index_out = rd3_fetch;
		valid_index_fs_out =1'b1;
	end
end

wire valid_bit;

assign valid_bit = jr_address_prf[10];


// stall if not valid 
// send index receive bit

	/****************************************/


	


assign addres_mux_pc_jump_sel = (is_branch | is_jr_not_r31 | is_jr_r31 | is_jump | is_jal | (!(hit) && (is_branchexe))) ? 1'b1 : 1'B0;


	
	
	
	
/*************************************************************************************************************************/
	
	
	assign mux0_sel = is_branch0 ? 2'b10 :
                  is_jal0 ? 2'b01 :
                  is_jump0 ? 2'b00 :
                  2'b00;

	assign mux1_sel = is_branch1 ? 2'b10 :
                  is_jal1 ? 2'b01 :
                  is_jump1 ? 2'b00 :
                  2'b00;

	assign mux2_sel = is_branch2 ? 2'b10 :
                  is_jal2 ? 2'b01 :
                  is_jump2 ? 2'b00 :
                  2'b00;

	assign mux3_sel = is_branch3 ? 2'b10 :
                  is_jal3 ? 2'b01 :
                  is_jump3 ? 2'b00 :
                  2'b00;

// instructions offsets					
	always @(*) begin
			offset_inst0 =2'b0;
			offset_inst1 =2'b0;
			offset_inst2 =2'b0;
			offset_inst3 =2'b0;
		if (offset == 2'b00) begin
			offset_inst0 =2'b00;
			offset_inst1 =2'b01;
			offset_inst2 =2'b10;
			offset_inst3 =2'b11;
		end
		else if (offset == 2'b01) begin
			offset_inst0 =2'b01;
			offset_inst1 =2'b10;
			offset_inst2 =2'b11;
			offset_inst3 =2'b00;
		end
		else if (offset == 2'b10) begin
			offset_inst0 =2'b10;
			offset_inst1 =2'b11;
			offset_inst2 =2'b00;
			offset_inst3 =2'b01;	
		end
		else begin // offset = 11 
			offset_inst0 =2'b11;
			offset_inst1 =2'b00;
			offset_inst2 =2'b01;
			offset_inst3 =2'b10;
		end
	end
	
	
	
 always @(posedge clk,posedge reset) begin
    if (reset) begin 
        offset = 2'b00;
        reg31_address = 10'b0;
    end 
	else if(!hit && is_branchexe)begin
        offset = jump_address[1:0];
    end
     else if (stall | stall_in) begin 
				offset = offset;
				reg31_address = reg31_address;
     end
    else if (new_offset_bit) begin
            offset = jump_address[1:0];
            if (is_jal) begin 
                reg31_address = jal_next_pc;
        end
        //else if (is_jal) begin 
        //reg31_address = jal_next_pc;

    end
end

reg optimize_valid; 
 always @(posedge clk,posedge reset) begin	
    if (reset) begin 
        optimized_bit_reg = 1'b0;
    end 
	 else if(!(hit) && (is_branchexe))begin
		 optimized_bit_reg = 1'b0;
	 end
	  else if (stall | stall_in) begin 
 	    optimized_bit_reg = optimized_bit_reg;
     end
	else if (optimize_valid) begin 
	    optimized_bit_reg = optimized_bit;
	end
end


reg [4:0] jr_rd_old; 
 always @(posedge clk,posedge reset) begin	
    if (reset) begin 
        jr_rd_old <= 5'b0;
    end 
	 else if (stall | stall_in) begin 
	 	    jr_rd_old <= jr_rd_old;
     end
	else begin 
	    jr_rd_old <= jr_rd;
	end
end



// flush signals 
 always @(*) begin
	flush0 = 1'b0;
	flush1 = 1'b0;
	flush2 = 1'b0;
	flush3 = 1'b0;
 if (is_jump0 | is_jr_r31_0 | is_jr_not_r31_0) begin 
		flush0 = 1'b1;
		flush1 = 1'b1;
		flush2 = 1'b1;
		flush3 = 1'b1;
	end
	else if((is_branch0 && prediction[0]) | is_jal0 ) begin 
		flush1 = 1'b1;
		flush2 = 1'b1;
		flush3 = 1'b1;
	end
	else if (is_jump1 |is_jr_r31_1 | is_jr_not_r31_1)begin 
		flush1 = 1'b1;
		flush2 = 1'b1;
		flush3 = 1'b1;
	end
	
	else if((is_branch1 && prediction[1]) | is_jal1) begin 
		flush2 = 1'b1;
		flush3 = 1'b1;
	end
	else if(is_jump2 | is_jr_r31_2 | is_jr_not_r31_2) begin 
		flush2 = 1'b1;
		flush3 = 1'b1;
	end
	
	else if((is_branch2 && prediction[2]) | is_jal2 ) begin 
		flush3 = 1'b1;
	end 
	
	else if(is_jump3 | is_jr_r31_3 | is_jr_not_r31_3) begin 
		flush3 = 1'b1;
	end 
end
	
/************************************************************************************************************************/

	assign addi = {6'b001000, 5'b11111, 5'b0, 6'b0,jal_next_pc};  //addi r31,r0,imm => imm = pc of next instruction; 

	assign new_branch_inst0 = {instruction0[31:16],5'b0, prediction[0], branch_return_address[9:0]};  // beq , bnq
	assign new_branch_inst1 = {instruction1[31:16],5'b0, prediction[1], branch_return_address[9:0]};  // beq , bnq
	assign new_branch_inst2 = {instruction2[31:16],5'b0, prediction[2], branch_return_address[9:0]};  // beq , bnq
	assign new_branch_inst3 = {instruction3[31:16],5'b0, prediction[3], branch_return_address[9:0]};  // beq , bnq

	reg test,test11111111,test222222222;
	reg [3:0] test_fetch ; 
 always @(*) begin
	jump_address = 10'b0;
	branch_return_address = 10'b0;
	new_offset_bit = 1'b0;
	stall = 1'b0;
	stall_jr = 1'b0;
	optimized_bit = optimized_bit_reg;
	jal_next_pc = reg31_address;
	optimize_valid = 1'b0;

	test_fetch = 4'b0;

	test = 1'b0;
	
	test11111111 = 1'b0;
	test222222222 = 1'b0;

	
	
	/////////////////////////////jr
	
	
		//////////////////////
		if (is_jr_not_r31 | (is_jr_r31 && !optimized_bit)) begin
		if (valid_index_prf_in) begin 
			if (!valid_bit) begin 
				stall_jr = 1'b1; 
			end
			else begin
				jump_address = jr_address_prf[9:0];
				stall_jr = 1'b0;
				test222222222 = 1'b1;
			end
		end
		else begin 
				stall_jr = 1'b1; 	
		end
end
	/////////////////////////

	///////////////////////////////////////

	
	if ((rd0_fetch == 5'b11111) && write_on_rd0_fetch && (!is_jal0) && (!is_jr_r31_0)) begin 
		optimized_bit = 1'b0;
		optimize_valid = 1'b1;
	end 
	if ((rd1_fetch == 5'b11111) && write_on_rd1_fetch && (!is_jal1) && !(is_jr_r31_0 | is_jr_r31_1)) begin // the oring in this case if there was an instruction writs on reg_31 ... it should not change the value of the optimized bit becauseit will be discarded 
		optimized_bit = 1'b0;														// another thing if there was jal instruction under jr ... it should not change the value of the optimized bit becauseit will be discarded 
		optimize_valid = 1'b1;														// this is important in the case there is no jr instruction and there was jal it shouldnt enter this block and change the value of the optimized_bit to zero  
	end 																			
	if ((rd2_fetch == 5'b11111) && write_on_rd2_fetch && (!is_jal2) && !(is_jr_r31_0 | is_jr_r31_1 | is_jr_r31_2)) begin
		optimized_bit = 1'b0;
		optimize_valid = 1'b1;
	end 
	if ((rd3_fetch == 5'b11111) && write_on_rd3_fetch && (!is_jal3) && !(is_jr_r31_0 | is_jr_r31_1 | is_jr_r31_2 | is_jr_r31_3)) begin 
		optimized_bit = 1'b0;
		optimize_valid = 1'b1;
	end 
	
	
	
	/////////////////////////////////////////////

	
	if (is_jr_not_r31 | (is_jr_r31 && !optimized_bit)) begin 
	
		if ((rd0_decode == jr_rd) && write_on_rd0_decode) begin 
			test11111111 = 1'b1;
			stall_jr = 1'b1; // to memory / pc 
		end 
		if ((rd1_decode == jr_rd) && write_on_rd1_decode) begin 
			stall_jr = 1'b1;
		end 
		if ((rd2_decode == jr_rd) && write_on_rd2_decode) begin 
			stall_jr = 1'b1;
		end 
		if ((rd3_decode == jr_rd) && write_on_rd3_decode) begin 
			stall_jr = 1'b1;
		end 

		
		/////////////////////////////////test
		

		if ((rd0_fetch  == jr_rd) && (!(jr_rd_old == 5'b11111)) && write_on_rd0_fetch && !(is_jr_not_r31_0 | is_jr_r31_0)) begin    // test .... there is no need to check  (is_jr_r31_0 && !optimized_bit) because it in the main condition in the 
			stall_jr = 1'b1;
			test_fetch = 4'b0001;
		end

		if ((rd1_fetch  == jr_rd) && (!(jr_rd_old == 5'b11111)) && write_on_rd1_fetch && !((is_jr_not_r31_0 | is_jr_r31_0) | (is_jr_not_r31_1 | is_jr_r31_1))) begin /// the oring between jumps to prevent instructions under jr instructions to avtivate the stall_jr signal if they write on the jr (register) 
			stall_jr = 1'b1;
						test_fetch = 4'b0010;
		end 
		if ((rd2_fetch  == jr_rd) && (!(jr_rd_old == 5'b11111)) && write_on_rd2_fetch && !((is_jr_not_r31_0 | is_jr_r31_0) | (is_jr_not_r31_1 | is_jr_r31_1) | (is_jr_not_r31_2 | is_jr_r31_2))) begin 
			stall_jr = 1'b1;
					test_fetch = 4'b0100;

		end 
		
		if ((rd3_fetch  == jr_rd) && (!(jr_rd_old == 5'b11111)) && write_on_rd3_fetch && !((is_jr_not_r31_0 | is_jr_r31_0) | (is_jr_not_r31_1 | is_jr_r31_1) | (is_jr_not_r31_2 | is_jr_r31_2) | (is_jr_not_r31_3 | is_jr_r31_3))) begin 
			stall_jr = 1'b1;
						test_fetch = 4'b1000;

		end 
	end

	
	/////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	 //Branch is resolved
    if (!(hit) && (is_branchexe)) begin
        jump_address = Address_Branch; 
		  new_offset_bit = 1'b1;
    end 
	 else begin  
    // way0
	// branch 0 
	if (is_branch0) begin
        if (prediction[0]) begin  
			new_offset_bit = 1'b1;
			jump_address = {pc_in,2'b00} + branch_offset0 + offset_inst0 + 10'b1;  // np pc increment because the branch will be in the same pc
            if (offset == 2'b11) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst1; // +10'b100 (pcpc increment) because the next instruction in the next pcpc
			end
            else begin 
                branch_return_address = {pc_in,2'b00} + offset_inst1; // there is no +10'b100 (pcpc increment) because the next instruction in the same pcpc
			end
        end
        else begin 
				branch_return_address = {pc_in,2'b00} + branch_offset0 + 2'b1 + offset_inst0;
		end 
    end 
	
	// jump 0 
	else if (is_jump0) begin 
		new_offset_bit = 1'b1;
		jump_address = jump_target0;
	end
	
	// jr 0  .. r31 & optimized 
	else if (is_jr_r31_0 && optimized_bit) begin 
			new_offset_bit = 1'b1;
			jump_address = reg31_address;
	end
	// jr 0  ..not r31 or r31 & not optimized 
	else if (is_jr_not_r31_0 | (is_jr_r31_0 && !optimized_bit)) begin 
		new_offset_bit = 1'b1;
		stall = stall_jr;
	end
	
	// jal 0
	else if (is_jal0) begin
			new_offset_bit = 1'b1;
			optimize_valid = 1'b1;
			optimized_bit = 1'b1;
			jump_address = jump_target0;
            if (offset == 2'b11) begin
                jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst1; // +10'b100 (pc increment) because the next instruction in the next pc
			end
            else begin 
                jal_next_pc = {pc_in,2'b00} + offset_inst1; // there is no +10'b100 (pc increment) because the next instruction in the same pc
			end
    end	
	
	
	//way 1
   
if (!((is_branch0 && prediction[0]) | is_jump0 | is_jr_r31_0 | is_jr_not_r31_0 | is_jal0)) begin  	
	// branch 1 
	 if (is_branch1) begin
        if (prediction[1]) begin 
			new_offset_bit = 1'b1;
            if (offset == 2'b11) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst2;
				jump_address = {pc_in,2'b00} + 10'b100 + branch_offset1 + offset_inst1 + 10'b1; 
			end
            else if (offset == 2'b10) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst2; 
				jump_address = {pc_in,2'b00} + branch_offset1 + offset_inst1 + 10'b1;
			end
            else begin 
                branch_return_address = {pc_in,2'b00} + offset_inst2;
				jump_address = {pc_in,2'b00} + branch_offset1 + offset_inst1 + 10'b1; 
			end
        end 
        else begin // not taken .. prediction = 0 
            if (offset == 2'b11) begin
				branch_return_address = {pc_in,2'b00} + 10'b100 + branch_offset1 + offset_inst1 + 10'b1; 
			end
            else if (offset == 2'b10) begin
				branch_return_address = {pc_in,2'b00} + branch_offset1 + offset_inst1 + 10'b1;
			end
            else begin 
				branch_return_address = {pc_in,2'b00} + branch_offset1 + offset_inst1 + 10'b1; 
			end
        end
    end
	// jump 1 
	else if (is_jump1) begin 
		new_offset_bit = 1'b1;
		jump_address = jump_target1;
	end

	// jr 1  .. r31 & optimized 
	else if (is_jr_r31_1 && optimized_bit) begin 
			new_offset_bit = 1'b1;
			jump_address = reg31_address;
	end
	// jr 1  ..not r31 or r31 & not optimized 
	else if (is_jr_not_r31_1 | (is_jr_r31_1 && !optimized_bit)) begin 
		new_offset_bit = 1'b1;
		stall = stall_jr;
	end
	
	// jal 1 
    else if (is_jal1) begin
			new_offset_bit = 1'b1;
			optimized_bit = 1'b1;
			optimize_valid = 1'b1;
			jump_address = jump_target1;
            if (offset == 2'b11) begin
                jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst2;
			end
            else if (offset == 2'b10) begin
                jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst2; 
			end
            else begin 
                jal_next_pc = {pc_in,2'b00} + offset_inst2;
			end
    end
end

	 //way 2	 

   
if (!((is_branch0 && prediction[0]) | is_jump0 | is_jr_r31_0 | is_jr_not_r31_0 | is_jal0 | 
      (is_branch1 && prediction[1]) | is_jump1 | is_jr_r31_1 | is_jr_not_r31_1 | is_jal1)) begin 
	 
	// In jump address calculations, the PC will be incremented if the offset is 10 or 11,
	// as the branch instruction will be at the new PC.
	
	// branch 2 
     if (is_branch2) begin  
        if (prediction[2]) begin 
		  new_offset_bit = 1'b1;
			if (offset == 2'b11) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst3; // + 10'b1 next offset 
				jump_address = {pc_in,2'b00} + 4'b100 + branch_offset2 + offset_inst2 + 10'b1;
			end
			else if (offset == 2'b10) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst3;
				jump_address = {pc_in,2'b00} + 4'b100 + branch_offset2 + offset_inst2 + 10'b1; 
			end
			else if (offset == 2'b01) begin
                branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst3; 
				jump_address = {pc_in,2'b00} + branch_offset2 + offset_inst2 + 10'b1;
			end
			else begin 
                branch_return_address = {pc_in,2'b00} + offset_inst3; 
				jump_address = {pc_in,2'b00} + branch_offset2 + offset_inst2 + 10'b1;
			end
		end 
        else begin // not taken .. prediction = 0 
			if (offset == 2'b11) begin
				branch_return_address = {pc_in,2'b00} + 4'b100 + branch_offset2 + offset_inst2 + 10'b1;
			end
			else if (offset == 2'b10) begin
				branch_return_address = {pc_in,2'b00} + 4'b100 + branch_offset2 + offset_inst2 + 10'b1; 
			end
			else if (offset == 2'b01) begin
				branch_return_address = {pc_in,2'b00} + branch_offset2 + offset_inst2 + 10'b1;
			end
			else begin 
				branch_return_address = {pc_in,2'b00} + branch_offset2 + offset_inst2 + 10'b1;
			end
        end
	end
	// jump 2 
	else if (is_jump2) begin 
		jump_address = jump_target2;
		new_offset_bit = 1'b1;
	end
	
	// jr 2  .. r31 & optimized 
	else if (is_jr_r31_2 && optimized_bit) begin 
			jump_address = reg31_address;
			new_offset_bit = 1'b1;
	end
	// jr 2  ..not r31 or r31 & not optimized 
	else if (is_jr_not_r31_2 | (is_jr_r31_2 && !optimized_bit)) begin 
		stall = stall_jr;
		new_offset_bit = 1'b1;
	end
	// jr 2  .. r31 & optimized 
    else if (is_jal2) begin   
			new_offset_bit = 1'b1;
			optimized_bit = 1'b1;
			optimize_valid = 1'b1;
			jump_address = jump_target2;
			if (offset == 2'b11) begin
                jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst3; // + 10'b1 next offset 
			end
			else if (offset == 2'b10) begin
                jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst3;
			end
			else if (offset == 2'b01) begin
				jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst3; 
			end
			else begin  // offset == 2'b00   .. no pc increment 
               // jal_next_pc = {pc_in,2'b00} + offset_inst3 + 10'b1; 
			    jal_next_pc = {pc_in,2'b00} + offset_inst3;
			end
	end 	
end
	
	
	//way 3
 
if (!((is_branch0 && prediction[0]) | is_jump0 | is_jr_r31_0 | is_jr_not_r31_0 | is_jal0 | 
	   (is_branch1 && prediction[1]) | is_jump1 | is_jr_r31_1 | is_jr_not_r31_1 | is_jal1 | 
	   (is_branch2 && prediction[2]) | is_jump2 | is_jr_r31_2 | is_jr_not_r31_2 | is_jal2)) begin 
 
	// branch 3 
	if (is_branch3) begin
			if(prediction[3]) begin
				new_offset_bit = 1'b1;
				if (offset == 2'b00) begin // the branch located in the same pc
					jump_address = {pc_in,2'b00} + branch_offset3 + offset_inst3 + 10'b1;   // no pc increment
					branch_return_address = {pc_in,2'b00} + offset_inst3 + 10'b1; // + 10'b1 next offset 
				end
				else begin // the branch located in new pc 
					jump_address = {pc_in,2'b00} + 10'b100 + branch_offset3 + offset_inst3 + 10'b1;
					branch_return_address = {pc_in,2'b00} + 10'b100 + offset_inst3 + 10'b1; // + 10'b1 next offset 
				end 
			end
			else begin
				if (offset == 2'b00) begin // the branch located in the same pc
					branch_return_address = {pc_in,2'b00} + branch_offset3 + offset_inst3 + 10'b1;   // no pc increment
				end
				else begin // the branch located in new pc 
					branch_return_address = {pc_in,2'b00} + 10'b100 + branch_offset3 + offset_inst3 + 10'b1;
				end
			end
	end
	
		// jump 3 
		else if (is_jump3) begin 
			jump_address = jump_target3;
			new_offset_bit = 1'b1;
		end
			
		// jr 3  .. r31 & optimized 
		else if (is_jr_r31_3 && optimized_bit) begin 
				jump_address = reg31_address;
				new_offset_bit = 1'b1;
		end
		// jr 3  ..not r31 or r31 & not optimized 
		else if (is_jr_not_r31_3 | (is_jr_r31_3 && !optimized_bit)) begin 
		test = 1'b1;
			stall = stall_jr;
			new_offset_bit = 1'b1;
		end
		
		// jal 3 
    else if (is_jal3) begin   
			new_offset_bit = 1'b1;
			optimized_bit = 1'b1;
			optimize_valid = 1'b1;
			jump_address = jump_target3;
         jal_next_pc = {pc_in,2'b00} + 10'b100 + offset_inst3 + 1'b1; // + 10'b1 next offset 
		end
	end
	end
		if(!(hit) && (is_branchexe))begin
		optimized_bit = 1'b0;
		optimize_valid = 1'b1;
	end
end

	
endmodule