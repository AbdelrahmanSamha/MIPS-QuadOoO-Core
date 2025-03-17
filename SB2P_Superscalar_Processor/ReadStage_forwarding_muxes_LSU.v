module ReadStage_forwarding_muxes_LSU(
    input [1:0]  Rt_alu_forwarding_ReadS,
    input [1:0]  Rs_alu_forwarding_ReadS,
    input [1:0]  Rt_lsu_forwarding_ReadS,
    input [1:0]  Rs_lsu_forwarding_ReadS,
    input        Rt_needforwarding_ReadS,
    input        Rs_needforwarding_ReadS,
    input [15:0] imm16b_ReadS, 
    
    
    input [31:0] PRFRt, PRFRs,
    
    input [31:0] alu0, alu1, alu2,  lsu0, lsu1,
    
    output [31:0] source1, address
);



	
	
	
	
	wire [31:0] lsu_forwarding_alu_Rt, lsu_forwarding_alu_Rs, lsu_forwarding_lsu_Rt, lsu_forwarding_lsu_Rs;
	wire [31:0]immediate;
	wire [31:0]Rsoperand;
	
	assign immediate= {{16{imm16b_ReadS[15]}}, imm16b_ReadS[15:0]};
	
	
	mux3_ip lsu_forwarding_alu_Rtmux (.data0x(alu2), .data1x(alu1),.data2x(alu0) ,  .sel(Rt_alu_forwarding_ReadS), .result(lsu_forwarding_alu_Rt));
	mux3_ip lsu_forwarding_alu_Rsmux (.data0x(alu2), .data1x(alu1),.data2x(alu0) ,  .sel(Rs_alu_forwarding_ReadS), .result(lsu_forwarding_alu_Rs));
	
	mux3_ip lsu_forwarding_lsu_Rtmux (.data0x(lsu_forwarding_alu_Rt), .data1x(lsu1),.data2x(lsu0) , .sel(Rt_lsu_forwarding_ReadS), .result(lsu_forwarding_lsu_Rt));
	mux3_ip lsu_forwarding_lsu_Rsmux (.data0x(lsu_forwarding_alu_Rs), .data1x(lsu1),.data2x(lsu0) , .sel(Rs_lsu_forwarding_ReadS), .result(lsu_forwarding_lsu_Rs));
	
	mux2_ip lsu_isforwardings1mux (.data0x(PRFRt), .data1x(lsu_forwarding_lsu_Rt), .sel(Rt_needforwarding_ReadS), .result(source1));
	mux2_ip lsu_isforwardings2mux (.data0x(PRFRs), .data1x(lsu_forwarding_lsu_Rs), .sel(Rs_needforwarding_ReadS), .result(Rsoperand));
	
	
	
	adder #(32) AddressAdder(.in0(Rsoperand),.in1(immediate), .out(address));
	
endmodule 