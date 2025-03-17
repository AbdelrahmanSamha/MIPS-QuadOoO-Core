module LoadStoreReady (
						input is_cache_full, 
						input [5:0] Rtindex, Rsindex,
						input Rtvalid, Rsvalid,
						input is_store,
						input is_load,
						input empty, //recieved from the Status vector
						
						input[5:0] FU0, FU1, FU2,  LSU0, LSU1,
						input [5:0] FU0_readstage, FU1_readstage, FU2_readstage,  LSU0_readstage, LSU1_readstage,
						
						output ready,
						//the following signals must be concatenated with the instruciton if dispatched.
						output reg [1:0] selector_for_Rt_ALUmux , selector_for_Rt_LSUmux,
						output reg Rtforward,
						output reg [1:0] selector_for_Rs_ALUmux , selector_for_Rs_LSUmux,
						output reg Rsforward
);


wire match_Rt_FU0, match_Rt_FU1,match_Rt_FU2,  match_Rt_LS0, match_Rt_LS1;

wire match_Rs_FU0, match_Rs_FU1,match_Rs_FU2,  match_Rs_LS0, match_Rs_LS1;


wire match_Rt_FU0_readstage, match_Rt_FU1_readstage ,match_Rt_FU2_readstage,  match_Rt_LS0_readstage, match_Rt_LS1_readstage;

wire match_Rs_FU0_readstage, match_Rs_FU1_readstage, match_Rs_FU2_readstage,  match_Rs_LS0_readstage, match_Rs_LS1_readstage;




// Rt Matching
assign match_Rt_FU0 = (Rtindex == FU0);
assign match_Rt_FU1 = (Rtindex == FU1);
assign match_Rt_FU2 = (Rtindex == FU2);

assign match_Rt_LS0 = (Rtindex == LSU0);
assign match_Rt_LS1 = (Rtindex == LSU1);

assign match_Rt_FU0_readstage = (Rtindex == FU0_readstage);
assign match_Rt_FU1_readstage = (Rtindex == FU1_readstage);
assign match_Rt_FU2_readstage = (Rtindex == FU2_readstage);

assign match_Rt_LS0_readstage = (Rtindex == LSU0_readstage);
assign match_Rt_LS1_readstage = (Rtindex == LSU1_readstage);

reg Rtready;


// RS Matching

assign match_Rs_FU0 = (Rsindex == FU0);
assign match_Rs_FU1 = (Rsindex == FU1);
assign match_Rs_FU2 = (Rsindex == FU2);

assign match_Rs_LS0 = (Rsindex == LSU0);
assign match_Rs_LS1 = (Rsindex == LSU1);

assign match_Rs_FU0_readstage = (Rsindex == FU0_readstage);
assign match_Rs_FU1_readstage = (Rsindex == FU1_readstage);
assign match_Rs_FU2_readstage = (Rsindex == FU2_readstage);

assign match_Rs_LS0_readstage = (Rsindex == LSU0_readstage);
assign match_Rs_LS1_readstage = (Rsindex == LSU1_readstage);

	
	reg Rsready;
 

/*ABOUT THE MODULE: 
this module is called on each Load Store Station, it scans the entry to see if its operand values are available from the PRF 
or the Bypass network. if the values are available then we mark the entry as ready to be dispatched, but we must check if the Store cache is full before we send a Store operation. 
if the cache was full and a Sw instruction was ready to be dispatched then we abort the dispatching of the instruction, until there is room in the cache to store a value in. 
its the job of the load store scheduler to dispatch memory instruction, this module only tells the scheduler what entries are ready to be dispatched.
 
*/
///
wire Store_cacheFull;
assign Store_cacheFull = (is_store & is_cache_full);

assign ready = ( (Rtready &  Rsready) & !Store_cacheFull);

	
	


	//source1 RT
	always@(*)begin 
		selector_for_Rt_ALUmux = 2'b00;
		selector_for_Rt_LSUmux = 2'b00;
		Rtforward= 1'b0;
		Rtready = 1'b0;
		if (!empty & !is_load)begin 
			if(!Rtvalid)begin
				if(match_Rt_FU0 | match_Rt_FU1 | match_Rt_FU2 |  match_Rt_LS0 | match_Rt_LS1)begin 
					Rtready = 1'b1;
					Rtforward = 1'b0;
				end
				else begin 
					if(match_Rt_FU0_readstage)begin 
						Rtready = 1'b1;
						selector_for_Rt_ALUmux = 2'b10;
						Rtforward = 1'b1;
					end
					if(match_Rt_FU1_readstage)begin 
						Rtready = 1'b1;
						selector_for_Rt_ALUmux = 2'b01;
						Rtforward = 1'b1;
					end
					if(match_Rt_FU2_readstage)begin 
						Rtready = 1'b1;
						selector_for_Rt_ALUmux = 2'b00;
						Rtforward = 1'b1;
					end
					
					if(match_Rt_LS0_readstage)begin 
						Rtready = 1'b1;
						selector_for_Rt_LSUmux = 2'b10;
						Rtforward = 1'b1;
					end
					if(match_Rt_LS1_readstage)begin 
						Rtready = 1'b1;
						selector_for_Rt_LSUmux = 2'b01;
						Rtforward = 1'b1;
					end
				end
			end
			else begin 
				Rtready = 1'b1;
			
			end
		
		end
		else if (!empty & is_load ) begin 
			Rtready = 1'b1;
		
		end 
	end
	
	
	

	
		//source2 
	always@(*)begin 
		selector_for_Rs_ALUmux = 2'b00;
		selector_for_Rs_LSUmux = 2'b00;
		Rsforward= 1'b0;
		Rsready = 1'b0;
		if (!empty )begin 
			if(!Rsvalid)begin
				if(match_Rs_FU0 | match_Rs_FU1 | match_Rs_FU2 |  match_Rs_LS0 | match_Rs_LS1)begin 
					Rsready = 1'b1;
					Rsforward = 1'b0;
				end
				else begin 
					if(match_Rs_FU0_readstage)begin 
						Rsready = 1'b1;
						selector_for_Rs_ALUmux = 2'b10;
						Rsforward = 1'b1;
					end
					if(match_Rs_FU1_readstage)begin 
						Rsready = 1'b1;
						selector_for_Rs_ALUmux = 2'b01;
						Rsforward = 1'b1;
					end
					if(match_Rs_FU2_readstage)begin 
						Rsready = 1'b1;
						selector_for_Rs_ALUmux = 2'b00;
						Rsforward = 1'b1;
					end
					if(match_Rs_LS0_readstage)begin 
						Rsready = 1'b1;
						selector_for_Rs_LSUmux = 2'b10;
						Rsforward = 1'b1;
					end
					if(match_Rs_LS1_readstage)begin 
						Rsready = 1'b1;
						selector_for_Rs_LSUmux = 2'b01;
						Rsforward = 1'b1;
					end
				end
			end
			else begin 
				Rsready = 1'b1;
			
			end
		
		end
	end
	
endmodule 