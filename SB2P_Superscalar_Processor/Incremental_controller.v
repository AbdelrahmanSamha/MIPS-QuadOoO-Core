module Incremental_controller (
		is_branch0, is_branch1, is_branch2,is_branch3,
		 matchd0_d1, matchd0_d2, matchd0_d3,
		 matchd1_d2, matchd1_d3,
		 matchd2_d3,
		 pointer_register0, pointer_register1, pointer_register2,
		 
		partofbranch0,partofbranch1,partofbranch2,partofbranch3,
		
		way0modified0, way0modified1, way0modified2,
		way1modified0, way1modified1, way1modified2,
		way2modified0, way2modified1, way2modified2,
		way3modified0, way3modified1, way3modified2,
		H,M,L,
		//outputs
		writeEn0, writeEn1, writeEn2, writeEn3, 
		writeEn4, writeEn5, writeEn6, writeEn7,
		writeEn8, writeEn9, writeEn10,writeEn11
		

	);

input is_branch0, is_branch1, is_branch2,is_branch3;// these tell us whether an instruction is a branch instruction or not. 
input partofbranch0,partofbranch1,partofbranch2,partofbranch3;
 
input matchd0_d1, matchd0_d2, matchd0_d3,matchd1_d2, matchd1_d3,matchd2_d3;
input way0modified0, way0modified1, way0modified2;
input way1modified0, way1modified1, way1modified2;
input way2modified0, way2modified1, way2modified2;
input way3modified0, way3modified1, way3modified2;
input [1:0] H,M,L;
input [1:0] pointer_register0, pointer_register1, pointer_register2;

output reg writeEn0, writeEn1, writeEn2, writeEn3; 
output reg writeEn4, writeEn5, writeEn6, writeEn7;
output reg writeEn8, writeEn9, writeEn10,writeEn11;
//note: to verify the results for each block, write down the probabilities for each way and consider its cases, 
//rememebr we already perform checks on the instructions if its speculative and if its a write, and in order for an instruction to continue 
//in a any of the blocks belows the previous must be true for both. 
//otherwise it will stop right at the first check of the block and its writeEn signals will be killed. 


//note: 
//in all the blocks listed below, the same pattern is followed: 
//first: we check a case where there is no branch instruction in the batch but the batch is speculative (meaning there was a branch in the previous cycle)
//second: if a branch was in wayx then we make sure that between the current instruction of intreset and wayx there is no dependency, 
//if there is we kill the writeEN as the instruction is of no use.
//third: if the branch was in the middle of the ways, say 1 or 2. then extra handeling is done inside the else blocks to account for the "ways" before the branch
//remember that you dont want to mess up older mapping tables.  



		
	// way0
		// way0
	always @(*) begin 
		// Initialize all writeEn signals to 0
		writeEn0 = 0;
		writeEn4 = 0;
		writeEn8 = 0;

		
	
