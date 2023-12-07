`timescale 1ns/1ns
module MAR  (
   input wire clk,
  input wire rst,
  input wire [31:0] addressInput,
  output reg [31:0] marOutput
);

  // Input register
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      marOutput <= 32'b0;
    end else begin
      marOutput <= addressInput;
    end
  end

endmodule