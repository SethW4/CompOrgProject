// Adopted from https://www.fpga4student.com/2017/06/Verilog-code-for-ALU.html
`timescale 1ns / 1ps

module test_alu;
//Inputs
reg[31:0] A,B;
reg[1:0] ALU_Sel;

//Outputs
wire[15:0] ALU_Out;
wire cOut;

// Verilog code for ALU
integer i;
alu u0(
            A,B,  // ALU 16-bit Inputs
            ALU_Sel,// ALU Selection
            ALU_Out, // ALU 16-bit Output
  			cOut // ALU carryout bit added
     );
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    A = 32'b10;//binary 2
    B = 32'b01; // binary 1
    ALU_Sel = 2'h0;

      for (i=0;i<4;i=i+1)
      begin

       #10;
        // Display results using $display
        $display("Iteration %0d: A = %b, B = %b, ALU_Sel = %h, ALU_Out = %b, cOut = %b",
                 i, A, B, ALU_Sel, ALU_Out, cOut);

        ALU_Sel = ALU_Sel + 2'h1;
      end;
    end
endmodule
