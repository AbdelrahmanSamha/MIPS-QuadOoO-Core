module branchUnit (
  input [31:0] operand1,
  input [31:0] operand2,
  input [2:0]  operation,
  input prediction,
  input [9:0] immediate,
  input [1:0] BID,          // 2-bit BID (00=non-speculative, 01/10/11=speculative)
  input [1:0] H, M, L,      // Priority table entries (must be 01, 10, or 11)
  output [9:0] address,
  output is_branch,
  output is_Jr,
  output hit, 
  output [6:0] BIDs_flush   // One-hot encoded: [3]BID11, [2]BID10, [1]BID01, [0]unused
);

  wire resolution;
  wire is_BEQ;
  wire is_BNE;
  
  // Priority detection (synthesis-safe)
  wire is_H = (BID == H);
  wire is_M = (BID == M);
  wire is_L = (BID == L);

  // Branch resolution logic
  assign is_BEQ = (operation == 3'b100);
  assign is_BNE = (operation == 3'b011);
  assign is_Jr =  (operation == 3'b111);
  assign is_branch = is_BEQ | is_BNE;
  assign resolution = is_BEQ ? (operand1 == operand2) : (operand1 != operand2);
  assign hit = !(prediction ^ resolution);
  assign address = is_Jr ? operand1[9:0] : immediate;

  // Flush vector generation (priority-aware)
  //we assign a small vector of 4 bits, this vector is sent to the Schedule, Read, Execute stages. 
  //it basically reads the Branch priority table, and if there was a misprediction it sets the bits that corresponds to the branch id
  //example if H was 01 and M, L were 00s. and H was mispredicted then the BID_flush vector value will be 0011, we discard the LSB because its for no speculation, 
  //the LSB will sometimes be 0 and other times 1 but it wont effect the result of the flush signals, its important for indexing though.
  //the stages that require to check if a flush is needed we simply access this vector by saying BID_FLUSh[BID] if the bit was set this means that the instruction that accessed 
  //the vector is part of the speculation. 
  reg [6:0] BIDs_flush_comb;
always @(*) begin
    BIDs_flush_comb = 7'b0000000; // Default to no hit, no flush

    if (is_branch) begin
        if (hit) begin
            // Branch hit: generate new BID and set hit flag
            case (1'b1)
                is_H: begin
                    BIDs_flush_comb[6] = 1'b1; // Hit flag
                    BIDs_flush_comb[5:4] = 2'b00; // New BID = non-speculative
					     BIDs_flush_comb[H] = 1'b1;
                end
                is_M: begin
                    BIDs_flush_comb[6] = 1'b1; // Hit flag
                    BIDs_flush_comb[5:4] = H; // New BID = H
						  BIDs_flush_comb[M] = 1'b1;
                end
                is_L: begin
                    BIDs_flush_comb[6] = 1'b1; // Hit flag
                    BIDs_flush_comb[5:4] = M; // New BID = M
					     BIDs_flush_comb[L] = 1'b1;
                end
            endcase
        end else begin
            // Branch miss: generate flush bits
            case (1'b1)
                is_H:begin
							BIDs_flush_comb[3:0] = (4'b1 << H) | (4'b1 << M) | (4'b1 << L);
							BIDs_flush_comb[5:4] = 2'b00;
					 end
                is_M:begin
							BIDs_flush_comb[3:0] = (4'b1 << M) | (4'b1 << L);
							BIDs_flush_comb[5:4] = H;
					 end
                is_L:begin
							BIDs_flush_comb[3:0] = (4'b1 << L);
							BIDs_flush_comb[5:4] = M;		
					 end
                default: BIDs_flush_comb[3:1] = 4'b0;
            endcase
			
			
            
        end
    end
	
	BIDs_flush_comb[0] = 1'b0;
end

assign BIDs_flush = BIDs_flush_comb;

endmodule



