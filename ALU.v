module alu(
		input [31:0] A,B, // 32-bit inputs
		input [2:0] select, // selector bits
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
		3'b000: // Addition
			result = A + B;
		3'b001: // AND
			result = A & B;
		3'b010: // OR
			result = A | B;
		3'b011: // Subtract
			result = A - B;
		3'b100: // NOT
			result = ~A;

		default: result = A + B;
		endcase


	end
endmodule
