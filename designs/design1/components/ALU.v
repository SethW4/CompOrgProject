module alu(
		input [31:0] A,B, // 32-bit inputs
		input [1:0] select, // selector bits
		output [31:0] out, // output bit
		output cOut      // carry out bit

	);

	reg [31:0] result;
	wire [32:0] temp;
	assign out = result; // output
	assign temp = {1'b0,A} + {1'b0,B};
	assign cOut = temp[32]; // Carry Out assigned

	always @(*)
	begin

		case(select)
		2'b00: // Addition
			result = A + B;
		2'b01: // AND
			result = A & B;
		2'b10: // OR
			result = A | B;
		2'b11: // Subtract
			result = A - B;

		default: result = A + B;
		endcase


	end
endmodule