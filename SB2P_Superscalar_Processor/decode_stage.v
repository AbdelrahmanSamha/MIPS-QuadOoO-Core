module decode_stage(clk, rst,

    instruction0, instruction1, instruction2, instruction3,
	 
	 rat_inst0, rat_inst1 , rat_inst2 , rat_inst3,
	 
	 rat_read_index0, rat_read_index1, rat_read_index2,
    rat_read_index3, rat_read_index4, rat_read_index5,
    rat_read_index6, rat_read_index7, rat_read_index8,
    rat_read_index9, rat_read_index10, rat_read_index11,
	 
    rat_read_data0, rat_read_data1, rat_read_data2,
    rat_read_data3, rat_read_data4, rat_read_data5,
    rat_read_data6, rat_read_data7, rat_read_data8,
    rat_read_data9, rat_read_data10, rat_read_data11,
	 
	 write_on_rd0,write_on_rd1,write_on_rd2,write_on_rd3,
	 match0_rd1,match0_rd2,match0_rd3,match0_rs1a,match0_rs1b,
	 match0_rs2a,match0_rs2b,match0_rs3a,match0_rs3b,
	 match1_rd2,match1_rd3,match1_rs2a,match1_rs2b,match1_rs3a,match1_rs3b, 
	 match2_rd3,match2_rs3a,match2_rs3b,
	 
	 rd0,rd1,rd2,rd3,
	 
	 valid_word,
	 BID0,BID1,BID2,BID3,
	 is_branch,
	 available_id,
	 
	 branch_resolved,
	 BID_resolve,
	 hit,
	 partofbranch0,partofbranch1,partofbranch2,partofbranch3,
	 
	 is_branch0,is_branch1,is_branch2,is_branch3,
	 
	 control_0, control_1, control_2, control_3,
	 
	 imm0, imm1, imm2, imm3,
	 
	 h_in, m_in, l_in,
	 rd0_rename, rd1_rename, rd2_rename, rd3_rename,
	 iswrite_rename0, iswrite_rename1, iswrite_rename2, iswrite_rename3,
	 physicalway0_rename, physicalway1_rename, physicalway2_rename, physicalway3_rename,
	 
	 stall_in,
	 
	 BIDs_flush,
	 stall_freeid
	 
);

		input clk, rst;
		input [6:0] BIDs_flush;
		
		input wire [31:0] instruction0;  // Instruction 0 (32-bit)
		input wire [31:0] instruction1;  // Instruction 1 (32-bit)
		input wire [31:0] instruction2;  // Instruction 2 (32-bit)
		input wire [31:0] instruction3;  // Instruction 3 (32-bit)
		input stall_in;
		input [1:0] h_in, m_in, l_in;// input from priority table
		
		//to forward Physical indecies from the rename stage. 
		input [4:0] rd0_rename, rd1_rename, rd2_rename, rd3_rename;
		input [5:0] physicalway0_rename, physicalway1_rename, physicalway2_rename, physicalway3_rename;
	   input	   	iswrite_rename0, iswrite_rename1, iswrite_rename2, iswrite_rename3;
		
		input[5:0]   rat_read_data0, rat_read_data1, rat_read_data2,
						 rat_read_data3, rat_read_data4, rat_read_data5,
						 rat_read_data6, rat_read_data7, rat_read_data8,
						 rat_read_data9, rat_read_data10, rat_read_data11;
						 
		output[4:0]  rat_read_index0, rat_read_index1, rat_read_index2,
						 rat_read_index3, rat_read_index4, rat_read_index5,
						 rat_read_index6, rat_read_index7, rat_read_index8,
						 rat_read_index9, rat_read_index10, rat_read_index11;
		output stall_freeid;
		output write_on_rd0,write_on_rd1,write_on_rd2,write_on_rd3,
				 match0_rd1,match0_rd2,match0_rd3,match0_rs1a,match0_rs1b,
		       match0_rs2a,match0_rs2b,match0_rs3a,match0_rs3b,
			    match1_rd2,match1_rd3,match1_rs2a,match1_rs2b,match1_rs3a,match1_rs3b, 
				 match2_rd3,match2_rs3a,match2_rs3b;
		
		output [4:0] rd0,rd1,rd2,rd3;
	   
		output [17:0] rat_inst0, rat_inst1 , rat_inst2 , rat_inst3; // only registers {d, s1, s2} 
		
		output [3:0] valid_word ;		
		
		wire [5:0] opcode0 ,opcode1 , opcode2 ,opcode3 ; 
			
		wire [5:0] sw_inst = 6'h2b;
		wire [5:0] beq_inst = 6'h4; 
		wire [5:0] bne_inst = 6'h5; 

		wire [4:0] rs0a,rs0b,rs1a,rs1b,rs2a,rs2b,rs3a,rs3b;
		wire [5:0]funct0, funct1, funct2, funct3;
	 	assign opcode0 = instruction0[31:26]; 
		assign opcode1 = instruction1[31:26]; 
		assign opcode2 = instruction2[31:26]; 
		assign opcode3 = instruction3[31:26]; 	 
	 
	 
	 	output [15:0] imm0, imm1, imm2, imm3; 
		
		assign imm0 = instruction0[15:0]; 
		assign imm1 = instruction1[15:0]; 
		assign imm2 = instruction2[15:0]; 
		assign imm3 = instruction3[15:0]; 	
		
		
	 
	 
	 
	 // Decode fields from instructions
    assign rd0 = instruction0[25:21];
    assign rs0a = instruction0[20:16];
    assign rs0b = instruction0[15:11];

    assign rd1 = instruction1[25:21];
    assign rs1a = instruction1[20:16];
    assign rs1b = instruction1[15:11];

    assign rd2 = instruction2[25:21];
    assign rs2a = instruction2[20:16];
    assign rs2b = instruction2[15:11];

    assign rd3 = instruction3[25:21];
    assign rs3a = instruction3[20:16];
    assign rs3b = instruction3[15:11];
		
	 // rename 
		 
		assign rat_read_index0 = rd0;
		assign rat_read_index1 = rs0a; 
		assign rat_read_index2 = rs0b;
		assign rat_read_index3 = rd1;
		assign rat_read_index4 = rs1a;
		assign rat_read_index5 = rs1b;
		assign rat_read_index6 = rd2;
		assign rat_read_index7 = rs2a;
		assign rat_read_index8 = rs2b;
		assign rat_read_index9 = rd3;
		assign rat_read_index10 = rs3a;
		assign rat_read_index11 = rs3b; 
		
		
		 
		  assign write_on_rd0 = ((opcode0 == sw_inst) | (opcode0 == beq_inst) | (opcode0 == bne_inst) | !valid_word[0]) ? 1'b0 : 1'b1; 
		  assign write_on_rd1 = ((opcode1 == sw_inst) | (opcode1 == beq_inst) | (opcode1 == bne_inst) | !valid_word[1]) ? 1'b0 : 1'b1; 
		  assign write_on_rd2 = ((opcode2 == sw_inst) | (opcode2 == beq_inst) | (opcode2 == bne_inst) | !valid_word[2]) ? 1'b0 : 1'b1;
		  assign write_on_rd3 = ((opcode3 == sw_inst) | (opcode3 == beq_inst) | (opcode3 == bne_inst) | !valid_word[3]) ? 1'b0 : 1'b1; 
		    
			
		/// vlaid bit for instructions 
	
		
		assign valid_word[0] = ((opcode0 ==6'b0)&& (funct0 == 6'b0)) ? 1'b0 : 1'b1; 
		assign valid_word[1] = ((opcode1 ==6'b0)&& (funct1 == 6'b0)) ? 1'b0 : 1'b1; 
		assign valid_word[2] = ((opcode2 ==6'b0)&& (funct2 == 6'b0)) ? 1'b0 : 1'b1;
		assign valid_word[3] = ((opcode3 ==6'b0)&& (funct3 == 6'b0)) ? 1'b0 : 1'b1; 
		 	  

			
			
		  
						
		  // inst0
		assign match0_rd1  = (write_on_rd0) ? (rd0 == rd1)  : 1'b0;  
		assign match0_rd2  = (write_on_rd0) ? (rd0 == rd2)  : 1'b0;  
		assign match0_rd3  = (write_on_rd0) ? (rd0 == rd3)  : 1'b0;  
		assign match0_rs1a = (write_on_rd0) ? (rd0 == rs1a) : 1'b0;  
		assign match0_rs1b = (write_on_rd0) ? (rd0 == rs1b) : 1'b0;  
		assign match0_rs2a = (write_on_rd0) ? (rd0 == rs2a) : 1'b0;  
		assign match0_rs2b = (write_on_rd0) ? (rd0 == rs2b) : 1'b0;  
		assign match0_rs3a = (write_on_rd0) ? (rd0 == rs3a) : 1'b0;  
		assign match0_rs3b = (write_on_rd0) ? (rd0 == rs3b) : 1'b0;  


		  //inst1
			assign match1_rd2  = (write_on_rd1) ? (rd1 == rd2)  : 1'b0;  
			assign match1_rd3  = (write_on_rd1) ? (rd1 == rd3)  : 1'b0;  
			assign match1_rs2a = (write_on_rd1) ? (rd1 == rs2a) : 1'b0;  
			assign match1_rs2b = (write_on_rd1) ? (rd1 == rs2b) : 1'b0;  
			assign match1_rs3a = (write_on_rd1) ? (rd1 == rs3a) : 1'b0;  
			assign match1_rs3b = (write_on_rd1) ? (rd1 == rs3b) : 1'b0;  

		   
		  //inst 2 
			assign match2_rd3  = (write_on_rd2) ? (rd2 == rd3) : 1'b0;  
			assign match2_rs3a = (write_on_rd2) ? (rd2 == rs3a) : 1'b0;  
			assign match2_rs3b = (write_on_rd2) ? (rd2 == rs3b) : 1'b0;  


			//////////////// rename 
			wire [5:0] RATinst0rd, RATinst0rs1, RATinst0rs2 , RATinst1rd, RATinst1rs1, RATinst1rs2, RATinst2rd, RATinst2rs1, RATinst2rs2, RATinst3rd, RATinst3rs1, RATinst3rs2;
			
			wire [2:0] RATinst0rdmux_sel;
			wire [2:0] RATinst0rs1mux_sel;
			wire [2:0] RATinst0rs2mux_sel;
			
			wire [2:0] RATinst1rdmux_sel;
			wire [2:0] RATinst1rs1mux_sel;
			wire [2:0] RATinst1rs2mux_sel;
			
			wire [2:0] RATinst2rdmux_sel;
			wire [2:0] RATinst2rs1mux_sel;
			wire [2:0] RATinst2rs2mux_sel;
			
			wire [2:0] RATinst3rdmux_sel;
			wire [2:0] RATinst3rs1mux_sel;
			wire [2:0] RATinst3rs2mux_sel;
			
	assign RATinst0rdmux_sel = ((rd0 == rd3_rename) && iswrite_rename3) ? 3'b100 : 
							((rd0 == rd2_rename) && iswrite_rename2) ? 3'b011 : 
							((rd0 == rd1_rename) && iswrite_rename1) ? 3'b010 : 
							((rd0 == rd0_rename) && iswrite_rename0) ? 3'b001 : 
							3'b000;
	
	assign RATinst0rs1mux_sel = ((rs0a == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs0a == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs0a == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs0a == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	assign RATinst0rs2mux_sel = ((rs0b == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs0b == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs0b == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs0b == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	// Ternary operations for RATinst1 mux selectors
	assign RATinst1rdmux_sel = ((rd1 == rd3_rename) && iswrite_rename3) ? 3'b100 : 
							((rd1 == rd2_rename) && iswrite_rename2) ? 3'b011 : 
							((rd1 == rd1_rename) && iswrite_rename1) ? 3'b010 : 
							((rd1 == rd0_rename) && iswrite_rename0) ? 3'b001 : 
							3'b000;
	
	assign RATinst1rs1mux_sel = ((rs1a == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs1a == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs1a == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs1a == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	assign RATinst1rs2mux_sel = ((rs1b == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs1b == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs1b == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs1b == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	// Ternary operations for RATinst2 mux selectors
	assign RATinst2rdmux_sel = ((rd2 == rd3_rename) && iswrite_rename3) ? 3'b100 : 
							((rd2 == rd2_rename) && iswrite_rename2) ? 3'b011 : 
							((rd2 == rd1_rename) && iswrite_rename1) ? 3'b010 : 
							((rd2 == rd0_rename) && iswrite_rename0) ? 3'b001 : 
							3'b000;
	
	assign RATinst2rs1mux_sel = ((rs2a == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs2a == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs2a == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs2a == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	assign RATinst2rs2mux_sel = ((rs2b == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs2b == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs2b == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs2b == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	// Ternary operations for RATinst3 mux selectors
	assign RATinst3rdmux_sel = ((rd3 == rd3_rename) && iswrite_rename3) ? 3'b100 : 
							((rd3 == rd2_rename) && iswrite_rename2) ? 3'b011 : 
							((rd3 == rd1_rename) && iswrite_rename1) ? 3'b010 : 
							((rd3 == rd0_rename) && iswrite_rename0) ? 3'b001 : 
							3'b000;
	
	assign RATinst3rs1mux_sel = ((rs3a == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs3a == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs3a == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs3a == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
	
	assign RATinst3rs2mux_sel = ((rs3b == rd3_rename) && iswrite_rename3) ? 3'b100 : 
								((rs3b == rd2_rename) && iswrite_rename2) ? 3'b011 : 
								((rs3b == rd1_rename) && iswrite_rename1) ? 3'b010 : 
								((rs3b == rd0_rename) && iswrite_rename0) ? 3'b001 : 
								3'b000;
			
			
			MUX5to1 #(6) RATinst0rdmux (.in0(rat_read_data0) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst0rdmux_sel), .out(RATinst0rd));
			MUX5to1 #(6) RATinst0rs1mux(.in0(rat_read_data1) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst0rs1mux_sel), .out(RATinst0rs1));
			MUX5to1 #(6) RATinst0rs2mux(.in0(rat_read_data2) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst0rs2mux_sel), .out(RATinst0rs2));
			
			MUX5to1 #(6) RATinst1rdmux (.in0(rat_read_data3) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst1rdmux_sel), .out(RATinst1rd));
			MUX5to1 #(6) RATinst1rs1mux(.in0(rat_read_data4) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst1rs1mux_sel), .out(RATinst1rs1));
			MUX5to1 #(6) RATinst1rs2mux(.in0(rat_read_data5) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst1rs2mux_sel), .out(RATinst1rs2));
			
			MUX5to1 #(6) RATinst2rdmux (.in0(rat_read_data6) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst2rdmux_sel), .out(RATinst2rd));
			MUX5to1 #(6) RATinst2rs1mux(.in0(rat_read_data7) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst2rs1mux_sel), .out(RATinst2rs1));
			MUX5to1 #(6) RATinst2rs2mux(.in0(rat_read_data8) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst2rs2mux_sel), .out(RATinst2rs2));
			
			MUX5to1 #(6) RATinst3rdmux (.in0(rat_read_data9) ,.in1(physicalway0_rename),.in2(physicalway1_rename), .in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst3rdmux_sel), .out(RATinst3rd));
			MUX5to1 #(6) RATinst3rs1mux(.in0(rat_read_data10) ,.in1(physicalway0_rename),.in2(physicalway1_rename),.in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst3rs1mux_sel), .out(RATinst3rs1));
			MUX5to1 #(6) RATinst3rs2mux(.in0(rat_read_data11) ,.in1(physicalway0_rename),.in2(physicalway1_rename),.in3(physicalway2_rename),.in4(physicalway3_rename), .sel(RATinst3rs2mux_sel), .out(RATinst3rs2));
			
			assign rat_inst0 = {RATinst0rd, RATinst0rs1, RATinst0rs2};
			assign rat_inst1 = {RATinst1rd, RATinst1rs1, RATinst1rs2};
			assign rat_inst2 = {RATinst2rd, RATinst2rs1, RATinst2rs2};
			assign rat_inst3 = {RATinst3rd, RATinst3rs1, RATinst3rs2};
			
		//branch assigning IDs, assumption is based that there can only be a single branch per cycle. 
		output [1:0]available_id;
		wire [1:0]active_branch;
		output is_branch0;
		output is_branch1;
		output is_branch2;
		output is_branch3;
		output is_branch;
		assign is_branch= (is_branch0 | is_branch1 | is_branch2 | is_branch3) ? 1'b1:1'b0;
		
		
		
		 

		input branch_resolved; // not connected 
		input [1:0] BID_resolve; // not connected 
		
		
		output [5:0] control_0, control_1, control_2, control_3;
		
		assign is_branch0 = (control_0 [5:4] == 2'b10) ? 1'b1 : 1'b0; 
		assign is_branch1 = (control_1 [5:4] == 2'b10) ? 1'b1 : 1'b0; 
		assign is_branch2 = (control_2 [5:4] == 2'b10) ? 1'b1 : 1'b0;
		assign is_branch3 = (control_3 [5:4] == 2'b10) ? 1'b1 : 1'b0;	

		output [1:0] BID0;
		output [1:0] BID1;
		output [1:0] BID2;
		output [1:0] BID3;
		

		wire [1:0] acive_branch_exe;
		
		assign acive_branch_exe = (BIDs_flush[6] && BIDs_flush[active_branch]) ? BIDs_flush[5:4] : active_branch;
		 
		
		assign BID0 = (is_branch0) ? available_id: acive_branch_exe;
      assign BID1 = (is_branch0 | is_branch1) ? available_id: acive_branch_exe;
      assign BID2 = (is_branch0 | is_branch1 | is_branch2) ? available_id: acive_branch_exe;
      assign BID3 = (is_branch0 | is_branch1 | is_branch2 | is_branch3) ? available_id: acive_branch_exe;
		
		output partofbranch0; 
		output partofbranch1;
		output partofbranch2; 
		output partofbranch3;
		
		wire speculation; 
		wire id_mux_asserted0, id_mux_asserted1, id_mux_asserted2, id_mux_asserted3; 
		assign speculation = (active_branch != 2'b00);
		assign id_mux_asserted0 = (is_branch0);
		assign id_mux_asserted1 = (is_branch0 | is_branch1);
		assign id_mux_asserted2 = (is_branch0 | is_branch1 | is_branch2 );
		assign id_mux_asserted3 = (is_branch0 | is_branch1 | is_branch2 | is_branch3);
		
		
		assign partofbranch0 =  ((speculation & write_on_rd0) | ( id_mux_asserted0 & write_on_rd0));
		assign partofbranch1 =  ((speculation & write_on_rd1) | ( id_mux_asserted1 & write_on_rd1));
		assign partofbranch2 =  ((speculation & write_on_rd2) | ( id_mux_asserted2 & write_on_rd2));
		assign partofbranch3 =  ((speculation & write_on_rd3) | ( id_mux_asserted3 & write_on_rd3));
	
		
		
		
		assign funct0 = instruction0[5:0];
		assign funct1 = instruction1[5:0];
		assign funct2 = instruction2[5:0];
		assign funct3 = instruction3[5:0];
		
		
				// free_branch_id module 
		input hit;
		free_branch_id FREEID(.clk(clk),.rst(rst),.stall(stall_freeid),.hit(hit),
							.available_id(available_id), .active_branch(active_branch),
							.is_branch3(is_branch3),.is_branch2(is_branch2),.is_branch1(is_branch1),.is_branch0(is_branch0),.H(h_in),
							.M(m_in),.L(l_in),.BID_resolve(BID_resolve),.branch_resolved(branch_resolved),
							.stall_in(stall_in),
							.BIDs_flush(BIDs_flush)
							);
		
		//control module 
		
		Control_Unit Control_Unit_decode0(.opcode(opcode0),.funct(funct0),.control(control_0));
		
		Control_Unit Control_Unit_decode1(.opcode(opcode1),.funct(funct1),.control(control_1));
		
		Control_Unit Control_Unit_decode2(.opcode(opcode2),.funct(funct2),.control(control_2));
		
		Control_Unit Control_Unit_decode3(.opcode(opcode3),.funct(funct3),.control(control_3));
		
endmodule