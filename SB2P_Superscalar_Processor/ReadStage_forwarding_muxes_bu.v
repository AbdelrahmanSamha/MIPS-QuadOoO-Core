module ReadStage_forwarding_muxes_bu(
	
	input [1:0]  s1_alu_forwarding_ReadS,
   input [1:0]  s2_alu_forwarding_ReadS,
   input [1:0]  s1_lsu_forwarding_ReadS,
   input [1:0]  s2_lsu_forwarding_ReadS,
   input        s1_needforwarding_ReadS,
   input        s2_needforwarding_ReadS,
   
	
	
	input [31:0] PRFsource1, PRFsource2,
	
	input [31:0]alu0,alu1,alu2,lsu0,lsu1,
	
	output [31:0] source1, source2
	
	);
	
	
	
	
	wire [31:0] alu_forwarding_alu_s1,alu_forwarding_alu_s2, alu_forwarding_lsu_s1, alu_forwarding_lsu_s2;
	

	//
	mux3_ip alu_forwarding_alu_s1mux (.data0x(alu2), .data1x(alu1),.data2x(alu0) ,  .sel(s1_alu_forwarding_ReadS), .result(alu_forwarding_alu_s1));
	mux3_ip alu_forwarding_alu_s2mux (.data0x(alu2), .data1x(alu1),.data2x(alu0) ,  .sel(s2_alu_forwarding_ReadS), .result(alu_forwarding_alu_s2));
	
	mux3_ip alu_forwarding_lsu_s1mux (.data0x(alu_forwarding_alu_s1), .data1x(lsu1),.data2x(lsu0) , .sel(s1_lsu_forwarding_ReadS), .result(alu_forwarding_lsu_s1));
	mux3_ip alu_forwarding_lsu_s2mux (.data0x(alu_forwarding_alu_s2), .data1x(lsu1),.data2x(lsu0) , .sel(s2_lsu_forwarding_ReadS), .result(alu_forwarding_lsu_s2));
	
	mux2_ip alu_isforwardings1mux (.data0x(PRFsource1), .data1x(alu_forwarding_lsu_s1), .sel(s1_needforwarding_ReadS), .result(source1));
	mux2_ip alu_isforwardings2mux (.data0x(PRFsource2), .data1x(alu_forwarding_lsu_s2), .sel(s2_needforwarding_ReadS), .result(source2));
	
endmodule 