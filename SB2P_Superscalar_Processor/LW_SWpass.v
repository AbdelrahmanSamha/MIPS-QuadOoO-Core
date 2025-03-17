module LW_SWpass(
  input clk,reset,
  input [31:0] lsu0_Rt_source,lsu1_Rt_source,
  input [31:0] inpaddress0,inpaddress1,
  input [5:0] lsu0_dest,lsu1_dest,
  input write0,write1,
  input rden0,rden1,
  input [4:0] lsu0_ROBentry, lsu1_ROBentry,
  input [6:0]BIDs_flush,
  input [1:0]lsu0_bid ,lsu1_bid,
  input [4:0]ROB_commit0,ROB_commit1,
  input PNR_sw0,PNR_sw1,
  
  input valid_lsu0_in, valid_lsu1_in,
  
  input all_done,

  input dep_sw0_sw1_mux, dep_lw0_sw1,
  output valid_lsu0_out, valid_lsu1_out,		
  

  output [5:0] lsu0_dest_out_flip_dep, lsu1_dest_out_flip_dep,
  
  output [32:0] lsu0_result_ES_flip_dep, lsu1_result_ES_flip_dep_final_out,
  
  output [4:0] lsu0_ROBentry_out_flip_dep, lsu1_ROBentry_out_flip_dep,
  
  output valid0_lw_sw_rob_out_flip_dep, valid1_lw_sw_rob_out_flip_dep,

  output isfull,
  output [2:0] size_cache,
  output [1:0] number_of_commit,
  
  input dep_sw0_lw1
  );

wire [32:0] lsu1_result_ES_flip_dep;

wire [5:0] lsu0_dest_out,lsu1_dest_out;
reg [32:0]  lsu0_result_ES, lsu1_result_ES;
wire [4:0] lsu0_ROBentry_out, lsu1_ROBentry_out;
wire valid0_lw_sw_rob_out, valid1_lw_sw_rob_out;


  
wire [46:0] dataout0,dataout1,dataout2,dataout3;	
wire [31:0] Data_out0,Data_out1,Address_out0,Address_out1;	
wire sel_out_mem0,sel_out_mem1;
wire [31:0] data_cache0,data_cache1;
wire [31:0] q_a,q_b; 	
wire rden0out, rden1out, write0out, write1out;
wire [31:0] outmem0,outmem1; 
wire [13:0]address_mem0,address_mem1;

wire write_en0,write_en1;
wire flush_cache,flush_0Cache,flush_1Cache,flush_2Cache,flush_3Cache;
wire sel_mux_address0_mem,sel_mux_address1_mem;
wire [13:0]address_sw_cache0,address_sw_cache1;
wire [4:0] ROB_SWcache0,ROB_SWcache1,ROB_SWcache2,ROB_SWcache3;
wire [1:0]BID_PASS0_out,BID_PASS1_out;
wire [1:0]BID_SWcache0_out,BID_SWcache1_out,BID_SWcache2_out,BID_SWcache3_out;
wire [31:0] Data_Sw_to_memory0,Data_Sw_to_memory1;
wire write0_in;

wire  priority_read_0,priority_read_1,priority_read_2,priority_read_3;


mux2 #(1) dependency_mux_sw_Sw (.in0(write0), .in1(1'b0), .sel(dep_sw0_sw1_mux), .out(write0_in));

wire dep_sw0_sw1_mux_out;

wire [1:0] BID_PASS0_out_final,BID_PASS1_out_final;

wire write0out_final, write1out_final;


mux2 #(14) mux_address_mem0(.in0(inpaddress0[13:0]),.in1(address_sw_cache0),.sel(sel_mux_address0_mem),.out(address_mem0));
mux2 #(14) mux_address_mem1(.in0(inpaddress1[13:0]),.in1(address_sw_cache1),.sel(sel_mux_address1_mem),.out(address_mem1));

