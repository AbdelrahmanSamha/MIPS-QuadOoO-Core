module SWCache 
( input clk ,reset,
  input flush0,flush1,flush2,flush3,
  input Write0,Write1,
  input [13:0] address0,address1,
  input [31:0] datain0,datain1,
  input flush_cache,
  input [4:0] lsu0_ROBentry_in,lsu1_ROBentry_in,
  input [1:0] BID_SWcache0_in,BID_SWcache1_in,
  
  output [46:0] dataout0,dataout1,dataout2,dataout3,
  output [4:0]ROB_SWcache0,ROB_SWcache1,ROB_SWcache2,ROB_SWcache3,
  output [1:0] BID_SWcache0_out,BID_SWcache1_out,BID_SWcache2_out,BID_SWcache3_out,
  output isfull,
  output priority_read_0,priority_read_1,priority_read_2,priority_read_3,
  input [6:0]BIDs_flush
  );
  reg [54:0] Swcache [3:0]; 
  
    

  
  always @(posedge clk , posedge reset) begin 
     if(reset) begin
       Swcache[0] = 54'b0;
       Swcache[1] = 54'b0;
       Swcache[2] = 54'b0;
       Swcache[3] = 54'b0;
     end   

     else if(flush_cache)begin
	  
	  	  
	  		  
		if (BIDs_flush[6] && BIDs_flush[Swcache[0][53:52]]) Swcache[0][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[1][53:52]]) Swcache[1][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[2][53:52]]) Swcache[2][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[3][53:52]]) Swcache[3][53:52] = BIDs_flush[5:4];
	  

		if (Swcache[0][46] && ( (Swcache[0][45:32] == address0) && Write0) | ( (Swcache[0][45:32] == address1) && Write1)) Swcache[0][54] = 1'b0; 
		if (Swcache[1][46] && ( (Swcache[1][45:32] == address0) && Write0) | ( (Swcache[1][45:32] == address1) && Write1)) Swcache[1][54] = 1'b0;
		if (Swcache[2][46] && ( (Swcache[2][45:32] == address0) && Write0) | ( (Swcache[2][45:32] == address1) && Write1)) Swcache[2][54] = 1'b0;
		if (Swcache[3][46] && ( (Swcache[3][45:32] == address0) && Write0) | ( (Swcache[3][45:32] == address1) && Write1)) Swcache[3][54] = 1'b0;	
	  
	  
	  
	  
	  
	  
			if(flush0)begin 
				Swcache[0] = 54'b0;
			end
			if(flush1)begin 
				Swcache[1] = 54'b0;
			end
			if(flush2)begin 
				Swcache[2] = 54'b0;
			end
			if(flush3)begin 
				Swcache[3] = 54'b0;
			end			
			
			if(Write0) begin 

				if(!Swcache[0][46]) begin 
				  Swcache[0] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};  
				end
				else if(!Swcache[1][46]) begin 
				  Swcache[1] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
				else if(!Swcache[2][46]) begin 
				  Swcache[2] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
				else if(!Swcache[3][46]) begin 
				  Swcache[3] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
			end
		  //
			if(Write1) begin 
			
				if(!Swcache[0][46]) begin 
				  Swcache[0] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};  
				end
				else if(!Swcache[1][46]) begin 
				  Swcache[1] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};
				  
				end 
				else if(!Swcache[2][46]) begin 
				  Swcache[2] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};
				  
				end 
				else if(!Swcache[3][46]) begin 
				  Swcache[3] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};	  
				end 
			end 
		end		
		else if(!isfull) begin // 0 for empty 1 for full 
		
		
		
		
		
			  
	  		  
		if (BIDs_flush[6] && BIDs_flush[Swcache[0][53:52]]) Swcache[0][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[1][53:52]]) Swcache[1][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[2][53:52]]) Swcache[2][53:52] = BIDs_flush[5:4];
		if (BIDs_flush[6] && BIDs_flush[Swcache[3][53:52]]) Swcache[3][53:52] = BIDs_flush[5:4];
	  

		if (Swcache[0][46] && ( (Swcache[0][45:32] == address0) && Write0) | ( (Swcache[0][45:32] == address1) && Write1)) Swcache[0][54] = 1'b0; 
		if (Swcache[1][46] && ( (Swcache[1][45:32] == address0) && Write0) | ( (Swcache[1][45:32] == address1) && Write1)) Swcache[1][54] = 1'b0;
		if (Swcache[2][46] && ( (Swcache[2][45:32] == address0) && Write0) | ( (Swcache[2][45:32] == address1) && Write1)) Swcache[2][54] = 1'b0;
		if (Swcache[3][46] && ( (Swcache[3][45:32] == address0) && Write0) | ( (Swcache[3][45:32] == address1) && Write1)) Swcache[3][54] = 1'b0;	
	  
	  
					 
			if(Write0) begin 
			
				if(!Swcache[0][46]) begin 
				  Swcache[0] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};  
				end
				else if(!Swcache[1][46]) begin 
				  Swcache[1] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
				else if(!Swcache[2][46]) begin 
				  Swcache[2] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
				else if(!Swcache[3][46]) begin 
				  Swcache[3] = {1'b1,BID_SWcache0_in,lsu0_ROBentry_in,1'b1,address0,datain0};
				  
				end 
			end
		  //
			if(Write1) begin
		if(!Swcache[0][46]) begin 
				  Swcache[0] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};  
				end
				else if(!Swcache[1][46]) begin 
				  Swcache[1] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};
				  
				end 
				else if(!Swcache[2][46]) begin 
				  Swcache[2] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};
				  
				end 
				else if(!Swcache[3][46]) begin 
				  Swcache[3] = {1'b1,BID_SWcache1_in,lsu1_ROBentry_in,1'b1,address1,datain1};	  
				end 
			end  
		end 
  end 
  
  
  
  
  
  
 assign priority_read_0 = Swcache[0][54];
 assign priority_read_1 = Swcache[1][54];
 assign priority_read_2 = Swcache[2][54];
 assign priority_read_3 = Swcache[3][54];
 
  
  
  
 assign dataout0 = Swcache[0][46:0] ;
 assign dataout1 = Swcache[1][46:0] ;
 assign dataout2 = Swcache[2][46:0] ;
 assign dataout3 = Swcache[3][46:0] ;
 
 assign ROB_SWcache0 = Swcache[0][51:47];
 assign ROB_SWcache1 = Swcache[1][51:47];
 assign ROB_SWcache2 = Swcache[2][51:47];
 assign ROB_SWcache3 = Swcache[3][51:47];
 
 assign BID_SWcache0_out =Swcache[0][53:52];
 assign BID_SWcache1_out =Swcache[1][53:52];
 assign BID_SWcache2_out =Swcache[2][53:52];
 assign BID_SWcache3_out =Swcache[3][53:52];
 
 
 assign isfull = Swcache[0][46] & Swcache[1][46] & Swcache[2][46] & Swcache[3][46];  
 
 
 
 
 
 
 
 
 task automatic print_SWCache(input integer file);
    integer i;
    reg [53:0] cache_entry;
    begin
        // Print current valid status and isfull signal
		    $fwrite(file, "BIDs FLUSH : %7b", BIDs_flush);
        $fwrite(file, "SWCache Status: [0]:%0d [1]:%0d [2]:%0d [3]:%0d | isfull: %0d\n",
                Swcache[0][46], Swcache[1][46], Swcache[2][46], Swcache[3][46], isfull);
        $fwrite(file, "-------------------------------------------------------------------\n");
        
        // Table headers
			
        $fwrite(file, "Index | BID | ROB | Valid |  Address  |    Data\n");
        $fwrite(file, "-------------------------------------------------------------------\n");
        
        for (i = 0; i < 4; i = i + 1) begin
            cache_entry = Swcache[i];
            $fwrite(file, "%3d | %3d   |%5b| %5d | %8h | %8h\n",
                    i,
                    cache_entry[53:52],  // BID (2 bits)
                    cache_entry[51:47],  // ROB (5 bits)
                    cache_entry[46],     // Valid (1 bit)
                    cache_entry[45:32],  // Address (10 bits) in hex
                    cache_entry[31:0]    // Data (32 bits) in hex
                   );
        end
        $fwrite(file, "-------------------------------------------------------------------\n\n");
    end
endtask
  
endmodule