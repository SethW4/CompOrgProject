// Adopted from https://www.fpga4student.com/2017/06/Verilog-code-for-ALU.html
`timescale 1ns / 1ps

module alu(
           input [31:0] A,B,  // ALU 32-bit Inputs
           input [2:0] ALU_Sel,// ALU Selection
           output [31:0] ALU_Out // ALU 32-bit Output
    );
    reg [31:0] ALU_Result;
    wire [31:0] tmp;
    assign ALU_Out = ALU_Result; // ALU out
    always @(*)
    begin
        case(ALU_Sel)
        3'b001: // Addition
           ALU_Result = A + B ;
        3'b010: // Subtraction
           ALU_Result = A - B ;
        3'b011: // Clear
           ALU_Result = 0;
         3'b000: // AND
            ALU_Result = A & B;
         3'b100: // OR
            ALU_Result = A | B;
        default: ALU_Result = A;
        endcase
    end

endmodule
