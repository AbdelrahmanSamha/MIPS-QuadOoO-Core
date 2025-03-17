module IFID1(clk,rst,inst0_in, inst1_in, inst2_in, inst3_in,stall_branch_priority_table,stall_reservation_station_LS,stall_reservation_station,ROB_stall,
				inst0_out, inst1_out, inst2_out, inst3_out,
				flush0,flush1,flush2,flush3,stall_branching_unit,
				flush_branch_Miss
				); 
				
input clk,rst;

input [31:0] inst0_in,inst1_in,inst2_in,inst3_in;
input flush0,flush1,flush2,flush3;
input stall_branch_priority_table;
input stall_reservation_station,stall_reservation_station_LS , ROB_stall;

input stall_branching_unit;

output reg [31:0] inst0_out,inst1_out,inst2_out,inst3_out;

reg reg_stall_branching_unit;

input flush_branch_Miss;

always@(posedge clk or posedge rst)begin 
		if (rst) begin 
			reg_stall_branching_unit <= 1'b0;
		end else begin
			reg_stall_branching_unit <= stall_branching_unit;
		end
	end


	//way0
	always@(posedge clk or posedge rst)begin 
		if (rst) begin 
			inst0_out <= 32'b0;
		end
		else if(flush_branch_Miss)begin
			inst0_out <= 32'b0;
		end
		else if(stall_branch_priority_table)begin
			inst0_out <= inst0_out;
		end
		else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS)begin
			inst0_out <= inst0_out;
		end
		else if(flush0 | reg_stall_branching_unit)begin
			inst0_out <= 32'b0;
		end
		else begin  
			inst0_out<=inst0_in;
		end
	end
	//way1
	always@(posedge clk or posedge rst)begin 
		if (rst) begin 
			inst1_out <= 32'b0;
		end
		else if(flush_branch_Miss)begin
			inst1_out <= 32'b0;
		end
		else if(stall_branch_priority_table)begin
			inst1_out <= inst1_out;
		end	
		else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS)begin
			inst1_out <= inst1_out;
		end
		
		else if(flush1 | reg_stall_branching_unit)begin
			inst1_out <= 32'b0;
		end
		else begin 
			inst1_out<=inst1_in;
		end
	end  
	//way2
	always@(posedge clk or posedge rst)begin 
		if (rst) begin 
			inst2_out <= 32'b0;
		end 
		else if(flush_branch_Miss)begin
			inst2_out <= 32'b0;
		end
		else if(stall_branch_priority_table)begin
			inst2_out <= inst2_out;
		end
		else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS)begin
			inst2_out <= inst2_out;
		end
		
		else if(flush2 | reg_stall_branching_unit)begin
			inst2_out <= 32'b0;
		end
		else begin  
			inst2_out<=inst2_in;
		end
	end 
	//way3
	always@(posedge clk or posedge rst)begin 
		if (rst) begin 
			inst3_out <= 32'b0;
		end 
		else if(flush_branch_Miss)begin
			inst3_out <= 32'b0;
		end
		else if(stall_branch_priority_table)begin
			inst3_out <= inst3_out;
		end
		else if(stall_reservation_station | ROB_stall | stall_reservation_station_LS)begin
			inst3_out <= inst3_out;
		end
		
		else if(flush3 | reg_stall_branching_unit)begin
			inst3_out <= 32'b0;
		end
		else begin  
			inst3_out<=inst3_in;
		end
	end 

endmodule