wire dep_sw0_lw1_out;
wire dep_lw0_sw1_out;

 Data_MEM Data_MEM1(.address_a(address_mem0),
   .address_b(address_mem1),
	
	.clock(clk),
	
	.data_a(Data_Sw_to_memory0),
	.data_b(Data_Sw_to_memory1),
	
	.rden_a(rden0),
	.rden_b(rden1),
	
	.wren_a(write_en0),
	.wren_b(write_en1),
	
	.q_a(q_a),
	.q_b(q_b));

	
mux2 #(32) mux_data_mem0(.in0(q_a),.in1(data_cache0),.sel(sel_out_mem0),.out(outmem0));
mux2 #(32) mux_data_mem1(.in0(q_b),.in1(data_cache1),.sel(sel_out_mem1),.out(outmem1));

controller_LS controller_ls(
     .SW_Port0(dataout0),.SW_Port1(dataout1),.SW_Port2(dataout2),.SW_Port3(dataout3),
     .datamem0(q_a),.datamem1(q_b),
     .Address_mem0(Address_out0[13:0]),.Address_mem1(Address_out1[13:0]),
	  .Read0(rden0out),.Read1(rden1out),
     .sel_outmem0(sel_out_mem0),.sel_outmem1(sel_out_mem1),
     .data_cache0(data_cache0),.data_cache1(data_cache1),
	  .write_sw0(write0out),.write_sw1(write1out),
	  
	  .BID_Flush(BIDs_flush),
	  .ROB_SWcache0(ROB_SWcache0),.ROB_SWcache1(ROB_SWcache1),.ROB_SWcache2(ROB_SWcache2),.ROB_SWcache3(ROB_SWcache3),
	  .BID_SWcache0(BID_SWcache0_out),.BID_SWcache1(BID_SWcache1_out),.BID_SWcache2(BID_SWcache2_out),.BID_SWcache3(BID_SWcache3_out),
	  .ROB_commit0(ROB_commit0),.ROB_commit1(ROB_commit1),
	  .PNR_sw0(PNR_sw0),.PNR_sw1(PNR_sw1),
	  
	  
	  .write_en0(write_en0),.write_en1(write_en1),
	  .flush_0Cache(flush_0Cache),.flush_1Cache(flush_1Cache),.flush_2Cache(flush_2Cache),.flush_3Cache(flush_3Cache),
	  .sel_mux_address0_mem(sel_mux_address0_mem),.sel_mux_address1_mem(sel_mux_address1_mem),
	  .address_sw_cache0(address_sw_cache0),.address_sw_cache1(address_sw_cache1),
	  .Data_Sw_to_memory0(Data_Sw_to_memory0),.Data_Sw_to_memory1(Data_Sw_to_memory1),
	  .flush_cache(flush_cache),
	  .size_cache(size_cache),
	  .number_of_commit(number_of_commit),
	  .all_done(all_done),
	  .priority_read_0(priority_read_0),
	  .priority_read_1(priority_read_1),
	  .priority_read_2(priority_read_2),
	  .priority_read_3(priority_read_3)  
	  );  
	  
	  ///LSUPipe
