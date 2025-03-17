module ReadStage (
    //==================================================================
    // Inputs from the readpipe
    //==================================================================
    
    // --- ALU0 Inputs ---
    input [4:0]  alu0_ROBentry_ReadS,
    input [5:0]  alu0_dest_ReadS,
    input [3:0]  alu0_operation_ReadS,
    input [5:0]  alu0_s1_index_ReadS,
    input [1:0]  alu0_bid_ReadS,
    input        alu0_is_Itype_ReadS,
    input [1:0]  alu0_s1_alu_forwarding_ReadS,
    input [1:0]  alu0_s2_alu_forwarding_ReadS,
    input [1:0]  alu0_s1_lsu_forwarding_ReadS,
    input [1:0]  alu0_s2_lsu_forwarding_ReadS,
    input        alu0_s1_needforwarding_ReadS,
    input        alu0_s2_needforwarding_ReadS,
    input [15:0] alu0_imm16b_ReadS,

    // --- ALU1 Inputs ---
    input [4:0]  alu1_ROBentry_ReadS,
    input [5:0]  alu1_dest_ReadS,
    input [3:0]  alu1_operation_ReadS,
    input [5:0]  alu1_s1_index_ReadS,
    input [1:0]  alu1_bid_ReadS,
    input        alu1_is_Itype_ReadS,
    input [1:0]  alu1_s1_alu_forwarding_ReadS,
    input [1:0]  alu1_s2_alu_forwarding_ReadS,
    input [1:0]  alu1_s1_lsu_forwarding_ReadS,
    input [1:0]  alu1_s2_lsu_forwarding_ReadS,
    input        alu1_s1_needforwarding_ReadS,
    input        alu1_s2_needforwarding_ReadS,
    input [15:0] alu1_imm16b_ReadS,

    // --- ALU2 Inputs ---
    input [4:0]  alu2_ROBentry_ReadS,
    input [5:0]  alu2_dest_ReadS,
    input [3:0]  alu2_operation_ReadS,
    input [5:0]  alu2_s1_index_ReadS,
    input [1:0]  alu2_bid_ReadS,
    input        alu2_is_Itype_ReadS,
    input [1:0]  alu2_s1_alu_forwarding_ReadS,
    input [1:0]  alu2_s2_alu_forwarding_ReadS,
    input [1:0]  alu2_s1_lsu_forwarding_ReadS,
    input [1:0]  alu2_s2_lsu_forwarding_ReadS,
    input        alu2_s1_needforwarding_ReadS,
    input        alu2_s2_needforwarding_ReadS,
    input [15:0] alu2_imm16b_ReadS,

    

    // --- Branch Unit (BU) Inputs ---
    input [4:0]  bu_ROBentry_ReadS,
    input [2:0]  bu_operation_ReadS,
    input [9:0]  bu_imm_ReadS,
    input [1:0]  bu_BID_ReadS,
    input        bu_prediction_ReadS,
    input [5:0]  bu_s1_index_ReadS,
    input [5:0]  bu_s2_index_ReadS,
    input        bu_is_branch_ReadS,
    input        bu_is_Jr_ReadS,
    input [1:0]  bu_s1_alu_forwarding_ReadS,
    input [1:0]  bu_s2_alu_forwarding_ReadS,
    input [1:0]  bu_s1_lsu_forwarding_ReadS,
    input [1:0]  bu_s2_lsu_forwarding_ReadS,
    input        bu_s1_needforwarding_ReadS,
    input        bu_s2_needforwarding_ReadS,

    // --- LSU0 Inputs ---
    input [4:0]  lsu0_ROBentry_ReadS,
    input [1:0]  lsu0_operation_ReadS,
    input [5:0]  lsu0_Rt_index_ReadS,
    input [5:0]  lsu0_Rs_index_ReadS,
    input [1:0]  lsu0_bid_ReadS,
    input [1:0]  lsu0_Rt_alu_forwarding_ReadS,
    input [1:0]  lsu0_Rs_alu_forwarding_ReadS,
    input [1:0]  lsu0_Rt_lsu_forwarding_ReadS,
    input [1:0]  lsu0_Rs_lsu_forwarding_ReadS,
    input        lsu0_Rt_needforwarding_ReadS,
    input        lsu0_Rs_needforwarding_ReadS,
    input [15:0] lsu0_imm_ReadS,

    // --- LSU1 Inputs ---
    input [4:0]  lsu1_ROBentry_ReadS,
    input [1:0]  lsu1_operation_ReadS,
    input [5:0]  lsu1_Rt_index_ReadS,
    input [5:0]  lsu1_Rs_index_ReadS,
    input [1:0]  lsu1_bid_ReadS,
    input [1:0]  lsu1_Rt_alu_forwarding_ReadS,
    input [1:0]  lsu1_Rs_alu_forwarding_ReadS,
    input [1:0]  lsu1_Rt_lsu_forwarding_ReadS,
    input [1:0]  lsu1_Rs_lsu_forwarding_ReadS,
    input        lsu1_Rt_needforwarding_ReadS,
    input        lsu1_Rs_needforwarding_ReadS,
    input [15:0] lsu1_imm_ReadS,
	 
	 input [2:0]size_cache,
	 input [1:0]number_of_commit,

	 
	 //==================================================================
    // Inputs from the bypass network
    //==================================================================
	 //operands read from PRF 
	 input [31:0] alu0_s1 ,alu0_s2 ,alu1_s1 ,alu1_s2 , alu2_s1, alu2_s2 , bu_s1, bu_s2,
	 input [31:0] lsu0_Rt, lsu0_Rs, lsu1_Rt, lsu1_Rs, 
	 
	 
	 //==================================================================
    // Inputs from the bypass network
    //==================================================================
	 

	 input [31:0] alu0, alu1, alu2 ,  lsu0, lsu1,
	 
	 
	 //==================================================================
    // Inputs from the branching unit
    //==================================================================
	 input [6:0] BIDs_flush,
		
	 //==================================================================
    //outputs 
    //==================================================================
	  output [31:0] alu0_source1, alu0_source2,
	  output [31:0] alu1_source1, alu1_source2,
	  output [31:0] alu2_source1, alu2_source2,
	  
	  output reg [1:0]  alu0_BID		,alu1_BID		, alu2_BID, 
	  output reg [3:0]  alu0_operation, alu1_operation, alu2_operation, 
	  output reg [2:0]  bu_operation,
	  output [31:0] BU_source1, BU_source2,
	  output [31:0] lsu0_Rt_source,lsu0_address,
	  output [31:0] lsu1_Rt_source,lsu1_address,
	  	  
     output valid_lsu0, valid_lsu1,
	  output reg stall_LS,
	  output reg dep_lw0_sw1, dep_sw0_sw1_mux, dep_sw0_lw1

	 );  

                 
	 ReadStage_forwarding_muxes_alu ALU0 (
    .s1_alu_forwarding_ReadS(alu0_s1_alu_forwarding_ReadS),    
    .s2_alu_forwarding_ReadS(alu0_s2_alu_forwarding_ReadS),
    .s1_lsu_forwarding_ReadS(alu0_s1_lsu_forwarding_ReadS),
    .s2_lsu_forwarding_ReadS(alu0_s2_lsu_forwarding_ReadS),
    .s1_needforwarding_ReadS(alu0_s1_needforwarding_ReadS),
    .s2_needforwarding_ReadS(alu0_s2_needforwarding_ReadS),
    .imm16b_ReadS(alu0_imm16b_ReadS),
    .i_type(alu0_is_Itype_ReadS),
    
    .PRFsource1(alu0_s1),
    .PRFsource2(alu0_s2),
    
    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
    
    .lsu0(lsu0),
    .lsu1(lsu1),
    
    .source1(alu0_source1),//assign it to become an output 
    .source2(alu0_source2)
	 
);

	   always @(*) begin
		 alu0_operation = alu0_operation_ReadS;
		 alu0_BID 	   = alu0_bid_ReadS;
		 if(BIDs_flush[6])begin 
			if (BIDs_flush[alu0_bid_ReadS]) alu0_BID = BIDs_flush[5:4];
			
		 end 
		 else begin 
			if (BIDs_flush[alu0_bid_ReadS]) alu0_operation= 4'b0000 ;		
			end
		end
			
	

	ReadStage_forwarding_muxes_alu ALU1 (
    .s1_alu_forwarding_ReadS(alu1_s1_alu_forwarding_ReadS),    
    .s2_alu_forwarding_ReadS(alu1_s2_alu_forwarding_ReadS),
    .s1_lsu_forwarding_ReadS(alu1_s1_lsu_forwarding_ReadS),
    .s2_lsu_forwarding_ReadS(alu1_s2_lsu_forwarding_ReadS),
    .s1_needforwarding_ReadS(alu1_s1_needforwarding_ReadS),
    .s2_needforwarding_ReadS(alu1_s2_needforwarding_ReadS),
    .imm16b_ReadS(alu1_imm16b_ReadS),
    .i_type(alu1_is_Itype_ReadS),
    
    .PRFsource1(alu1_s1),
    .PRFsource2(alu1_s2),
    
    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
    
    .lsu0(lsu0),
    .lsu1(lsu1),
    
    .source1(alu1_source1),
    .source2(alu1_source2)
);
	always @(*) begin
		 alu1_operation = alu1_operation_ReadS;
		 alu1_BID 	   = alu1_bid_ReadS;
		 if(BIDs_flush[6])begin 
			if (BIDs_flush[alu1_bid_ReadS]) alu1_BID = BIDs_flush[5:4];
			
			end 
			else begin 
			if (BIDs_flush[alu1_bid_ReadS]) alu1_operation= 4'b0000 ;		
			end
	end

	
	ReadStage_forwarding_muxes_alu ALU2 (
    .s1_alu_forwarding_ReadS(alu2_s1_alu_forwarding_ReadS),    
    .s2_alu_forwarding_ReadS(alu2_s2_alu_forwarding_ReadS),
    .s1_lsu_forwarding_ReadS(alu2_s1_lsu_forwarding_ReadS),
    .s2_lsu_forwarding_ReadS(alu2_s2_lsu_forwarding_ReadS),
    .s1_needforwarding_ReadS(alu2_s1_needforwarding_ReadS),
    .s2_needforwarding_ReadS(alu2_s2_needforwarding_ReadS),
    .imm16b_ReadS(alu2_imm16b_ReadS),
    .i_type(alu2_is_Itype_ReadS),
    
    .PRFsource1(alu2_s1),
    .PRFsource2(alu2_s2),
    
    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
    
    .lsu0(lsu0),
    .lsu1(lsu1),
    
    .source1(alu2_source1),
    .source2(alu2_source2)
);
	always @(*) begin
		 alu2_operation = alu2_operation_ReadS;
		 alu2_BID 	   = alu2_bid_ReadS;
		 if(BIDs_flush[6])begin 
			if (BIDs_flush[alu2_bid_ReadS]) alu2_BID = BIDs_flush[5:4];
			
			end 
			else begin 
			if (BIDs_flush[alu2_bid_ReadS]) alu2_operation= 4'b0000 ;		
			end
	end
	
	
	
	ReadStage_forwarding_muxes_bu BU (
    .s1_alu_forwarding_ReadS(bu_s1_alu_forwarding_ReadS),    
    .s2_alu_forwarding_ReadS(bu_s2_alu_forwarding_ReadS),
    .s1_lsu_forwarding_ReadS(bu_s1_lsu_forwarding_ReadS),
    .s2_lsu_forwarding_ReadS(bu_s2_lsu_forwarding_ReadS),
    .s1_needforwarding_ReadS(bu_s1_needforwarding_ReadS),
    .s2_needforwarding_ReadS(bu_s2_needforwarding_ReadS),
    
    .PRFsource1(bu_s1),
    .PRFsource2(bu_s2),
    
    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
   
    .lsu0(lsu0),
    .lsu1(lsu1),
    
    .source1(BU_source1),
    .source2(BU_source2)
);
	
	always @(*) begin
	bu_operation = bu_operation_ReadS;
		if (!BIDs_flush[6] && BIDs_flush[bu_BID_ReadS]) bu_operation = 2'b00 ;
	end
	
	
	ReadStage_forwarding_muxes_LSU LSU0 (
    .Rt_alu_forwarding_ReadS(lsu0_Rt_alu_forwarding_ReadS),
    .Rs_alu_forwarding_ReadS(lsu0_Rs_alu_forwarding_ReadS),
    .Rt_lsu_forwarding_ReadS(lsu0_Rt_lsu_forwarding_ReadS),
    .Rs_lsu_forwarding_ReadS(lsu0_Rs_lsu_forwarding_ReadS),
    .Rt_needforwarding_ReadS(lsu0_Rt_needforwarding_ReadS),
    .Rs_needforwarding_ReadS(lsu0_Rs_needforwarding_ReadS),
    .imm16b_ReadS(lsu0_imm_ReadS),
    

    .PRFRt(lsu0_Rt),
    .PRFRs(lsu0_Rs),

    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
    
    .lsu0(lsu0),
    .lsu1(lsu1),

    .source1(lsu0_Rt_source),
    .address(lsu0_address)
);



	ReadStage_forwarding_muxes_LSU LSU1 (
    .Rt_alu_forwarding_ReadS(lsu1_Rt_alu_forwarding_ReadS),
    .Rs_alu_forwarding_ReadS(lsu1_Rs_alu_forwarding_ReadS),
    .Rt_lsu_forwarding_ReadS(lsu1_Rt_lsu_forwarding_ReadS),
    .Rs_lsu_forwarding_ReadS(lsu1_Rs_lsu_forwarding_ReadS),
    .Rt_needforwarding_ReadS(lsu1_Rt_needforwarding_ReadS),
    .Rs_needforwarding_ReadS(lsu1_Rs_needforwarding_ReadS),
    .imm16b_ReadS(lsu1_imm_ReadS),
  
    .PRFRt(lsu1_Rt),
    .PRFRs(lsu1_Rs),

    .alu0(alu0),
    .alu1(alu1),
    .alu2(alu2),
   
    .lsu0(lsu0),
    .lsu1(lsu1),

    .source1(lsu1_Rt_source),
    .address(lsu1_address)
);
	
	

	assign valid_lsu0 = (lsu0_operation_ReadS == 2'b00) ? 1'b0 :1'b1;
	assign valid_lsu1 = (lsu1_operation_ReadS == 2'b00) ? 1'b0 :1'b1;

	
	wire [1:0] opcode_0, opcode_1;
	wire is_sw_0, is_sw_1, is_lw_0, is_lw_1;

	
	assign opcode_0 = lsu0_operation_ReadS;
	
   assign opcode_1 = lsu1_operation_ReadS;
	
	assign is_sw_0 = (opcode_0 == 2'b10);
   
	assign is_sw_1  = (opcode_1  == 2'b10);
	
	assign is_lw_0 = (opcode_0 == 2'b01);
	assign is_lw_1 = (opcode_1 == 2'b01);
	


	// dependecy 
	
always @(*) begin
	dep_lw0_sw1 = 1'b0;
	dep_sw0_sw1_mux = 1'b0;
	dep_sw0_lw1 = 1'b0;
	if (lsu0_address == lsu1_address) begin 		
		if (is_sw_0 && is_sw_1)begin 
		dep_sw0_sw1_mux = 1'b1;
		end
		else if (is_lw_0 && is_sw_1)begin 
		dep_lw0_sw1 = 1'b1;
		end	
		else if (is_sw_0 && is_lw_1)begin 
		dep_sw0_lw1 = 1'b1;
		end
	end	
end



always @(*) begin
	stall_LS =1'b0;
	 if (number_of_commit == 2'b0) begin 
		if ((size_cache == 3'b11) && is_sw_0 && is_sw_1 && (!dep_sw0_sw1_mux)) begin  // Cache size is 3, and there are two store (SW) instructions with different addresses  
			// Stall
			stall_LS =1'b1;
		end
		if ((size_cache == 3'b100) && (is_sw_0 | is_sw_1)) begin  // Cache size is 4, and there is at least one store (SW) instruction in any of the ways  
			// Stall 
			stall_LS =1'b1;
		end
	end
	else if (number_of_commit == 2'b1) begin 
		if (is_lw_0 && is_lw_1) begin  // Two load (LW) instructions exist in both ways  
			// Stall  
			stall_LS =1'b1;
		end	
		if ((size_cache == 3'b11) && is_sw_0 && is_sw_1 && (!dep_sw0_sw1_mux)) begin  // Cache size is 3, and there are two store (SW) instructions with different addresses  
			// Stall  
			stall_LS =1'b1;
		end	
	end
	else if (number_of_commit == 2'b10) begin 
		if (is_lw_0 | is_lw_1) begin  // Cache size is 4, and there is at least one load (LW) instruction in any of the ways  
			// Stall   
			stall_LS =1'b1;
		end
	end	
end			 


endmodule