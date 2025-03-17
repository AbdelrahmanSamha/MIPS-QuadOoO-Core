module ARF_commit(
    input               clk,
    input               rst,
    
    //==== Control Signals ====//
    input               all_done,       // From ROB
    
    //==== ROB Interface ====//
    input [23:0]       head_bank0,     // From ROB
    input [23:0]       head_bank1,
    input [23:0]       head_bank2,
    input [23:0]       head_bank3,
    
    //==== PRF Interface ====//
    input [31:0]       PRF_value0,     // Value from PRF for bank0's physicalreg
    input [31:0]       PRF_value1,     // Value from PRF for bank1's physicalreg
    input [31:0]       PRF_value2,     // Value from PRF for bank2's physicalreg
    input [31:0]       PRF_value3,     // Value from PRF for bank3's physicalreg
    
    output PNR0, PNR1, PNR2, PNR3      //point of no return for stale register commiting back to the free list. if 1 then the stale must be returned.
		
);

// Extract fields from ROB entries
wire [4:0]  arcreg0;
wire        exception0;
wire 			is_branch0; 
wire 			is_storew0;

assign arcreg0 	= head_bank0[19:15]; 
assign exception0 = head_bank0[0];
assign is_branch0 = head_bank0[20];
assign is_storew0 = head_bank0[21];

wire [4:0]  arcreg1;
wire        exception1; 
wire 			is_branch1; 
wire 			is_storew1;

assign PNR0 =  (!exception0 && !is_storew0 && !is_branch0);

assign arcreg1 	= head_bank1[19:15];
assign exception1 = head_bank1[0];
assign is_branch1 = head_bank1[20];
assign is_storew1 = head_bank1[21];

assign PNR1 =  (!exception1 && !is_storew1 && !is_branch1);

wire [4:0]  arcreg2; 
wire        exception2;
wire 			is_branch2; 
wire 			is_storew2;

assign arcreg2 	= head_bank2[19:15];
assign exception2 = head_bank2[0];
assign is_branch2 = head_bank2[20];
assign is_storew2 = head_bank2[21];

assign PNR2 = (!exception2  && !is_storew2 && !is_branch2);

wire [4:0]  arcreg3; 
wire        exception3; 
wire 			is_branch3; 
wire 			is_storew3;

assign exception3 = head_bank3[0];
assign arcreg3 	= head_bank3[19:15];
assign is_branch3 = head_bank3[20];
assign is_storew3 = head_bank3[21];

assign PNR3 = (!exception3  && !is_storew3 && !is_branch3);
// Architectural Register File
reg [31:0] ARF [0:31];  // 32 registers x 32 bits

always @(posedge clk or posedge rst) begin :ARF_readwrite
	integer i;
    if (rst) begin
         for (i = 0; i < 32; i = i + 1) begin
                ARF[i] = 32'b0;
         end
    end
    else begin
        
        
        if (all_done) begin
            // Commit bank0 entry if valid and no exception
            if (PNR0 && head_bank0[23]) begin  
                ARF[arcreg0] <= PRF_value0;
                
            end
            
            // Commit bank1 entry if valid and no exception
            if (PNR1 && head_bank1[23]) begin
                ARF[arcreg1] <= PRF_value1;
                
            end
            
            // Commit bank2 entry if valid and no exception
            if (PNR2 && head_bank2[23]) begin
                ARF[arcreg2] <= PRF_value2;
                
            end
            
            // Commit bank3 entry if valid and no exception
            if (PNR3 && head_bank3[23]) begin
                ARF[arcreg3] <= PRF_value3;
					 
            end
        end
    end
end

endmodule