module ALU (operand1, operand2, opSel, result );


	input signed [31: 0] operand1, operand2;
	input [3:0] opSel;

	output reg [32:0] result;

	parameter 	_ADD  = 4'b0001,
					_SUB  = 4'b0010,
					_AND  = 4'b0011, 
					_OR   = 4'b0100,
					_NOR  = 4'b0101,
					_SLL  = 4'b0110,
					_SRL  = 4'b0111,
					_XOR  = 4'b1000,     
					_SLT  = 4'b1001,
					_SGT  = 4'b1010;

					
	always @ (*) begin
	result=33'b0;
		case(opSel)
			_ADD: result[31:0] = operand1 + operand2;
			_SUB: result[31:0] = operand1 - operand2;
			_AND: result[31:0] = operand1 & operand2;
			_OR:  result[31:0] = operand1 | operand2;
			_NOR: result[31:0] = ~(operand1 | operand2);
			_XOR: result[31:0] = operand1 ^ operand2;
			_SLT: result[31:0] = (operand1 < operand2) ? 1 : 0; 
			_SLL: result[31:0] = (operand1 << operand2[4:0]);
			_SRL: result[31:0] = (operand1 >> operand2[4:0]);
			_SGT: result[31:0] = (operand1 > operand2) ? 1 : 0;
			default :;
		endcase
		if(opSel != 4'b0) result[32] = 1'b1;
	end
	
	
endmodule