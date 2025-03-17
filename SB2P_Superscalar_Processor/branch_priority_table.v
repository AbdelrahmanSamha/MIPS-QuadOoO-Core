module branch_priority_table (
    input clk,
    input rst,
    input [1:0] branch_ID,     // ID of the branch to store
    input is_branch,            // Signal to write to the PT
    input branch_resolved,     // Signal indicating a branch is resolved
    input [1:0] resolved_ID,   // ID of the resolved branch
	 input hit, //hit or miss 
	 input stall_in,
    output reg [1:0] H, M, L,   // Priority table entries
	 output  stall
);


wire tabel_isfull;
assign tabel_isfull = ((H != 2'b00) && (M != 2'b00) && (L != 2'b00));
assign stall = (is_branch && tabel_isfull) ? 1'b1 : 1'b0; 

always @(posedge clk or posedge rst) begin
		if (rst) begin
			// Initialize all entries to 00 (empty)
			H <= 2'b00;
			M <= 2'b00;
			L <= 2'b00;
			
		end 
		
		else begin
			// Handle unresolved branches (clear entries)
			if (branch_resolved && !hit) begin 
				
				if (resolved_ID == H) begin  
					H <= 2'b00;
					M <= 2'b00;
					L <= 2'b00;
				end 
				else if (resolved_ID == M) begin 
					M <= 2'b00;
					L <= 2'b00;
				end 
				else if (resolved_ID == L) begin 
					L <= 2'b00;
				end 
			end
			
			// Handle new branch insertion with resolution
			else if (is_branch & branch_resolved & !stall_in) begin
				
				if (L != 2'b00) begin 
					L <= branch_ID;
					if (H == resolved_ID) begin
						H <= M;
						M <= L;
					end 
					else if (M == resolved_ID) begin
						M <= L;
					end 
				end
				else if (M != 2'b00) begin 
					M <= branch_ID;
					if (H == resolved_ID) begin
						H <= M;
					end 
				end
				else if (H != 2'b00) begin
					H <= branch_ID;
				end
			end
			
			// Handle new branch insertion (normal operation)
			else if (is_branch & !stall_in) begin
				
				if (H == 2'b00) begin
					H <= branch_ID;  // Prioritize H entry
				end 
				else if (M == 2'b00) begin
					M <= branch_ID;  // Then M entry
				end
				else if (L == 2'b00) begin
					L <= branch_ID;  // Finally L entry
				end
			end
	
			// Handle branch resolution cleanup
			else if (branch_resolved && hit) begin
				
				// Shift entries up to fill vacated slots
				if (H == resolved_ID) begin
					H <= M;
					M <= L;
					L <= 2'b00;
				end 
				else if (M == resolved_ID) begin
					M <= L;
					L <= 2'b00;
				end 
				else if (L == resolved_ID) begin
					L <= 2'b00;
				end
			end
		end
	end
 endmodule