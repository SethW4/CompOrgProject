`timescale 1ns/1ns

module tb_IR;
  reg clk;
  reg reset;
  reg [31:0] inputData;
  wire [31:0] outputData;

  IR ir_out (
    .clk(clk),
    .reset(reset),
    .inputData(inputData),
    .outputData(outputData)
  );


  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    reset = 1;
    inputData = 32'h100F0001;

    #10 reset = 0;

	 //Random instruction to be decoded later (if output implies data stored in registwer)
    #10 inputData = 32'h5A0F0001;
    #10 $display("Output Data: %h", outputData);

    #10 $finish;
  end

endmodule