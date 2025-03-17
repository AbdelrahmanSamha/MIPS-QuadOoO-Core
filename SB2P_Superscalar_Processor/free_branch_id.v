module free_branch_id (clk, rst,stall,hit,
 available_id, active_branch,
								is_branch3,is_branch2,is_branch1,is_branch0,BID_resolve,branch_resolved,H,M,L,stall_in,BIDs_flush
); 
	input clk, rst;
	input hit;
	input [1:0] BID_resolve;
	input branch_resolved;
	reg [3:0] free_id; 
	input [1:0] H,M,L;
	input stall_in;
	output reg [1:0] available_id;
	
	output reg [1:0] active_branch;

	input [6:0] BIDs_flush;
	input  is_branch3, is_branch2, is_branch1, is_branch0;
	
	wire is_branch;		
	output stall; 
	assign is_branch = (is_branch0 | is_branch1 | is_branch2 | is_branch3);
	
	assign stall = (free_id == 4'b0000) && (is_branch);
	always @(posedge clk or posedge rst) begin
		if (rst) begin
				  free_id <= 4'b1110; 
						
				  
		end
		else begin 
			 if(branch_resolved && !hit)begin 
					if (BID_resolve == L) begin 
						free_id[BID_resolve]<= 1'b1;
					end 
					
					else if (BID_resolve == M) begin 
						free_id[BID_resolve]<=1'b1;
					if (L != 2'b00) begin 
							free_id[L] <=1'b1;
						end 
					end 
					
					else if (BID_resolve == H) begin 
						free_id[3:1] = 3'b111;
					end 
			 
			 end
			 else begin
			 
			 if (branch_resolved && hit) begin 
			 
				free_id[BID_resolve]=1'b1;
			 
			 end
			 
			  if (is_branch && !stall_in) begin
				  
				free_id[available_id] = 1'b0;
			 end
		 
			end 
		end  
	end
		  
		  
	always@(*) begin  // need to edit the available id when branch resolution 
		case (1'b1) 
			free_id[1]: available_id = 2'b01; 
			free_id[2]: available_id = 2'b10;
			free_id[3]: available_id = 2'b11; 	
			default : available_id = 2'b00;
		endcase
	end 
/*		
		always @(negedge clk , posedge rst)begin
        case (BID_resolve)
            2'b01: begin free_id[1] <= 1'b1; free_id[2] <= 1'b1; free_id[3] <= 1'b1; end
            2'b10: begin free_id[2] <= 1'b1;  free_id[3] <= 1'b1; end
            2'b11: begin free_id[3] <= 1'b1;   end
endcase
end
   */ 
/*		
hit 
stall 
is_branch 

h s b 
0 0 0	xxx	
0 0 1	decoder 	
0 1 0	xxx	
0 1 1	xxx	
1 0 0	vector	
1 0 1	decoder 	
1 1 0	vector	
1 1 1	vector	
		
*/	
		
	always@(posedge clk , posedge rst)begin 
		if (rst) begin 
			active_branch <= 2'b00;
		end
		else begin 
		if (!BIDs_flush[6] && BIDs_flush[active_branch]) begin //miss
			active_branch <= BIDs_flush[5:4];
		end
		else if (BIDs_flush[6] && BIDs_flush[active_branch] &&(stall_in |!is_branch)) begin // vector ... BIDs_flush 
			active_branch <= BIDs_flush[5:4];
		end 
		else if (!stall_in && is_branch && !stall) begin // decoder 
			active_branch <= available_id;
		end 
		else begin 
			active_branch <= active_branch;
		end 
	end 
end
endmodule