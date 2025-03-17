module reservation_station (
    clk,
    reset,
    // Read ports
    read_data0,
    read_data1,
    read_data2,
    read_data3,
    read_data4,
    read_data5,
    read_data6,
    read_data7,
    read_data8,
    read_data9,

    // Write ports
    write_index0,
    write_index1,
    write_index2,
    write_index3,

    write_data0,
    write_data1,
    write_data2,
    write_data3,
	 	 
	 write_en_way0,
	 write_en_way1,
	 write_en_way2,
	 write_en_way3,
	 stall_LS,
	 ROB_stall,
	 status,
	 updated_status,
	 BIDs_flush
	
);

    input clk, reset;
	 
    input [3:0] write_index0, write_index1, write_index2, write_index3;
	 
    input [40:0] write_data0, write_data1, write_data2, write_data3;
	
	 input write_en_way0, write_en_way1, write_en_way2, write_en_way3;    
	 input [6:0] BIDs_flush;
	 output reg [40:0] read_data0, read_data1, read_data2, read_data3, read_data4,
                      read_data5, read_data6, read_data7, read_data8, read_data9;
	 input stall_LS;
	 input ROB_stall;				 
	 input [9:0] updated_status;//this must be configured with the incoming instrucitons to figure out whats the new status
	 output reg [9:0] status ;      // Status bits for each register
	 
    reg [40:0] rsv [9:0];  // 10 registers, each 39 bits wide
	 
	wire WriteEn0_arith,WriteEn1_arith, WriteEn2_arith,WriteEn3_arith;
	assign WriteEn0_arith = (stall_LS | ROB_stall)? 1'b0: write_en_way0 ;
	assign WriteEn1_arith = (stall_LS | ROB_stall)? 1'b0: write_en_way1 ;
	assign WriteEn2_arith = (stall_LS | ROB_stall)? 1'b0: write_en_way2 ;
	assign WriteEn3_arith = (stall_LS | ROB_stall)? 1'b0: write_en_way3 ;

    // Reset logic
    always @(posedge clk , posedge reset) begin
		if(reset) begin
        rsv[0] <= 41'd0;
        rsv[1] <= 41'd0;
        rsv[2] <= 41'd0;
        rsv[3] <= 41'd0;
        rsv[4] <= 41'd0;
        rsv[5] <= 41'd0;
        rsv[6] <= 41'd0;
        rsv[7] <= 41'd0;
        rsv[8] <= 41'd0;
        rsv[9] <= 41'd0;

        status[0] <= 1'b1;
        status[1] <= 1'b1;
        status[2] <= 1'b1;
        status[3] <= 1'b1;
        status[4] <= 1'b1;
        status[5] <= 1'b1;
        status[6] <= 1'b1;
        status[7] <= 1'b1;
        status[8] <= 1'b1;
        status[9] <= 1'b1;

    end else begin 
    // Write logic
			status <= status | updated_status;
			if (BIDs_flush[6] && BIDs_flush[rsv[0][35:34]]) rsv[0][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[1][35:34]]) rsv[1][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[2][35:34]]) rsv[2][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[3][35:34]]) rsv[3][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[4][35:34]]) rsv[4][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[5][35:34]]) rsv[5][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[6][35:34]]) rsv[6][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[7][35:34]]) rsv[7][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[8][35:34]]) rsv[8][35:34] <= BIDs_flush[5:4];
			if (BIDs_flush[6] && BIDs_flush[rsv[9][35:34]]) rsv[9][35:34] <= BIDs_flush[5:4];
			
			
			if (WriteEn0_arith) begin
				rsv[write_index0] <= write_data0;
				status[write_index0] <= 1'b0;
			end
			
			if (WriteEn1_arith) begin 
				rsv[write_index1] <= write_data1;
				status[write_index1] <= 1'b0;
			end
			
			if (WriteEn2_arith) begin
				rsv[write_index2] <= write_data2;
				status[write_index2] <= 1'b0;
			end 
		
			if (WriteEn3_arith) begin
				rsv[write_index3] <= write_data3;
				status[write_index3] <= 1'b0;
			end
	end
end

	     // Read logic
    always @(*) begin
        read_data0 = rsv[0];
        read_data1 = rsv[1];
        read_data2 = rsv[2];
        read_data3 = rsv[3];
        read_data4 = rsv[4];
        read_data5 = rsv[5];
        read_data6 = rsv[6];
        read_data7 = rsv[7];
        read_data8 = rsv[8];
        read_data9 = rsv[9];
    end


		
endmodule
