module mapping_table (
    input clk,
    input reset,
    input [1:0] current_branch_ID, // ID of the current branch
    input allocate_table,          // Signal to allocate a table
    input [4:0] arch_reg0,arch_reg1,arch_reg2,arch_reg3,         				  // Architectural register being modified
    input [5:0] old_phys_reg0,old_phys_reg1,old_phys_reg2,old_phys_reg3,     // Old physical register mapping
	 

	 input hit,is_branch_exe,//hit or miss prediction //is branch or not // bit 0 & 1 --> branch ID
	 input [1:0] branch_ID,
	 input is_branch, //wire to tell me if branch exists or not
	 input is_branch0,is_branch1,is_branch2,is_branch3, // which way to bear branch
	 input inst_write0,inst_write1,inst_write2,inst_write3,// signal to tell me if instruction writes on register or not 
	 input [5:0] allocate_dest_Reg0,allocate_dest_Reg1,allocate_dest_Reg2,allocate_dest_Reg3, // allocate_dest_reg for each way 
	 input [63:0] frpool_current_reg,
	 input [1:0] BID0out,BID1out,BID2out,BID3out,
	 input [1:0] H,M,L,
    output reg way0modified0, way0modified1, way0modified2,
	 output reg way1modified0, way1modified1, way1modified2,
	 output reg way2modified0, way2modified1, way2modified2,
	 output reg way3modified0, way3modified1, way3modified2,
	 
	 //write enables from incremental controller
	 input writeEn0, writeEn1, writeEn2, writeEn3, writeEn4, writeEn5, writeEn6, writeEn7,writeEn8, writeEn9, writeEn10,writeEn11,
	 
	 input stallafterdecode,
	 //wire enables from commit stage
	 input all_done,PNR0,PNR1,PNR2,PNR3,
	 input [5:0] return_stale0 , return_stale1, return_stale2, return_stale3,
	 
	// Pointer Registers (dynamic assignment of IDs to tables)
	output reg [1:0] Pointer_register0, // Points to MT0
	output reg [1:0] Pointer_register1, // Points to MT1
	output reg [1:0] Pointer_register2, // Points to MT2
	
	//value in MT_Sections to write old value for register in RAT (after branch is resolved)
	output reg [10:0] MT_out0,MT_out1,MT_out2,MT_out3,MT_out4,MT_out5,MT_out6,MT_out7,MT_out8,MT_out9,
	
	
	output  [63:0] status_reg,
	
	output mt_stall
	
);
reg [63:0] commit_word_64 =64'b0;
always @(*) begin 
	commit_word_64 = 64'b0;
	if (all_done) begin 
		if (PNR0) begin
		commit_word_64[return_stale0] = 1'b1;
		end
		if (PNR1) begin
		commit_word_64[return_stale1] = 1'b1;
		end
		if (PNR2) begin
		commit_word_64[return_stale2] = 1'b1;
		end
		if (PNR3) begin
		commit_word_64[return_stale3] = 1'b1;
		end
	end
end

    reg [3:0] write_ptr0, write_ptr1, write_ptr2;
