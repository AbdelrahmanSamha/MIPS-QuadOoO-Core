`timescale 1ns/1ps
module SB2P_Superscalar_Processor_tb;

    reg clk, rst;
    wire stall;
    wire stall_branch_priority_table;
    wire stall_reservation_station;
    wire stall_reservation_station_LS;
    wire ROB_stall;
    wire stall_frpools;
    wire stall_branching_unit;
	 wire mt_stall;
    wire stall_freeid;
    // Branch miss signals
    wire is_branch_ES;
    wire hit;
	 wire stop_fetch;
	
    // Instantiate cycle counters
    reg [31:0] total_cycles;
    reg [31:0] effective_cycles;
    reg [31:0] stall_cycles;
    reg [31:0] stall_branch_priority_table_cycles;
    reg [31:0] stall_reservation_station_cycles;
    reg [31:0] stall_reservation_station_LS_cycles;
    reg [31:0] ROB_stall_cycles;
    reg [31:0] stall_frpools_cycles;
    reg [31:0] stall_branching_unit_cycles;
	 reg [31:0] mt_stall_cycle;
	 reg [31:0] stall_freeid_cycle;
    // Branch miss counter
    reg [31:0] branch_miss_cycles;
	 
    initial begin
        clk = 0;
        rst = 1;
        #4 rst = 0;
         // End the simulation after 10000 ns
    end

    always #5 clk = ~clk;

    // Instantiate the Unit Under Test (UUT)
    SB2P_Superscalar_Processor uut (
        .clk(clk),
        .rst(rst),
        .stall_counter(stall),
        .stall_branch_priority_table(stall_branch_priority_table),
        .stall_reservation_station(stall_reservation_station),
        .stall_reservation_station_LS(stall_reservation_station_LS),
        .ROB_stall(ROB_stall),
        .stall_frpools(stall_frpools),
        .stall_branching_unit(stall_branching_unit),
        .is_branch_ES(is_branch_ES), // Add these to the processor module
        .hit(hit),
		  .stall_freeid(stall_freeid),
		  .mt_stall(mt_stall),
		  .stop_fetch(stop_fetch)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            total_cycles <= 32'd0;
            effective_cycles <= 32'd0;
            stall_cycles <= 32'd0;
            stall_branch_priority_table_cycles <= 32'd0;
            stall_reservation_station_cycles <= 32'd0;
            stall_reservation_station_LS_cycles <= 32'd0;
            ROB_stall_cycles <= 32'd0;
            stall_frpools_cycles <= 32'd0;
            stall_branching_unit_cycles <= 32'd0;
            branch_miss_cycles <= 32'd0;
				mt_stall_cycle <= 32'd0;
				stall_freeid_cycle <= 32'd0;
        end else begin
            total_cycles <= total_cycles + 32'd1; // Always increment total cycles

            if (!stall)
                effective_cycles <= effective_cycles + 32'd1; // Only increment when not stalled
            else
                stall_cycles <= stall_cycles + 32'd1; // Count stall cycles

            // Count specific stall reasons
            if (stall_branch_priority_table) stall_branch_priority_table_cycles <= stall_branch_priority_table_cycles + 1;
            if (stall_reservation_station) stall_reservation_station_cycles <= stall_reservation_station_cycles + 1;
            if (stall_reservation_station_LS) stall_reservation_station_LS_cycles <= stall_reservation_station_LS_cycles + 1;
            if (ROB_stall) ROB_stall_cycles <= ROB_stall_cycles + 1;
            if (stall_frpools) stall_frpools_cycles <= stall_frpools_cycles + 1;
            if (stall_branching_unit) stall_branching_unit_cycles <= stall_branching_unit_cycles + 1;

            // Increment branch miss counter if branch miss occurs
            if (is_branch_ES && !hit)
                branch_miss_cycles <= branch_miss_cycles + 1;
				end
				if(mt_stall) mt_stall_cycle <= mt_stall_cycle +1;
				if (stall_freeid) stall_freeid_cycle <=stall_freeid_cycle + 1 ;
				
    end

    /***************************************************/
	integer dm_log;
	initial begin 
	dm_log =  $fopen("Verification_visuals/dm_output.log","w");
	end
	reg [5:0] signal_counter; // 6-bit counter to count up to 50
	
	//stop conditio, turn off if it causes problems...
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_counter <= 6'd0;
        end else begin
            if (stop_fetch) begin  // Replace 'your_signal' with the actual signal name
                signal_counter <= signal_counter + 1;
                if (signal_counter == 6'd50) begin
                    $display("Signal triggered 50 times. Stopping simulation.");
						   $fdisplay(dm_log, "Cycle count %d", total_cycles);
							uut.execute_stage_inst.lw_swpass.print_shadow_mem(dm_log); // Call task
                    $stop;
						  
                end//
            end else begin
                signal_counter = 6'b0;
                end
        end
    end
	
	//491759
	/*
	//////////////////////////////////transcript window prints, 1 at a time only...../////////////////////////////////////////////////
	// to print out the ROB table for testing, to work you must remove the comment on the task in the ROB module first...
	initial begin
    forever begin
        #10; // Wait for each cycle
		  $display ("Cycle count %d", total_cycles);
        uut.commit.rob_inst.print_rob(); // Call the print function from ROB
    end
	end
	
	initial begin
	 forever begin
    // Wait for some time or events
    #10;
	 $display ("Cycle count %d", total_cycles);
    uut.SS.scheduler.print_ART_table(); // Prints the table for all 10 instructions
	 end
	end
	
	initial begin
    forever begin
        #10; // Wait for the next clock cycle
        uut.rat.print_WriteOperation(); // Print write operations (if any)
        uut.rat.print_RAT();            // Print the RAT contents
    end
	end
	
	initial begin
    forever begin
        #10; // Wait for the next clock cycle
        uut.MT.print_mapping_tables(); // Print write operations (if any)        
    end
	end
	*/
	
	//////////////////////////////////folder prints ...../////////////////////////////////////////////////
	
	integer rob_log, art_log, rat_log, mt_log , swcache_log, rsv_lw_sw_log;
/*
initial begin
    rob_log = $fopen("Verification_visuals/rob_output.log", "w"); // Open a file for ROB table logs
    art_log = $fopen("Verification_visuals/art_output.log", "w"); // Open a file for ART table logs
	 rat_log = $fopen("Verification_visuals/rat_output.log", "w");
    mt_log  = $fopen("Verification_visuals/mt_output.log", "w");
	 swcache_log = $fopen("Verification_visuals/swcache_output.log", "w");

	//ROB
    forever begin
        #10;
        $fdisplay(rob_log, "Cycle count %d", total_cycles);
        uut.commit.rob_inst.print_rob(rob_log); // Print ROB table to file
    end
end


	//ART RESERVATION STATIONS
initial begin
    forever begin
        #10;
        $fdisplay(art_log, "Cycle count %d", total_cycles);
        uut.SS.scheduler.print_ART_table(art_log); // Print ART table to file
    end
end


initial begin
    forever begin
        #10;
        $fdisplay(rat_log, "Cycle count %d", total_cycles);
        uut.rat.print_WriteOperation(rat_log);
        uut.rat.print_RAT(rat_log);
    end
end

initial begin
    forever begin
        #10;
        $fdisplay(mt_log, "Cycle count %d", total_cycles);
        uut.MT.print_mapping_tables(mt_log);
    end
end


initial begin
    rsv_lw_sw_log = $fopen("Verification_visuals/rsv_lw_sw_output.log", "w"); 
    forever begin
        #10; // Align with clock edge
        $fdisplay(rsv_lw_sw_log, "Cycle count %d", total_cycles);
        uut.rsv_lw_sw.print_RSV_LW_SW_TABLE(rsv_lw_sw_log); // Call task
    end
end

initial begin
    dm_log = $fopen("Verification_visuals/dm_output.log", "w"); 
    forever begin
         #100;// Align with clock edge
        $fdisplay(dm_log, "Cycle count %d", total_cycles);
        uut.execute_stage_inst.lw_swpass.print_shadow_mem(dm_log); // Call task
    end
end

initial begin
	forever begin
        #10;
        $fdisplay(swcache_log, "Cycle count %d", total_cycles);
        uut.execute_stage_inst.lw_swpass.SWCache1.print_SWCache(swcache_log);
        end
end
*/
endmodule
	
	