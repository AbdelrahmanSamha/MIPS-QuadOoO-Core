module Control_Unit(opcode,funct,control);

  input [5:0] opcode,funct;
  output [5:0] control ; 
  
  reg [3:0] aluop;
  reg [1:0] _4inst;
 
  
  assign control = {_4inst,aluop};
  
  parameter Rtype = 6'h0,ADD = 6'h20,SUB =6'h22,OR = 6'h25,NOR = 6'h27,AND= 6'h24,JR = 6'h8, XOR =6'h26,SLT=6'h2a,SGT=6'h2c;

  parameter ADDI =6'h8 ,ORI = 6'hd,ANDI = 6'hc,LW = 6'h23, SW = 6'h2b,XORi = 6'he,SLTI=6'ha,SLL =6'h3b,SRL = 6'h3c;
  parameter BEQ = 6'h4, BNE = 6'h5,J = 6'h2,JAL = 3'h3; // remove jal 

  always @(*) begin
    aluop = 4'b0000;
	_4inst = 2'b00; 
    case(opcode)
      Rtype: begin
	  _4inst = 2'b00;
          case(funct)
                ADD:begin
			aluop = 4'b0001;
                end
                SUB:begin
			aluop = 4'b0010;
                end
				AND:begin
			aluop = 4'b0011;
                end
                OR:begin
			aluop = 4'b0100;
                end
                NOR:begin
			aluop = 4'b0101;
					end
                JR:begin
		   _4inst = 2'b11;
			aluop = 4'b1111;
                end
                XOR:begin
			aluop = 4'b1000;
                end
				SLT:begin
			aluop = 4'b1001;
				end
				SGT:begin
			aluop = 4'b1010;

		end
		default : aluop = 4'b0000;
          endcase
      end
      ADDI:begin
        aluop = 4'b0001;
		_4inst = 2'b01;
      end
      ORI:begin
        aluop = 4'b0100;
		_4inst = 2'b01;
	  end
      ANDI:begin
        aluop = 4'b0011;
		_4inst = 2'b01;
	  end
      LW:begin
        aluop = 4'b1101;
		_4inst = 2'b01;
	  end
      SW:begin
        aluop = 4'b1110;
		_4inst = 2'b01;
	  end
      XORi:begin
        aluop = 4'b1000;
		_4inst = 2'b01;
	  end
      BEQ:begin
		 aluop= 4'b1100;
		_4inst = 2'b10;
      end
      BNE:begin
		 aluop= 4'b1011;
		_4inst = 2'b10;
      end
      SLTI:begin
        aluop = 4'b1001;
		_4inst = 2'b01;
	  end
		SLL:begin
        aluop = 4'b0110;
		_4inst = 2'b01;
	  end
		SRL:begin
        aluop = 4'b0111;
		_4inst = 2'b01;
	  end	
	  default: begin
		aluop = 4'b0000;
		_4inst = 2'b0; 
	end
    endcase
end
endmodule

