module IR(
  input wire clk,
  input wire reset,
  input wire [31:0] inputData,
  output reg [31:0] outputData
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      //Reset
      outputData <= 32'h00000000;
    end else begin
      outputData <= inputData;
    end
  end

endmodule
