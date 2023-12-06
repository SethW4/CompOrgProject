module MBR(
  input wire [31:0] dataIn,
  input wire enable,
  output reg [31:0] dataOut
);

  always @(posedge enable)
  begin
    //control when data should be loaded into the register
    if(enable)
      dataOut <= dataIn;
  end

endmodule