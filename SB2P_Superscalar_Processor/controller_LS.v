module controller_LS(
    input [46:0] SW_Port0,SW_Port1,SW_Port2,SW_Port3,
    input [31:0] datamem0,datamem1,
    input [13:0] Address_mem0,Address_mem1,
	 input [1:0] BID_SWcache0,BID_SWcache1,BID_SWcache2,BID_SWcache3,
	 input [4:0] ROB_SWcache0,ROB_SWcache1,ROB_SWcache2,ROB_SWcache3,
	 input [4:0] ROB_commit0,ROB_commit1,
    input Read0,Read1,
	 input [6:0]BID_Flush,
	 input PNR_sw0,PNR_sw1,
	 input write_sw0,write_sw1,
	 input all_done,
	 
    output reg sel_outmem0,sel_outmem1,
    output reg [31:0] data_cache0,data_cache1,
	 
	 output reg write_en0,write_en1,
	 output reg flush_0Cache,flush_1Cache,flush_2Cache,flush_3Cache,
	 
	 output reg sel_mux_address0_mem,sel_mux_address1_mem,
	 output reg [13:0] address_sw_cache0,address_sw_cache1,
	 output reg [31:0] Data_Sw_to_memory0,Data_Sw_to_memory1,
	 output flush_cache,
	 output [2:0]size_cache,
	 output reg [1:0] number_of_commit,
	 
	 input priority_read_0,priority_read_1,priority_read_2,priority_read_3
);

assign size_cache = SW_Port0[46] + SW_Port1[46] + SW_Port2[46] + SW_Port3[46] +write_sw0 +write_sw1 - flush_0Cache - flush_1Cache -flush_2Cache -flush_3Cache;

assign flush_cache = flush_0Cache || flush_1Cache || flush_2Cache || flush_3Cache;

always @(*)begin
		write_en0 = 1'b0;
		write_en1 = 1'b0;
		flush_0Cache = 1'b0;
		flush_1Cache = 1'b0;
		flush_2Cache = 1'b0;
		flush_3Cache = 1'b0;
		Data_Sw_to_memory0 =32'b0;
		Data_Sw_to_memory1 =32'b0;
		sel_mux_address0_mem = 1'b0;
		sel_mux_address1_mem = 1'b0;
		
		address_sw_cache0 =14'b0;
		address_sw_cache1 =14'b0;
		
		number_of_commit = 2'h0;

		
		if (!BID_Flush[6] && BID_Flush[BID_SWcache0])begin
			flush_0Cache = 1'b1;
		end
		if (!BID_Flush[6] && BID_Flush[BID_SWcache1])begin
			flush_1Cache = 1'b1;
		end
		if (!BID_Flush[6] && BID_Flush[BID_SWcache2])begin
			flush_2Cache = 1'b1;
		end
		if (!BID_Flush[6] && BID_Flush[BID_SWcache3])begin
			flush_3Cache = 1'b1;
		end
		
		//ROB Commit
	if (all_done) begin 
		if(PNR_sw0)begin
			if((ROB_SWcache0 == ROB_commit0) && SW_Port0[46])begin
				flush_0Cache = 1'b1;
				write_en0 = 1'b1;
				sel_mux_address0_mem = 1'b1;
				address_sw_cache0 =SW_Port0[45:32];
				Data_Sw_to_memory0 = SW_Port0[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache1 == ROB_commit0 && SW_Port1[46])begin
				flush_1Cache = 1'b1;
				write_en0 = 1'b1;
				sel_mux_address0_mem = 1'b1;
				address_sw_cache0 =SW_Port1[45:32];
				Data_Sw_to_memory0 = SW_Port1[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache2 == ROB_commit0 && SW_Port2[46])begin
				flush_2Cache = 1'b1;
				write_en0 = 1'b1;
				sel_mux_address0_mem = 1'b1;
				address_sw_cache0 =SW_Port2[45:32];
				Data_Sw_to_memory0 = SW_Port2[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache3 == ROB_commit0 && SW_Port3[46])begin
				flush_3Cache = 1'b1;
				write_en0 = 1'b1;
				sel_mux_address0_mem = 1'b1;
				address_sw_cache0 =SW_Port3[45:32];
				Data_Sw_to_memory0 = SW_Port3[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
		end
		if(PNR_sw1)begin
			if(ROB_SWcache0 == ROB_commit1 && SW_Port0[46])begin
				flush_0Cache = 1'b1;
				write_en1 = 1'b1;
				sel_mux_address1_mem = 1'b1;
				address_sw_cache1 =SW_Port0[45:32];
				Data_Sw_to_memory1 = SW_Port0[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache1 == ROB_commit1 && SW_Port1[46])begin
				flush_1Cache = 1'b1;
				write_en1 = 1'b1;
				sel_mux_address1_mem = 1'b1;
				address_sw_cache1 =SW_Port1[45:32];
				Data_Sw_to_memory1 = SW_Port1[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache2 == ROB_commit1 && SW_Port2[46])begin
				flush_2Cache = 1'b1;
				write_en1 = 1'b1;
				sel_mux_address1_mem = 1'b1;
				address_sw_cache1 =SW_Port2[45:32];
				Data_Sw_to_memory1 = SW_Port2[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
			else if(ROB_SWcache3 == ROB_commit1 && SW_Port3[46])begin
				flush_3Cache = 1'b1;
				write_en1 = 1'b1;
				sel_mux_address1_mem = 1'b1;
				address_sw_cache1 =SW_Port3[45:32];
				Data_Sw_to_memory1 = SW_Port3[31:0];
				number_of_commit = number_of_commit+ 2'h1;
			end
		end
end
end

always @(*)begin
               data_cache1 = 32'b0;
               sel_outmem1 = 1'b0;
               data_cache0 = 32'b0;
               sel_outmem0 = 1'b0;

        if(Read0)begin
            if(SW_Port3[46] && (SW_Port3[45:32] == Address_mem0) && priority_read_3)begin
                data_cache0 = SW_Port3[31:0];
                sel_outmem0 = 1'b1;
            end
            else if(SW_Port2[46] && (SW_Port2[45:32] == Address_mem0) && priority_read_2)begin
                data_cache0 = SW_Port2[31:0];
                sel_outmem0 = 1'b1;
            end
            else if(SW_Port1[46] && (SW_Port1[45:32] == Address_mem0) && priority_read_1)begin
                data_cache0 = SW_Port1[31:0];
                sel_outmem0 = 1'b1;
            end
            else if(SW_Port0[46] && (SW_Port0[45:32] == Address_mem0) && priority_read_0)begin
                data_cache0 = SW_Port0[31:0];
                sel_outmem0 = 1'b1;
            end
        end

        if(Read1)begin
            if(SW_Port3[46] && (SW_Port3[45:32] == Address_mem1) && priority_read_3)begin
                data_cache1 = SW_Port3[31:0];
                sel_outmem1 = 1'b1;
            end
            else if(SW_Port2[46] && (SW_Port2[45:32] == Address_mem1) && priority_read_2)begin
                data_cache1 = SW_Port2[31:0];
                sel_outmem1 = 1'b1;
            end
            else if(SW_Port1[46] && (SW_Port1[45:32] == Address_mem1) && priority_read_1)begin
                data_cache1 = SW_Port1[31:0];
                sel_outmem1 = 1'b1;
            end
            else if(SW_Port0[46] && (SW_Port0[45:32] == Address_mem1) && priority_read_0)begin
                data_cache1 = SW_Port0[31:0];
                sel_outmem1 = 1'b1;
            end 
        end 

end


endmodule