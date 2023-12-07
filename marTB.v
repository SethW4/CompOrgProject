`timescale 1ns/1ns

module tb_MAR;
  reg [31:0] addressInput;
  reg clk, rst;
  wire [31:0] marOutput;

  MAR mar_output (
    .clk(clk),
    .rst(rst),
    .addressInput(addressInput),
    .marOutput(marOutput)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    rst = 1;

    #10 rst = 0;

    #10 addressInput = 32'h0000000F;
    #10 $display("MAR Address held: %h", marOutput);

    #10 $finish;
  end

endmodule
