module ArithmeticRSREADY(

input [5:0] rs1index, rs2index,
input rs1valid, rs2valid,
input empty, 
input is_itype,
input[5:0] FU0, FU1, FU2,  LSU0, LSU1,
input [5:0] FU0_readstage, FU1_readstage, FU2_readstage,  LSU0_readstage, LSU1_readstage,

output ready,
//the following signals must be concatenated with the instruciton if dispatched.
output reg [1:0] selector_for_s1_ALUmux , selector_for_s1_LSUmux,
output reg rs1forward,
output reg [1:0] selector_for_s2_ALUmux , selector_for_s2_LSUmux,
output reg rs2forward
);



wire match_rs1_FU0, match_rs1_FU1,match_rs1_FU2,  match_rs1_LS0, match_rs1_LS1;
wire match_rs2_FU0, match_rs2_FU1,match_rs2_FU2,  match_rs2_LS0, match_rs2_LS1;

wire match_rs1_FU0_readstage, match_rs1_FU1_readstage, match_rs1_FU2_readstage ,  match_rs1_LS0_readstage, match_rs1_LS1_readstage;
wire match_rs2_FU0_readstage, match_rs2_FU1_readstage, match_rs2_FU2_readstage ,  match_rs2_LS0_readstage , match_rs2_LS1_readstage;

// RS1 Matching

assign match_rs1_FU0_readstage = (rs1index == FU0_readstage);
assign match_rs1_FU1_readstage = (rs1index == FU1_readstage);
assign match_rs1_FU2_readstage = (rs1index == FU2_readstage);

assign match_rs1_LS0_readstage = (rs1index == LSU0_readstage);
assign match_rs1_LS1_readstage = (rs1index == LSU1_readstage);

assign match_rs1_FU0 = (rs1index == FU0);
assign match_rs1_FU1 = (rs1index == FU1);
assign match_rs1_FU2 = (rs1index == FU2);

assign match_rs1_LS0 = (rs1index == LSU0);
assign match_rs1_LS1 = (rs1index == LSU1);



reg source1ready;
reg source2ready;
 

/*ABOUT THE MODULE: 
this module scans a reservation station entry, it checks if the source values for the instruciton are either ready in the PRF (through the rsvalid bits),
or if the source values are being computed currently in the pipeline execution unit. 
and if the later was the case it prepares its own selector lines to get the appropriate value from the Bypass network. 
the ready signal is sent to the scheduler, and its the scheduler's job to dispatch the instruction depending on the availablilty of a free execution unit. 
this module is only applicible for the arithmatic Reservation station, the LoadStore reservation stations require different handeling. 
*/

assign ready = ( source1ready & source2ready);




	//source1 
	always@(*)begin 
		selector_for_s1_ALUmux = 2'b00;
		selector_for_s1_LSUmux = 2'b00;
		rs1forward= 1'b0;
		source1ready = 1'b0;
		
		if (!empty)begin 
			if(!rs1valid)begin
				
				if(match_rs1_FU0 | match_rs1_FU1 | match_rs1_FU2 | match_rs1_LS0 | match_rs1_LS1)begin 
					source1ready = 1'b1;
					rs1forward = 1'b0;
					end
				else begin 
					if (match_rs1_FU0_readstage) begin 
						source1ready = 1'b1;
						selector_for_s1_ALUmux = 2'b10;
						rs1forward = 1'b1;
					end
					if (match_rs1_FU1_readstage) begin
						source1ready = 1'b1;
						selector_for_s1_ALUmux = 2'b01;
						rs1forward = 1'b1;
					end
					if (match_rs1_FU2_readstage) begin 
						source1ready = 1'b1;
						selector_for_s1_ALUmux = 2'b00;
						rs1forward = 1'b1;
					end
					
					if (match_rs1_LS0_readstage) begin 
						source1ready = 1'b1;
						selector_for_s1_LSUmux = 2'b10;
						rs1forward = 1'b1;
					end
					if (match_rs1_LS1_readstage) begin 
						source1ready = 1'b1;
						selector_for_s1_LSUmux = 2'b01;
						rs1forward = 1'b1;
					end
				end
			end
			else begin 
				source1ready = 1'b1;
			end
		end
	end
	
	
	
	// RS2 Matching
	assign match_rs2_FU0 = (rs2index == FU0);
	assign match_rs2_FU1 = (rs2index == FU1);
	assign match_rs2_FU2 = (rs2index == FU2);
	
	assign match_rs2_LS0 = (rs2index == LSU0);
	assign match_rs2_LS1 = (rs2index == LSU1);
	
	
	assign match_rs2_FU0_readstage = (rs2index == FU0_readstage);
	assign match_rs2_FU1_readstage = (rs2index == FU1_readstage);
	assign match_rs2_FU2_readstage = (rs2index == FU2_readstage);
	
	assign match_rs2_LS0_readstage = (rs2index == LSU0_readstage);
	assign match_rs2_LS1_readstage = (rs2index == LSU1_readstage);

	
	
	
	//source2 
	always@(*)begin 
		selector_for_s2_ALUmux = 2'b00;
		selector_for_s2_LSUmux = 2'b00;
		rs2forward= 1'b0;
		source2ready = 1'b0;
		if (!empty & !is_itype)begin 
			if(!rs2valid)begin
				
				if(match_rs2_FU0 | match_rs2_FU1 | match_rs2_FU2 |  match_rs2_LS0 | match_rs2_LS1)begin 
					source2ready = 1'b1;
					rs2forward = 1'b0;
				end
				
				else begin 
					if(match_rs2_FU0_readstage)begin 
						source2ready = 1'b1;
						selector_for_s2_ALUmux = 2'b10;
						rs2forward = 1'b1;
					end
					if(match_rs2_FU1_readstage)begin 
						source2ready = 1'b1;
						selector_for_s2_ALUmux = 2'b01;
						rs2forward = 1'b1;
					end
					if(match_rs2_FU2_readstage)begin 
						source2ready = 1'b1;
						selector_for_s2_ALUmux = 2'b00;
						rs2forward = 1'b1;
					end
					
					if(match_rs2_LS0_readstage)begin 
						source2ready = 1'b1;
						selector_for_s2_LSUmux = 2'b10;
						rs2forward = 1'b1;
					end
					if(match_rs2_LS1_readstage)begin 
						source2ready = 1'b1;
						selector_for_s2_LSUmux = 2'b01;
						rs2forward = 1'b1;
					end
				end
			end
			else begin 
				source2ready = 1'b1;
			end
		end
		else if(!empty & is_itype)begin 
			source2ready = 1'b1;
		end 
		
		
	end
	
endmodule