// Only process if part of a branch and not a branch instruction
		if (partofbranch0 && (!is_branch0)) begin 
			// Priority: Check L -> M -> H (reverse priority order)
			// ------------------------------------------------------
			if (L != 2'b00) begin 
				// Write to all MTs for L 
				if(!(is_branch1 | is_branch2 | is_branch3))begin
					writeEn0 = !way0modified0;
					writeEn4 = !way0modified1;
					writeEn8 = !way0modified2;
				end
				else begin
					if (M == pointer_register0) begin
						writeEn0 = !way0modified0;
	
						// Nested check for H 
						if (H == pointer_register1) begin
							writeEn4 = !way0modified1;
						end
						else if (H == pointer_register2) begin
							writeEn8 = !way0modified2;
						end
					end
					else if (M == pointer_register1) begin
						writeEn4 = !way0modified1;
						// Nested check for H 
						if (H == pointer_register0) begin
							writeEn0 = !way0modified0;
						end
						else if (H == pointer_register2) begin
							writeEn8 = !way0modified2;
						end
					end
					else if (M == pointer_register2) begin
						writeEn8 = !way0modified2;
						// Nested check for H 
						if (H == pointer_register0) begin
							writeEn0 = !way0modified0;
						end
						else if (H == pointer_register1) begin
							writeEn4 = !way0modified1;
						end
					end
				end
			end 
			else if ((M != 2'b00)) begin 
				// Check which MT M uses
				if(!(is_branch1 | is_branch2 | is_branch3))begin
					if (M == pointer_register0) begin
						writeEn0 = !way0modified0;
	
						// Nested check for H 
						if (H == pointer_register1) begin
							writeEn4 = !way0modified1;
						end
						else if (H == pointer_register2) begin
							writeEn8 = !way0modified2;
						end
					end
					else if (M == pointer_register1) begin
						writeEn4 = !way0modified1;
						// Nested check for H 
						if (H == pointer_register0) begin
							writeEn0 = !way0modified0;
						end
						else if (H == pointer_register2) begin
							writeEn8 = !way0modified2;
						end
					end
					else if (M == pointer_register2) begin
						writeEn8 = !way0modified2;
						// Nested check for H 
						if (H == pointer_register0) begin
							writeEn0 = !way0modified0;
						end
						else if (H == pointer_register1) begin
							writeEn4 = !way0modified1;
						end
					end
				end
				else begin 
					if (H == pointer_register0) begin
						writeEn0 = !way0modified0;
					end
					else if (H == pointer_register1) begin
						writeEn4 = !way0modified1;
					end
					else if (H == pointer_register2) begin
						writeEn8 = !way0modified2;
					end
					
				end 
			end //must check
			else if ((H != 2'b00) & (!(is_branch1 | is_branch2 | is_branch3))) begin 
				// Check which MT H uses
				if (H == pointer_register0) begin
					writeEn0 = !way0modified0;
				end
				else if (H == pointer_register1) begin
					writeEn4 = !way0modified1;
				end
				else if (H == pointer_register2) begin
					writeEn8 = !way0modified2;
				end
			end
		end 
	end
// way1
	always @(*) begin 
		// Initialize all writeEn signals to 0
		writeEn1 = 0;
		writeEn5 = 0;
		writeEn9 = 0;
	
		// Only process if part of a branch and not a branch instruction
		if (partofbranch1 && !is_branch1) begin 
			// Handle dependency check (only when no branch in way0)
			if (!is_branch0 && matchd0_d1) begin
				// Dependency conflict: Disable all writes
				writeEn1 = 0;
				writeEn5 = 0;
				writeEn9 = 0;
			end
			// No dependency conflict: Proceed with priority checks
			else begin
				// Priority check order: L -> M -> H
				// --------------------------------------------------
				if (L != 2'b00) begin 
					// Write to all MTs for L
					if(!(is_branch2 | is_branch3))begin
					writeEn1 = !way1modified0;
					writeEn5 = !way1modified1;
					writeEn9 = !way1modified2;
					end
					else begin
						if (M == pointer_register0) begin
							writeEn1 = !way1modified0;
							// Nested check for H
							if (H == pointer_register1) begin
								writeEn5 = !way1modified1;
							end
							else if (H == pointer_register2) begin
								writeEn9 = !way1modified2;
							end
						end
						else if (M == pointer_register1) begin
							writeEn5 = !way1modified1; 
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn1 = !way1modified0;
							end
							else if (H == pointer_register2) begin
								writeEn9 = !way1modified2;
							end
						end
						else if (M == pointer_register2) begin
							writeEn9 = !way1modified2;
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn1 = !way1modified0;
							end
							else if (H == pointer_register1) begin
								writeEn5 = !way1modified1;
							end
						end

					end
				end 
				else if (M != 2'b00) begin 
					// Check which MT M uses
					if(!(is_branch2 | is_branch3))begin
						if (M == pointer_register0) begin
							writeEn1 = !way1modified0;
							// Nested check for H
							if (H == pointer_register1) begin
								writeEn5 = !way1modified1;
							end
							else if (H == pointer_register2) begin
								writeEn9 = !way1modified2;
							end
						end
						else if (M == pointer_register1) begin
							writeEn5 = !way1modified1; 
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn1 = !way1modified0;
							end
							else if (H == pointer_register2) begin
								writeEn9 = !way1modified2;
							end
						end
						else if (M == pointer_register2) begin
							writeEn9 = !way1modified2;
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn1 = !way1modified0;
							end
							else if (H == pointer_register1) begin
								writeEn5 = !way1modified1;
							end
						end
					end
					else begin
						if (H == pointer_register0) begin
							writeEn1 = !way1modified0;
						end
						else if (H == pointer_register1) begin
							writeEn5 = !way1modified1;
						end
						else if (H == pointer_register2) begin
							writeEn9 = !way1modified2;
						end
					
					end
				end 
				
				else if (H != 2'b00 & (!( is_branch2 | is_branch3))) begin 
					// Check which MT H uses
					if (H == pointer_register0) begin
						writeEn1 = !way1modified0;
					end
					else if (H == pointer_register1) begin
						writeEn5 = !way1modified1;
					end
					else if (H == pointer_register2) begin
						writeEn9 = !way1modified2;
					end
				end
			end
		end 
	end


	
	

	// way2
	always @(*) begin 
		// Initialize all writeEn signals to 0
		writeEn2 = 0;
		writeEn6 = 0;
		writeEn10 = 0;
	
		// Only process if part of a branch and not a branch instruction
		if (partofbranch2 & !is_branch2) begin 
			// Handle dependency checks
			if (!is_branch0 & !is_branch1 & (matchd0_d2 | matchd1_d2)) begin
				// Dependency conflict: Disable all writes
				writeEn2 = 0;
				writeEn6 = 0;
				writeEn10 = 0;
			end
			else if (is_branch0 & matchd1_d2) begin
				// Dependency conflict: Disable all writes
				writeEn2 = 0;
				writeEn6 = 0;
				writeEn10 = 0;
			end
			else begin
				// Priority check order: L -> M -> H
				// --------------------------------------------------
				if (L != 2'b00) begin 
					// Write to all MTs for L
					if(!(is_branch3))begin
					writeEn2 = !way2modified0;
					writeEn6 = !way2modified1;
					writeEn10 = !way2modified2;
					end
					else begin
						if (M == pointer_register0) begin
							writeEn2 = !way2modified0;
							// Nested check for H
							if (H == pointer_register1) begin
								writeEn6 = !way2modified1;
							end
							else if (H == pointer_register2) begin
								writeEn10 = !way2modified2;
							end
						end
						else if (M == pointer_register1) begin
							writeEn6 = !way2modified1; 
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn2 = !way2modified0;
							end
							else if (H == pointer_register2) begin
								writeEn10 = !way2modified2;
							end
						end
						else if (M == pointer_register2) begin
							writeEn10 = !way2modified2;
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn2 = !way2modified0;
							end
							else if (H == pointer_register1) begin
								writeEn6 = !way2modified1;
							end
						end
						
					end
					// We need to check for dependency between the instructions in the same batch,
					// because if way1 was a branch instruction and L was != 0, then this means way0 instruction belongs to the M branch.
					if (matchd0_d2 & !is_branch0) begin
						if (M == pointer_register0) begin
							writeEn2 = 0;
							if (H == pointer_register1) writeEn6 = 0;
							if (H == pointer_register2) writeEn10 = 0;
						end
						else if (M == pointer_register1) begin
							writeEn6 = 0;
							if (H == pointer_register0) writeEn2 = 0;
							if (H == pointer_register2) writeEn10 = 0;
						end
						else if (M == pointer_register2) begin
							writeEn10 = 0;
							if (H == pointer_register0) writeEn2 = 0;
							if (H == pointer_register1) writeEn6 = 0;
						end
					end
				end 
				else if (M != 2'b00) begin 
					// Check which MT M uses
					if(!(is_branch3))begin
						if (M == pointer_register0) begin
							writeEn2 = !way2modified0;
							// Nested check for H
							if (H == pointer_register1) begin
								writeEn6 = !way2modified1;
							end
							else if (H == pointer_register2) begin
								writeEn10 = !way2modified2;
							end
						end
						else if (M == pointer_register1) begin
							writeEn6 = !way2modified1; 
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn2 = !way2modified0;
							end
							else if (H == pointer_register2) begin
								writeEn10 = !way2modified2;
							end
						end
						else if (M == pointer_register2) begin
							writeEn10 = !way2modified2;
							// Nested check for H
							if (H == pointer_register0) begin
								writeEn2 = !way2modified0;
							end
							else if (H == pointer_register1) begin
								writeEn6 = !way2modified1;
							end
						end
						
					end else begin
						if (H == pointer_register0) begin
							writeEn2 = !way2modified0;
						end
						else if (H == pointer_register1) begin
							writeEn6 = !way2modified1;
						end
						else if (H == pointer_register2) begin
							writeEn10 = !way2modified2;
						end
					end
					// If (M != 0) and way1 was a branch instruction, this means that way0 instruction belongs to the H branch, and if there was a dependency,
					// we don't want way2 to write to the H table. So find the H mapping table and kill its WriteEn.
					if (matchd0_d2 & !is_branch0) begin
						if (H == pointer_register0) begin
							writeEn2 = 0;
						end
						else if (H == pointer_register1) begin
							writeEn6 = 0;
						end
						else if (H == pointer_register2) begin
							writeEn10 = 0;
						end
					end
				end 
				else if (H != 2'b00 & (!is_branch3)) begin 
					// Check which MT H uses
					// If (H was != 0), then this and if way1 was a branch instruction, we don't need to check for the dependencies between way2 and way0
					// because way0 is not speculative and it will not write to the mapping tables.
					if (H == pointer_register0) begin
						writeEn2 = !way2modified0;
					end
					else if (H == pointer_register1) begin
						writeEn6 = !way2modified1;
					end
					else if (H == pointer_register2) begin
						writeEn10 = !way2modified2;
					end
				end
			end 
		end 
	end  
	
	
	
	
	// way3
	always @(*) begin 
		// Initialize all writeEn signals to 0
		writeEn3 = 0;
		writeEn7 = 0;
		writeEn11= 0;
	
		// Only process if part of a branch and not a branch instruction
		if (partofbranch3 & !is_branch3) begin 
			// Handle dependency checks
			if (!is_branch0 & !is_branch1 & !is_branch2 & (matchd0_d3 | matchd1_d3 | matchd2_d3)) begin
				// Dependency conflict: Disable all writes
				writeEn3 = 0;
				writeEn7 = 0;
				writeEn11 = 0;
			end
			else if (is_branch0 & (matchd1_d3 | matchd2_d3)) begin 
				// Dependency conflict: Disable all writes
				writeEn3 = 0;
				writeEn7 = 0;
				writeEn11 = 0;
			end
			else if (is_branch1 & matchd2_d3) begin
				// Dependency conflict: Disable all writes
				writeEn3 = 0;
				writeEn7 = 0;
				writeEn11 = 0;
			end 
			else begin
				// Priority check order: L -> M -> H
				// --------------------------------------------------
				if (L != 2'b00) begin 
					// Write to all MTs for L
					writeEn3 = !way3modified0;
					writeEn7 = !way3modified1;
					writeEn11= !way3modified2;
	
					// We need to check for dependency between the instructions in the same batch,
					// because if way1 was a branch instruction and L was != 0, then this means way0 instruction belongs to the M branch.
					if (matchd0_d3 & !is_branch0 & is_branch1) begin
						if (M == pointer_register0) begin
							writeEn3 = 0;
							if (H == pointer_register1) writeEn7 = 0;
							if (H == pointer_register2) writeEn11 = 0;
						end
						else if (M == pointer_register1) begin
							writeEn7 = 0;
							if (H == pointer_register0) writeEn3 = 0;
							if (H == pointer_register2) writeEn11 = 0;
						end
						else if (M == pointer_register2) begin
							writeEn11 = 0;
							if (H == pointer_register0) writeEn3 = 0;
							if (H == pointer_register1) writeEn7 = 0;
						end
					end
	
					// Similar here, but in this case both way0 and way1 are instructions.
					if ((matchd0_d3 | matchd1_d3) & !is_branch0 & !is_branch1) begin
						if (M == pointer_register0) begin
							writeEn3 = 0;
							if (H == pointer_register1) writeEn7 = 0;
							if (H == pointer_register2) writeEn11 = 0;
						end
						else if (M == pointer_register1) begin
							writeEn7 = 0;
							if (H == pointer_register0) writeEn3 = 0;
							if (H == pointer_register2) writeEn11 = 0;
						end
						else if (M == pointer_register2) begin
							writeEn11 = 0;
							if (H == pointer_register0) writeEn3 = 0;
							if (H == pointer_register1) writeEn7 = 0;
						end
					end
				end 
				else if (M != 2'b00) begin 
					// Check which MT M uses
					if (M == pointer_register0) begin
						writeEn3 = !way3modified0;
						// Nested check for H
						if (H == pointer_register1) begin
							writeEn7 = !way3modified1;
						end
						else if (H == pointer_register2) begin
							writeEn11 = !way3modified2;
						end
					end
					else if (M == pointer_register1) begin
						writeEn7 = !way3modified1; 
						// Nested check for H
						if (H == pointer_register0) begin
							writeEn3 = !way3modified0;
						end
						else if (H == pointer_register2) begin
							writeEn11 = !way3modified2;
						end
					end
					else if (M == pointer_register2) begin
						writeEn11 = !way3modified2;
						// Nested check for H
						if (H == pointer_register0) begin
							writeEn3 = !way3modified0;
						end
						else if (H == pointer_register1) begin
							writeEn7 = !way3modified1;
						end
					end
	
					// If (M != 0) and way1 or way2 was a branch instruction, this means that way0 or way1 instruction belongs to the H branch, and if there was a dependency,
					// we don't want way3 to write to the H table. So find the H mapping table and kill its WriteEn.
					if (matchd0_d3 & !is_branch0 & is_branch1) begin
						if (H == pointer_register0) begin
							writeEn3 = 0;
						end
						else if (H == pointer_register1) begin
							writeEn7 = 0;
						end
						else if (H == pointer_register2) begin
							writeEn11 = 0;
						end
					end
					else if ((matchd0_d3 | matchd1_d3) & !is_branch0 & !is_branch1) begin
						if (H == pointer_register0) begin
							writeEn3 = 0;
						end
						else if (H == pointer_register1) begin
							writeEn7 = 0;
						end
						else if (H == pointer_register2) begin
							writeEn11 = 0;
						end
					end
				end 
				else if (H != 2'b00) begin 
					// Check which MT H uses
					if (H == pointer_register0) begin
						writeEn3 = !way3modified0;
					end
					else if (H == pointer_register1) begin
						writeEn7 = !way3modified1;
					end
					else if (H == pointer_register2) begin
						writeEn11 = !way3modified2;
					end
				end
			end
		end
	end
	
endmodule