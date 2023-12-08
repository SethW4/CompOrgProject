`timescale 1ns / 1ns

module tb_MBR;
  reg [31:0] dataIn;
  reg enable;
  wire [31:0] dataOut;

  MBR out (
    .dataIn(dataIn),
    .enable(enable),
    .dataOut(dataOut)
  );

  initial begin
    dataIn = 32'h00000001;
    enable = 0;

    for (int i = 0; i < 20; i = i + 1) begin
      #10;
      dataIn = dataIn + 32'b01;
      enable = 1;
      #10 $display("Iteration %0d: dataOut = %h, enable = %b", i, dataOut, enable);
      #10 enable = 0;
    end

    $stop;
  end

endmodule