pipe_SW_cache pipe_SW_cache1(
 .clk(clk),.reset(reset),
 .Data_in0(lsu0_Rt_source),.Data_in1(lsu1_Rt_source),.Address_in0(inpaddress0),.Address_in1(inpaddress1),
 .lsu0_dest_in(lsu0_dest),.lsu1_dest_in(lsu1_dest),
 .lsu0_ROBentry(lsu0_ROBentry),.lsu1_ROBentry(lsu1_ROBentry),
 .rden0in(rden0), .rden1in(rden1), 
 .write0in(write0_in), .write1in(write1), 
 .BID_PASS0(lsu0_bid),.BID_PASS1(lsu1_bid),
 
 .valid_lsu0_in(valid_lsu0_in), 
 .valid_lsu1_in(valid_lsu1_in),
	
 .valid_lsu0_out(valid_lsu0_out),
 .valid_lsu1_out(valid_lsu1_out),
 
 .dep_lw0_sw1_in(dep_lw0_sw1),
 .dep_lw0_sw1_out(dep_lw0_sw1_out),
 
 
 .dep_sw0_lw1(dep_sw0_lw1),
 .dep_sw0_lw1_out(dep_sw0_lw1_out),
 
 
 .dep_sw0_sw1_mux(dep_sw0_sw1_mux),
 .dep_sw0_sw1_mux_out(dep_sw0_sw1_mux_out),
 
 .rden0out(rden0out), .rden1out(rden1out), 
 .write0out(write0out), .write1out(write1out),
 .Data_out0(Data_out0),.Data_out1(Data_out1),.Address_out0(Address_out0),.Address_out1(Address_out1),
 .lsu0_dest_out(lsu0_dest_out),.lsu1_dest_out(lsu1_dest_out),
 .lsu0_ROBentry_out(lsu0_ROBentry_out), .lsu1_ROBentry_out(lsu1_ROBentry_out),
 .BID_PASS0_out(BID_PASS0_out),.BID_PASS1_out(BID_PASS1_out)
);



	assign write0out_final = (!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS0_out_final}]) ? 1'b0 : write0out;
	assign write1out_final = (!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS1_out_final}]) ? 1'b0 : write1out;
		




SWCache SWCache1 (.clk(clk) ,.reset(reset),
	.flush0(flush_0Cache),.flush1(flush_1Cache),.flush2(flush_2Cache),.flush3(flush_3Cache),
	.Write0(write0out_final),.Write1(write1out_final),
   .address0(Address_out0[13:0]),.address1(Address_out1[13:0]),
   .datain0(Data_out0),.datain1(Data_out1),
	.flush_cache(flush_cache),
	.lsu0_ROBentry_in(lsu0_ROBentry_out),.lsu1_ROBentry_in(lsu1_ROBentry_out),
	.BID_SWcache0_in(BID_PASS0_out_final),.BID_SWcache1_in(BID_PASS1_out_final),
   
	.dataout0(dataout0),.dataout1(dataout1),.dataout2(dataout2),.dataout3(dataout3),
	.ROB_SWcache0(ROB_SWcache0),.ROB_SWcache1(ROB_SWcache1),.ROB_SWcache2(ROB_SWcache2),.ROB_SWcache3(ROB_SWcache3),
	.BID_SWcache0_out(BID_SWcache0_out),.BID_SWcache1_out(BID_SWcache1_out),.BID_SWcache2_out(BID_SWcache2_out),.BID_SWcache3_out(BID_SWcache3_out),
   .isfull(isfull),
	.priority_read_0(priority_read_0),
	.priority_read_1(priority_read_1),
	.priority_read_2(priority_read_2),
	.priority_read_3(priority_read_3),
	.BIDs_flush(BIDs_flush)
	);

		assign BID_PASS0_out_final = (BIDs_flush[6] && BIDs_flush[BID_PASS0_out]) ? BIDs_flush[5:4] :BID_PASS0_out;
		assign BID_PASS1_out_final = (BIDs_flush[6] && BIDs_flush[BID_PASS1_out]) ? BIDs_flush[5:4] :BID_PASS1_out;
		
	
	

always @(*)begin 
lsu0_result_ES = 33'b0;
lsu1_result_ES = 33'b0;


if (rden0out && !(!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS0_out_final}])) lsu0_result_ES = {1'b1,outmem0};
if (rden1out && !(!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS0_out_final}])) lsu1_result_ES = {1'b1,outmem1};


end 	

assign valid0_lw_sw_rob_out = ((write0out | rden0out | dep_sw0_sw1_mux_out) && !(!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS0_out_final}])) ? 1'b1 : 1'b0; 
assign valid1_lw_sw_rob_out = ((write1out | rden1out) && !(!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS1_out}])) ? 1'b1 : 1'b0;


// flip when lw0 and sw1