/*
	// Mapping Tables (3 tables, 10 entries each)
	reg [10:0] MT0 [0:9]; // Table 0: 10 entries x 11 bits
	reg [10:0] MT1 [0:9]; // Table 1
	reg [10:0] MT2 [0:9]; // Table 2
*/
    // Memory tables with 10 entries each
    parameter MT_ENTRIES = 10;
    reg [10:0] MT0 [MT_ENTRIES-1:0];
    reg [10:0] MT1 [MT_ENTRIES-1:0];
    reg [10:0] MT2 [MT_ENTRIES-1:0];
	 
	 
	// always block for miss and hit branch_Pred (after branch is resolved)
	
	
	
	
	always @(*)begin

			  MT_out0 = 11'b0;MT_out1 = 11'b0;MT_out2 = 11'b0;MT_out3 = 11'b0; 
			  MT_out4 = 11'b0;MT_out5 = 11'b0;MT_out6 =11'b0;MT_out7 = 11'b0;
			  MT_out9 = 11'b0;MT_out8 =11'b0;
			  


		if(!hit && is_branch_exe)begin

			if( branch_ID== Pointer_register0)begin
				MT_out0 = MT0[0];MT_out1 = MT0[1];MT_out2 = MT0[2];MT_out3 = MT0[3]; 
				MT_out4 = MT0[4];MT_out5 = MT0[5];MT_out6 = MT0[6];MT_out7 = MT0[7];
				MT_out8 = MT0[8];MT_out9 = MT0[9];
				
			end
			else if(branch_ID== Pointer_register1)begin
				MT_out0 = MT1[0];MT_out1 = MT1[1];MT_out2 = MT1[2];MT_out3 = MT1[3]; 
				MT_out4 = MT1[4];MT_out5 = MT1[5];MT_out6 = MT1[6];MT_out7 = MT1[7];
				MT_out8 = MT1[8];MT_out9 = MT1[9];
				
			end
			else if(branch_ID== Pointer_register2)begin
				MT_out0 = MT2[0];MT_out1 = MT2[1];MT_out2 = MT2[2];MT_out3 = MT2[3]; 
				MT_out4 = MT2[4];MT_out5 = MT2[5];MT_out6 = MT2[6];MT_out7 = MT2[7];
				MT_out8 = MT2[8];MT_out9 = MT2[9];
				
			end
		end
	end


	reg [31:0] modified0, modified1, modified2; 
	reg [63:0] status_reg0,status_reg1,status_reg2;
	assign status_reg = (is_branch_exe && !(hit) && (branch_ID == Pointer_register0)) ? status_reg0 :
                       (is_branch_exe && !(hit) && (branch_ID == Pointer_register1)) ? status_reg1 :
                       (is_branch_exe && !(hit) && (branch_ID == Pointer_register2)) ? status_reg2 : 64'b0; 
	// Table Allocation Logic
	always @(posedge clk or posedge reset) begin
		 if (reset) begin
			  Pointer_register0 <= 2'b00; // Initially unassigned
			  Pointer_register1 <= 2'b00;
			  Pointer_register2 <= 2'b00;
			 // status_reg = 64'b0;
		 end 
		 
		 else if(is_branch_exe & allocate_table & !(mt_stall | stallafterdecode))begin 
			if (hit)begin 
				if(branch_ID == Pointer_register0)begin
					Pointer_register0 <= current_branch_ID;
					//status_reg = status_reg0;
				end 
				else if(branch_ID == Pointer_register1)begin
					Pointer_register1 <= current_branch_ID;
					//status_reg = status_reg1;
				end
				else if(branch_ID == Pointer_register2)begin
					Pointer_register2 <= current_branch_ID;
					//status_reg = status_reg2;
				end
			end 
		   else begin 
				if(branch_ID == L)begin
                    if(Pointer_register0 == L) Pointer_register0<=2'b0; 
                    else if(Pointer_register1 == L) Pointer_register1<=2'b0;
                    else if(Pointer_register2 == L) Pointer_register2<=2'b0;

                end 
                else if(branch_ID == M)begin
                    if (Pointer_register0 == L || Pointer_register0 == M) Pointer_register0 <= 2'b0;
                    if (Pointer_register1 == L || Pointer_register1 == M) Pointer_register1 <= 2'b0;
                    if (Pointer_register2 == L || Pointer_register2 == M) Pointer_register2 <= 2'b0;
                end
                else if(branch_ID == H)begin
                    Pointer_register0<=2'b0;
                    Pointer_register1<=2'b0;
                    Pointer_register2<=2'b0;
                end
			end 
		 end 
		 //reset pointer register for branch is resolved
		 else if(is_branch_exe)begin
		   //hit prediction
			if(hit)begin
				if(branch_ID == Pointer_register0)begin
					Pointer_register0 <= 2'b00;
					//status_reg = status_reg0;
				end 
				else if(branch_ID == Pointer_register1)begin
					Pointer_register1 <= 2'b00;
					//status_reg = status_reg1;
				end
				else if(branch_ID == Pointer_register2)begin
					Pointer_register2 <= 2'b00;
					//status_reg = status_reg2;
				end 
			end
			//miss prediction
			else begin
                if(branch_ID == L)begin
                    if(Pointer_register0 == L) Pointer_register0<=2'b0; 
                    else if(Pointer_register1 == L) Pointer_register1<=2'b0;
                    else if(Pointer_register2 == L) Pointer_register2<=2'b0;

                end 
                else if(branch_ID == M)begin
                    if (Pointer_register0 == L || Pointer_register0 == M) Pointer_register0 <= 2'b0;
                    if (Pointer_register1 == L || Pointer_register1 == M) Pointer_register1 <= 2'b0;
                    if (Pointer_register2 == L || Pointer_register2 == M) Pointer_register2 <= 2'b0;
                end
                else if(branch_ID == H)begin
                    Pointer_register0<=2'b0;
                    Pointer_register1<=2'b0;
                    Pointer_register2<=2'b0;
                end
          end
		 end else begin
			  // Allocate a table to the current branch ID
			  if (allocate_table & !(mt_stall | stallafterdecode)) begin
					if (Pointer_register0 == 2'b00) begin
						 Pointer_register0 <= current_branch_ID;
						
					end else if (Pointer_register1 == 2'b00) begin
						 Pointer_register1 <= current_branch_ID;
						 
					end else if (Pointer_register2 == 2'b00) begin
						 Pointer_register2 <= current_branch_ID;
						 
					end 
			  end

		 end
	end


	//modifed registers are 32 bits that indicate what architectural register was modified previously by a branch, 
	//each table has a modified register assigned to it. 
	//we use these registers to check if a new instruction is trying to modify a previously modified mapping. 

	always @(posedge clk or posedge reset)begin 
		if(reset)begin 
			modified0 <= 32'b0;
			modified1 <= 32'b0;
			modified2 <= 32'b0;
		end
		else if(is_branch_exe & !hit)begin //reset modified section after detect branch is resolved ????????????????????
                if(branch_ID == L)begin
                    if(Pointer_register0 == L) modified0<=32'b0; 
                    else if(Pointer_register1 == L) modified1<=32'b0;
                    else if(Pointer_register2 == L) modified2<=32'b0;

                end 
                else if(branch_ID == M)begin
                    if (Pointer_register0 == L || Pointer_register0 == M) modified0 <= 32'b0;
                    if (Pointer_register1 == L || Pointer_register1 == M) modified1 <= 32'b0;
                    if (Pointer_register2 == L || Pointer_register2 == M) modified2 <= 32'b0;
                end
                else if(branch_ID == H)begin
                    modified0<=32'b0;
                    modified1<=32'b0;
                    modified2<=32'b0;
                end
         
		end
		else begin 
			//flip happens here
			//way 0
			if(writeEn0 & !mt_stall)begin
				modified0[arch_reg0] <= 1'b1;
			end
			if(writeEn4 & !mt_stall)begin
				modified1[arch_reg0] <= 1'b1;
			end 
			if(writeEn8 & !mt_stall)begin
				modified2[arch_reg0] <= 1'b1;
			end 
			
			//way 1
			if(writeEn1 & !mt_stall)begin
				modified0[arch_reg1] <= 1'b1;
			end 
			if(writeEn5 & !mt_stall)begin
				modified1[arch_reg1] <= 1'b1;
			end 
			if(writeEn9 & !mt_stall)begin
				modified2[arch_reg1] <= 1'b1;
			end
			
			//way2 
			if(writeEn2 & !mt_stall)begin
				modified0[arch_reg2] <= 1'b1;
			end 
			if(writeEn6 & !mt_stall)begin
				modified1[arch_reg2] <= 1'b1;
			end 
			if(writeEn10& !mt_stall)begin
				modified2[arch_reg2] <= 1'b1;
			end
			
			//way3
			if(writeEn3 & !mt_stall)begin
				modified0[arch_reg3] <= 1'b1;
			end 
			if(writeEn7 & !mt_stall)begin
				modified1[arch_reg3] <= 1'b1;
			end 
			if(writeEn11 & !mt_stall)begin
				modified2[arch_reg3] <= 1'b1;
			end
			if(is_branch_exe & hit) begin
				if(branch_ID == Pointer_register0)begin
					modified0 <= 32'b0;
				end
				else if(branch_ID == Pointer_register1) begin
					modified1 <= 32'b0;
				end
				else if(branch_ID == Pointer_register2) begin
					modified2 <= 32'b0;
				end
			end
			
		end
	end 

	
	always @(*) begin
		 // Way 0
		 way0modified0 = modified0[arch_reg0];
		 way0modified1 = modified1[arch_reg0];
		 way0modified2 = modified2[arch_reg0];

		 // Way 1
		 way1modified0 = modified0[arch_reg1];
		 way1modified1 = modified1[arch_reg1];
		 way1modified2 = modified2[arch_reg1];

		 // Way 2
		 way2modified0 = modified0[arch_reg2];
		 way2modified1 = modified1[arch_reg2];
		 way2modified2 = modified2[arch_reg2];

		 // Way 3
		 way3modified0 = modified0[arch_reg3];
		 way3modified1 = modified1[arch_reg3];
		 way3modified2 = modified2[arch_reg3];
	end


	
	wire [1:0]Branch_ID_Rename;
	assign Branch_ID_Rename = (is_branch0) ? BID0out : (is_branch1) ? BID1out : (is_branch2) ? BID2out : (is_branch3) ? BID3out : 2'b00;

	
	
	
	
	
	reg [63:0]frpool;
    // Reset and write logic
	always @(posedge clk,posedge reset)begin
		if(reset)begin
			status_reg0 = 64'b0;
			status_reg1 = 64'b0;
			status_reg2 = 64'b0;
			frpool = 64'b0;
		end
		else if(is_branch)begin
		
			if(is_branch0)begin
				frpool = frpool_current_reg | commit_word_64;
				frpool[allocate_dest_Reg0] = 1'b1;
				frpool[allocate_dest_Reg1] = 1'b1;
				frpool[allocate_dest_Reg2] = 1'b1;
				frpool[allocate_dest_Reg3] = 1'b1;
			end
			else if(is_branch1)begin
				frpool = frpool_current_reg | commit_word_64; 
				frpool[allocate_dest_Reg0] = (inst_write0) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg1] = 1'b1;
				frpool[allocate_dest_Reg2] = 1'b1;
				frpool[allocate_dest_Reg3] = 1'b1;
			end
			else if(is_branch2)begin
				frpool = frpool_current_reg | commit_word_64; 
				frpool[allocate_dest_Reg0] = (inst_write0) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg1] = (inst_write1) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg2] = 1'b1;
				frpool[allocate_dest_Reg3] = 1'b1; 
			end
			else if(is_branch3)begin
				frpool = frpool_current_reg | commit_word_64; 
				frpool[allocate_dest_Reg0] = (inst_write0) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg1] = (inst_write1) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg2] = (inst_write2) ? 1'b0:1'b1;
				frpool[allocate_dest_Reg3] = 1'b1; 			
			end
				
				
			if(Branch_ID_Rename == Pointer_register0)begin
				status_reg0<=frpool;
				status_reg1 = status_reg1 | commit_word_64;
				status_reg2 = status_reg2 | commit_word_64;
			end 
			else if(Branch_ID_Rename == Pointer_register1)begin
				status_reg1 <=frpool;
				status_reg0 = status_reg0 | commit_word_64;
				status_reg2 = status_reg2 | commit_word_64;
			end
			else if(Branch_ID_Rename == Pointer_register2)begin
				status_reg2 <=frpool;
				status_reg0 = status_reg0 | commit_word_64;
				status_reg1 = status_reg1 | commit_word_64;
			end
			
		end
		else begin
			status_reg0 = status_reg0 | commit_word_64;
			status_reg1 = status_reg1 | commit_word_64;
			status_reg2 = status_reg2 | commit_word_64;
		end
		
	end
	
    always @(posedge clk or posedge reset) begin
        if (reset ) begin
            // Reset write pointers
            write_ptr0 <= 4'h0;
            write_ptr1 <= 4'h0;
            write_ptr2 <= 4'h0;

            // Reset memory tables
            MT0[0] <= 0; MT0[1] <= 0; MT0[2] <= 0; MT0[3] <= 0; MT0[4] <= 0;
            MT0[5] <= 0; MT0[6] <= 0; MT0[7] <= 0; MT0[8] <= 0; MT0[9] <= 0;

            MT1[0] <= 0; MT1[1] <= 0; MT1[2] <= 0; MT1[3] <= 0; MT1[4] <= 0;
            MT1[5] <= 0; MT1[6] <= 0; MT1[7] <= 0; MT1[8] <= 0; MT1[9] <= 0;

            MT2[0] <= 0; MT2[1] <= 0; MT2[2] <= 0; MT2[3] <= 0; MT2[4] <= 0;
            MT2[5] <= 0; MT2[6] <= 0; MT2[7] <= 0; MT2[8] <= 0; MT2[9] <= 0;
        end 
		else if( is_branch_exe && !hit)begin 
				// Reset write pointers
					if(branch_ID ==H)begin
						MT0[0] <= 0; MT0[1] <= 0; MT0[2] <= 0; MT0[3] <= 0; MT0[4] <= 0;
						MT0[5] <= 0; MT0[6] <= 0; MT0[7] <= 0; MT0[8] <= 0; MT0[9] <= 0;

						MT1[0] <= 0; MT1[1] <= 0; MT1[2] <= 0; MT1[3] <= 0; MT1[4] <= 0;
						MT1[5] <= 0; MT1[6] <= 0; MT1[7] <= 0; MT1[8] <= 0; MT1[9] <= 0;

						MT2[0] <= 0; MT2[1] <= 0; MT2[2] <= 0; MT2[3] <= 0; MT2[4] <= 0;
						MT2[5] <= 0; MT2[6] <= 0; MT2[7] <= 0; MT2[8] <= 0; MT2[9] <= 0;
						
						write_ptr0 <= 4'h0;
						write_ptr1 <= 4'h0;
						write_ptr2 <= 4'h0;
					end
					else if(branch_ID ==M)begin
						if(M ==Pointer_register0 || L ==Pointer_register0)begin
							write_ptr0 <= 4'h0;
							MT0[0] <= 0; MT0[1] <= 0; MT0[2] <= 0; MT0[3] <= 0; MT0[4] <= 0;
							MT0[5] <= 0; MT0[6] <= 0; MT0[7] <= 0; MT0[8] <= 0; MT0[9] <= 0;
						end
						if(M ==Pointer_register1 || L ==Pointer_register1)begin
							write_ptr1 <= 4'h0;
							MT1[0] <= 0; MT1[1] <= 0; MT1[2] <= 0; MT1[3] <= 0; MT1[4] <= 0;
							MT1[5] <= 0; MT1[6] <= 0; MT1[7] <= 0; MT1[8] <= 0; MT1[9] <= 0;
						end
						if(M ==Pointer_register2 || L ==Pointer_register2)begin
							write_ptr2 <= 4'h0;
							MT2[0] <= 0; MT2[1] <= 0; MT2[2] <= 0; MT2[3] <= 0; MT2[4] <= 0;
							MT2[5] <= 0; MT2[6] <= 0; MT2[7] <= 0; MT2[8] <= 0; MT2[9] <= 0;
						end
					end
					else if(branch_ID ==L)begin
						if(L ==Pointer_register0)begin
							write_ptr0 <= 4'h0;
							MT0[0] <= 0; MT0[1] <= 0; MT0[2] <= 0; MT0[3] <= 0; MT0[4] <= 0;
							MT0[5] <= 0; MT0[6] <= 0; MT0[7] <= 0; MT0[8] <= 0; MT0[9] <= 0;
						end
						else if(L ==Pointer_register1)begin
							write_ptr1 <= 4'h0;
							MT1[0] <= 0; MT1[1] <= 0; MT1[2] <= 0; MT1[3] <= 0; MT1[4] <= 0;
							MT1[5] <= 0; MT1[6] <= 0; MT1[7] <= 0; MT1[8] <= 0; MT1[9] <= 0;
						end
						else if(L ==Pointer_register2)begin
							write_ptr2 <= 4'h0;
							MT2[0] <= 0; MT2[1] <= 0; MT2[2] <= 0; MT2[3] <= 0; MT2[4] <= 0;
							MT2[5] <= 0; MT2[6] <= 0; MT2[7] <= 0; MT2[8] <= 0; MT2[9] <= 0;
						end
					end
		end
		else begin
            // Write to MT0
            if (writeEn0 & !mt_stall) begin
                MT0[write_ptr0] = {arch_reg0, old_phys_reg0};
                if (write_ptr0 == MT_ENTRIES - 1) write_ptr0 = 4'h0;
                else write_ptr0 = write_ptr0 + 4'h1;
            end
            if (writeEn1 & !mt_stall) begin
                MT0[write_ptr0] = {arch_reg1, old_phys_reg1};
                if (write_ptr0 == MT_ENTRIES - 1) write_ptr0 = 4'h0;
                else write_ptr0 = write_ptr0 + 4'h1;
            end
            if (writeEn2 & !mt_stall) begin
                MT0[write_ptr0] = {arch_reg2, old_phys_reg2};
                if (write_ptr0 == MT_ENTRIES - 1) write_ptr0 = 4'h0;
                else write_ptr0 = write_ptr0 + 4'h1;
            end
            if (writeEn3 & !mt_stall) begin
                MT0[write_ptr0] = {arch_reg3, old_phys_reg3};
                if (write_ptr0 == MT_ENTRIES - 1) write_ptr0 = 4'h0;
                else write_ptr0 = write_ptr0 + 4'h1;
            end

            // Write to MT1
            if (writeEn4 & !mt_stall) begin
                MT1[write_ptr1] = {arch_reg0, old_phys_reg0};
                if (write_ptr1 == MT_ENTRIES - 1) write_ptr1 = 4'h0;
                else write_ptr1 = write_ptr1 + 4'h1;
            end
            if (writeEn5 & !mt_stall) begin
                MT1[write_ptr1] = {arch_reg1, old_phys_reg1};
                if (write_ptr1 == MT_ENTRIES - 1) write_ptr1 = 4'h0;
                else write_ptr1 = write_ptr1 + 4'h1;
            end
            if (writeEn6 & !mt_stall) begin
                MT1[write_ptr1] = {arch_reg2, old_phys_reg2};
                if (write_ptr1 == MT_ENTRIES - 1) write_ptr1 = 4'h0;
                else write_ptr1 = write_ptr1 + 4'h1;
            end
            if (writeEn7 & !mt_stall) begin
                MT1[write_ptr1] = {arch_reg3, old_phys_reg3};
                if (write_ptr1 == MT_ENTRIES - 1) write_ptr1 = 4'h0;
                else write_ptr1 = write_ptr1 + 4'h1;
            end

            // Write to MT2
            if (writeEn8 & !mt_stall) begin
                MT2[write_ptr2] = {arch_reg0, old_phys_reg0};
                if (write_ptr2 == MT_ENTRIES - 1) write_ptr2 = 4'h0;
                else write_ptr2 = write_ptr2 + 4'h1;
            end
            if (writeEn9 & !mt_stall) begin
                MT2[write_ptr2] = {arch_reg1, old_phys_reg1};
                if (write_ptr2 == MT_ENTRIES - 1) write_ptr2 = 4'h0;
                else write_ptr2 = write_ptr2 + 4'h1;
            end
            if (writeEn10 & !mt_stall) begin
                MT2[write_ptr2] = {arch_reg2, old_phys_reg2};
                if (write_ptr2 == MT_ENTRIES - 1) write_ptr2 = 4'h0;
                else write_ptr2 = write_ptr2 + 4'h1;
            end
            if (writeEn11 & !mt_stall) begin
                MT2[write_ptr2] = {arch_reg3, old_phys_reg3};
                if (write_ptr2 == MT_ENTRIES - 1) write_ptr2 = 4'h0;
                else write_ptr2 = write_ptr2 + 4'h1;
            end
			if(is_branch_exe && hit) begin
				if(branch_ID ==Pointer_register0)begin
					write_ptr0 <= 4'h0;
					MT0[0] <= 0; MT0[1] <= 0; MT0[2] <= 0; MT0[3] <= 0; MT0[4] <= 0;
					MT0[5] <= 0; MT0[6] <= 0; MT0[7] <= 0; MT0[8] <= 0; MT0[9] <= 0;
				end
				else if(branch_ID ==Pointer_register1)begin
					write_ptr1 <= 4'h0;
					MT1[0] <= 0; MT1[1] <= 0; MT1[2] <= 0; MT1[3] <= 0; MT1[4] <= 0;
					MT1[5] <= 0; MT1[6] <= 0; MT1[7] <= 0; MT1[8] <= 0; MT1[9] <= 0;
				end
				else if(branch_ID ==Pointer_register2)begin
					write_ptr2 <= 4'h0;
					MT2[0] <= 0; MT2[1] <= 0; MT2[2] <= 0; MT2[3] <= 0; MT2[4] <= 0;
					MT2[5] <= 0; MT2[6] <= 0; MT2[7] <= 0; MT2[8] <= 0; MT2[9] <= 0;
				end
			end
        end
    end

	 
	 
	 
	 
		// Free entry counts for last 4 entries of each table
	wire [2:0] free_count0_last4, free_count1_last4, free_count2_last4;
	
	// Active write request counts for each table
	wire [2:0] write_count0, write_count1, write_count2;
	
	// Stall signals for each table and global stall
	wire stall0, stall1, stall2;
	
	// =============================================
	// Calculate free entries in last 4 locations
	// =============================================
	
	// For MT0: Check entries 6,7,8,9 (last 4)
	assign free_count0_last4 = 
	((MT0[6][10:6] == 5'b0) ? 1'b1 : 1'b0) +  // Entry 6
	((MT0[7][10:6] == 5'b0) ? 1'b1 : 1'b0) +  // Entry 7
	((MT0[8][10:6] == 5'b0) ? 1'b1 : 1'b0) +  // Entry 8
	((MT0[9][10:6] == 5'b0) ? 1'b1 : 1'b0);   // Entry 9
	
	// For MT1: Check entries 6,7,8,9
	assign free_count1_last4 = 
	((MT1[6][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT1[7][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT1[8][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT1[9][10:6] == 5'b0) ? 1'b1 : 1'b0);
	
	// For MT2: Check entries 6,7,8,9
	assign free_count2_last4 = 
	((MT2[6][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT2[7][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT2[8][10:6] == 5'b0) ? 1'b1 : 1'b0) +
	((MT2[9][10:6] == 5'b0) ? 1'b1 : 1'b0);
	
	// =============================================
	// Count active write requests for each table
	// =============================================
	
	// For MT0 (writeEn0-3)
	assign write_count0 = writeEn0 + writeEn1 + writeEn2 + writeEn3;
	
	// For MT1 (writeEn4-7)
	assign write_count1 = writeEn4 + writeEn5 + writeEn6 + writeEn7;
	
	// For MT2 (writeEn8-11)
	assign write_count2 = writeEn8 + writeEn9 + writeEn10 + writeEn11;
	
	// =============================================
	// Generate stall signals
	// =============================================
	
	assign stall0 = (write_count0 > free_count0_last4); // Stall MT0 if writes > free slots
	assign stall1 = (write_count1 > free_count1_last4); // Stall MT1
	assign stall2 = (write_count2 > free_count2_last4); // Stall MT2
	
	assign mt_stall = stall0 | stall1 | stall2; // Global stall if any table stalls
	 
	 
	 
	 //task to monitor the tables : 
	  // Task to print the contents of MT0, MT1, and MT2
    /*task print_mapping_tables;
    integer i;
    begin
        $display("Printing Mapping Tables:");
		  $display("       Pointer_register0: %b   ||       Pointer_register1: %b   ||        Pointer_register2: %b" ,Pointer_register0, Pointer_register1, Pointer_register2 );
        $display("       \tArc[MT0]\tPhysical     ||       Arc[MT1]\tPhysical      ||        Arc[MT2]\tPhysical ");
        
        for (i = 0; i < MT_ENTRIES; i = i + 1) begin
            $display("%0d\t%5d\t%6d\t\t||\t%5d\t%6d\t\t||\t%5d\t%6d", 
                i, 
                MT0[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT0
                MT0[i][10:6],  // 6 bits for physical reg in MT0
                MT1[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT1
                MT1[i][10:6],  // 6 bits for physical reg in MT1
                MT2[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT2
                MT2[i][10:6]   // 6 bits for physical reg in MT2
            );
        end
    end
endtask*/
	
   	
task print_mapping_tables(input integer file);
    integer i;
    begin
        $fwrite(file, "Printing Mapping Tables:\n");
        $fwrite(file, "       Pointer_register0: %b    ||       Pointer_register1: %b  ||        Pointer_register2: %b\n", 
            Pointer_register0, Pointer_register1, Pointer_register2);
        $fwrite(file, "       \tArc[MT0]Physical        ||       Arc[MT1]Physical       ||        Arc[MT2]Physical \n");
        
        for (i = 0; i < MT_ENTRIES; i = i + 1) begin
            $fwrite(file, "%0d\t%5d\t%6d\t\t||\t%5d\t%6d\t\t||\t%5d\t%6d\n", 
                i, 
                MT0[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT0
                MT0[i][10:6],  // 6 bits for physical reg in MT0
                MT1[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT1
                MT1[i][10:6],  // 6 bits for physical reg in MT1
                MT2[i][5:0],   // 5 bits for Arcreg and 6 bits for physical reg in MT2
                MT2[i][10:6]   // 6 bits for physical reg in MT2
            );
        end
    end
endtask

    

endmodule


	