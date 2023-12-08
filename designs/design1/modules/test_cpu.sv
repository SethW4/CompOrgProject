`timescale 1 ns / 1 ps

module test_cpu;
  parameter ADDR_WIDTH = 14;
  parameter DATA_WIDTH = 32;

  reg osc;
  localparam period = 10;

  wire clk;
  assign clk = osc;

  reg cs;
  reg we;
  reg oe;
  integer i;
  reg [ADDR_WIDTH-1:0] MAR;
  wire [DATA_WIDTH-1:0] data;
  reg [DATA_WIDTH-1:0] testbench_data;
  assign data = !oe ? testbench_data : 'hz;

  single_port_sync_ram_large  #(.DATA_WIDTH(DATA_WIDTH)) ram
  (   .clk(clk),
   .addr(MAR),
      .data(data[DATA_WIDTH-1:0]),
      .cs_input(cs),
      .we(we),
      .oe(oe)
  );

  reg [31:0] A;
  reg [31:0] B;
  wire [31:0] ALU_Out;
  reg [2:0] ALU_Sel;
  alu alu32(
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out)
     );

  reg [31:0] PC = 'h100;
  reg [31:0] IR = 'h0;
  reg [31:0] MBR = 'h0;
  reg [31:0] AC = 'h0;

  //Store current fibonacci iterator
  integer fib = 1;

  initial osc = 1;  //init clk = 1 for positive-edge triggered
  always begin  // Clock wave
     #period  osc = ~osc;
  end

  initial begin

     $dumpfile("dump.vcd");
     $dumpvars;

    // Direct Addressing Only Implementation
    @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011E;
    @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000120;
    @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011C;
    @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h10000120;
    @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011E;
    @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011C;
    @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h18000120;
    @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011A;
    @(posedge clk) MAR <= 'h110; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h38000122;
    @(posedge clk) MAR <= 'h112; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011A;
    @(posedge clk) MAR <= 'h114; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h28000400;
    @(posedge clk) MAR <= 'h116; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h30000100;
    @(posedge clk) MAR <= 'h118; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h08000000;
    @(posedge clk) MAR <= 'h11A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000009;
    @(posedge clk) MAR <= 'h11C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    @(posedge clk) MAR <= 'h11E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    @(posedge clk) MAR <= 'h120; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000001;
    @(posedge clk) MAR <= 'h122; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000001;


    @(posedge clk) PC <= 'h100;

    $display("Fib:%0d -> AC:%d\n",fib - 1, AC[11:0]);
    $display("Fib:%0d -> AC:%d\n",fib, AC[11:0]);

    for (i = 0; i < 135; i = i+1) begin
          // Fetch
          @(posedge clk) MAR <= PC; we <= 0; cs <= 1; oe <= 1;
          @(posedge clk) IR <= data;
          @(posedge clk) PC <= PC + 2;

          case(IR[30:27])
            4'b0000: begin  // add
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR <= data;
                  @(posedge clk) ALU_Sel <= 'b001; A <= AC; B <= MBR;
                  @(posedge clk) AC <= ALU_Out;
                  @(posedge clk) fib = fib + 1;

                  #1
                  $display("Fib:%0d -> AC:%d\n",fib, AC[11:0]);
            end
        4'b0001: begin  // halt
                  @(posedge clk) PC <= PC - 2;



            end
            4'b0010: begin   // load
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR <= data;
                  @(posedge clk) AC <= MBR;

            end
            4'b0011: begin    // store
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR <= AC;
                  @(posedge clk) we <= 1; oe <= 0; testbench_data <= MBR;



            end
            4'b0100: begin  // clear
                @(posedge clk) AC <= 0;

            end
            4'b0101: begin  // skip
                //$display("%h THIS SKIPS!!!\n", MAR);
                @(posedge clk)
                if(IR[11:10]==2'b01 && AC == 0) PC <= PC + 2;
                else if(IR[11:10]==2'b00 && AC < 0) PC <= PC + 2;
                else if(IR[11:10]==2'b10 && AC > 0) PC <= PC + 2;
                else if(IR[11:10]==2'b01 && AC[26:0] == 27'b111111111111111111111111111) PC <= PC + 2;
            end
            4'b0110: begin // jump
              @(posedge clk) PC <= IR[26:0];
            end

            4'b0111: begin // subtract
            @(posedge clk) MAR <= IR[26:0];
            @(posedge clk) MBR <= data;
            @(posedge clk) ALU_Sel <= 'b010; A <= AC; B <= MBR;
            @(posedge clk) AC <= ALU_Out;
            end

            4'b1000: begin // and
            @(posedge clk) MAR <= IR[26:0];
            @(posedge clk) MBR <= data;
            @(posedge clk) ALU_Sel <= 'b000; A <= AC; B <= MBR;
            @(posedge clk) AC <= ALU_Out;
            end

            4'b1001: begin // or
            @(posedge clk) MAR <= IR[26:0];
            @(posedge clk) MBR <= data;
            @(posedge clk) ALU_Sel <= 'b100; A <= AC; B <= MBR;
            @(posedge clk) AC <= ALU_Out;
            end

            4'b1000: begin // not
            @(posedge clk) AC <= ~AC;
            end

          endcase
    end


    @(posedge clk) MAR <= 'h10D; we <= 0; cs <= 1; oe <= 1;

    @(posedge clk)

   #20 $finish;
  end

endmodule