mux2 #(6) lsu0_dest_flip_mux (.in0(lsu0_dest_out), .in1(lsu1_dest_out), .sel(dep_lw0_sw1_out), .out(lsu0_dest_out_flip_dep));
mux2 #(6) lsu1_dest_flip_mux (.in0(lsu1_dest_out), .in1(lsu0_dest_out), .sel(dep_lw0_sw1_out), .out(lsu1_dest_out_flip_dep));

mux2 #(33) lsu0_result_ES_flip_mux (.in0(lsu0_result_ES), .in1(lsu1_result_ES), .sel(dep_lw0_sw1_out), .out(lsu0_result_ES_flip_dep));
mux2 #(33) lsu1_result_ES_flip_mux (.in0(lsu1_result_ES), .in1(lsu0_result_ES), .sel(dep_lw0_sw1_out), .out(lsu1_result_ES_flip_dep));


mux2 #(5) lsu0_ROBentry_flip_mux (.in0(lsu0_ROBentry_out), .in1(lsu1_ROBentry_out), .sel(dep_lw0_sw1_out), .out(lsu0_ROBentry_out_flip_dep));
mux2 #(5) lsu1_ROBentry_flip_mux (.in0(lsu1_ROBentry_out), .in1(lsu0_ROBentry_out), .sel(dep_lw0_sw1_out), .out(lsu1_ROBentry_out_flip_dep));


mux2 #(1) valid0_lw_sw_rob_flip_mux (.in0(valid0_lw_sw_rob_out), .in1(valid1_lw_sw_rob_out), .sel(dep_lw0_sw1_out), .out(valid0_lw_sw_rob_out_flip_dep));
mux2 #(1) valid1_lw_sw_rob_flip_mux (.in0(valid1_lw_sw_rob_out), .in1(valid0_lw_sw_rob_out), .sel(dep_lw0_sw1_out), .out(valid1_lw_sw_rob_out_flip_dep));



wire [32:0] data_in_dep;

assign data_in_dep = (rden1out && !(!BIDs_flush[6] && BIDs_flush[{1'b0,BID_PASS1_out}])) ? {1'b1,Data_out0} : 33'b0;


//dep

mux2 #(33) lsu1_result_ES_flip_mux_final (.in0(lsu1_result_ES_flip_dep), .in1(data_in_dep), .sel(dep_sw0_lw1_out), .out(lsu1_result_ES_flip_dep_final_out));



	
	
	// Shadow memory declaration
		reg [31:0] shadow_mem [0:4095];  // 1KB memory (1024 x 32-bit)
		
		
		
		
		// Initialize shadow memory
		integer i;  // Declare loop variable outside always block
		always @(posedge clk or posedge reset) begin
			if (reset) begin
				for (i = 0; i < 4096; i = i + 1)
						shadow_mem[i] <= 32'h0;
			end
			else begin
				if (write_en0) shadow_mem[address_mem0] <= Data_Sw_to_memory0;
				if (write_en1) shadow_mem[address_mem1] <= Data_Sw_to_memory1;
			end
		end
		
		
		task print_shadow_mem(input integer file);
    integer i, j;
    begin
        $fwrite(file, "\n================ SHADOW MEMORY STATE (WORD-ADDRESSABLE) ================\n");
        $fwrite(file, "Word Address   | Values (32-bit Hex)\n");
        $fwrite(file, "----------------------------------------------------------\n");
        
        // Modified loop range: 2600-4096
        for (i = 2600; i < 4096; i = i + 8) begin  // Start at 2600, stop before 4096
            $fwrite(file, "0x%04h:    ", i);        // Word address formatting
            for (j = 0; j < 8; j = j + 1) begin
                if ((i + j) >= 2600 && (i + j) < 4000) begin  // Dual safety check
                    $fwrite(file, "%08d ", shadow_mem[i + j]);
                end
                else begin
                    $fwrite(file, "xxxxxxxx ");  // Indicate invalid addresses
                end
            end
            $fwrite(file, "\n");
        end
        
        $fwrite(file, "----------------------------------------------------------\n");
    end
endtask

endmodule


