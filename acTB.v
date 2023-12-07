`timescale 1ns/1ns

module tb_AC;
  reg clk;
  reg rst;
  reg [31:0] accumulatorIn;
  wire [31:0] accumulatorOut;

  AC ac_out (
   .clk(clk),
   .rst(rst),
   .accumulatorIn(accumulatorIn),
   .accumulatorOut(accumulatorOut)
	);

  integer i;

  always begin
   //wait for 5 time units before executing clock reset
    #5 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    clk = 0;
    rst = 1;
    accumulatorIn = 32'h00000000;

    // Apply initial reset and wait for a few clock cycles
    #10 rst = 0;

    for(i = 0; i <= 15; i = i + 1)
	begin
       //Accumilate two at a time :D
		accumulatorIn = accumulatorIn + 32'b10;
       $display("Accumulator Value: %b", accumulatorOut);
		#10;
	end;


    // End simulation
    #10 $finish;
  end

endmodule