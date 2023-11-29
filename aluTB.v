// I don't know what this exactly means, but I trust it
`timescale 1ns / 1ps 

module tb_alu;
	reg[31:0] A,B;
	reg[1:0] select;

	wire[31:0] out;
	wire CarryOut;

	integer i;
	alu test_unit(
			A,B,
			select,
			out,
			CarryOut
		);
	initial begin
	// Hold reset state for 100ns. For some reason. 
	A = 32'b01;
	B = 32'b10;
	select = 2'b0;

	for(i = 0; i <= 15; i = i + 1)
	begin
		select = select + 2'b01;
		#10;
	end;

	A = 32'b01101010111011;
	B = 32'b10101011010010;

	end


	initial begin

	$monitor("time=%3d, select= %b, A=%b, B=%b, out=%b, CarryOut=%b \n", $time, select, A, B, out, CarryOut);


	end


endmodule