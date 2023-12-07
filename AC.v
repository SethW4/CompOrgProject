module AC(
  input wire clk,
  input wire rst,
  input wire [31:0] accumulatorIn,

  output wire [31:0] accumulatorOut
);

  reg [31:0] result;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      //Reset current result
      result <= 32'h00000000;
    end else begin
      // Add on to accumulatorIn
      result <= result + accumulatorIn;
    end
  end

  assign accumulatorOut = result;

endmodule
