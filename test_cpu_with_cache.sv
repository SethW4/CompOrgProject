`timescale 1 ns / 1 ps

module test_cpu;
  parameter ADDR_WIDTH = 28; // Used to be 24
  parameter DATA_WIDTH = 32;
  
  reg osc;
  localparam period = 50; // Original value was 10. 

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

  reg found;
  wire [DATA_WIDTH-1:0] cache_data;
  reg [DATA_WIDTH-1:0] cache_reg;  // because Verilog is finnicky and you can't just set the value of a wire to something. 

  assign cache_data = cache_reg; // See above. 

  reg cwe;
  reg coe;

  cache the_cache
  ( .clk(clk),
    .data(cache_data), 
    .found(found),
    .we(cwe),
    .oe(coe)
  );

  reg[31:0] answer;


  reg [31:0] A;
  reg [31:0] B;
  wire [31:0] ALU_Out;
  reg [2:0] ALU_Sel;
  alu alu16(
    .A(A),
    .B(B),  // ALU 16-bit Inputs
    .ALU_Sel(ALU_Sel),// ALU Selection
    .ALU_Out(ALU_Out) // ALU 16-bit Output
     );
  
  reg [31:0] PC = 'h100;
  reg [31:0] IR = 'h0;
  reg [31:0] MBR = 'h0;
  reg [31:0] AC = 'h0;

  initial osc = 1;  //init clk = 1 for positive-edge triggered
  always begin  // Clock wave
     #period  osc = ~osc;
  end


    

  initial begin



   
     $dumpfile("dump.vcd");
     $dumpvars;
    // Multiplication by addition program
    //@(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h110C;
    //@(posedge clk) MAR <= 'h101; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h210E;
    //@(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h110D;
    //@(posedge clk) MAR <= 'h103; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h310B;
    //@(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h210D;
    //@(posedge clk) MAR <= 'h105; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h110E;
    //@(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h310F;
    //@(posedge clk) MAR <= 'h107; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h210E;
    //@(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h8400;
    //@(posedge clk) MAR <= 'h109; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h9102;
    //@(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h7000;
    //@(posedge clk) MAR <= 'h10B; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0005;
    //@(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0007;
    //@(posedge clk) MAR <= 'h10D; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0000;
    //@(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0000;
    //@(posedge clk) MAR <= 'h10F; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hFFFF;


    /*
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011E; 
    $display("%h And some other stuff\n", MAR); 
    @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000120;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011C;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h10000120;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011E;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011C;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h18000120;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011A;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h110; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hB8000001;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h112; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011A;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h114; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h28000400;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h116; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h30000100;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h118; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h08000000;
    $display("%h HALT HERE\n", MAR);
    @(posedge clk) MAR <= 'h11A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h7800000A;
    $display("%h MAYBE HALT HERE\n", MAR);
    @(posedge clk) MAR <= 'h11C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h11E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h120; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000001;
    $display("%h\n", MAR);
    @(posedge clk) MAR <= 'h122; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000000;
    $display("%h\n", MAR);
    */


    // New code, and I'm POSITIVE this version works. 
    @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011E;
    @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000120;
    @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011C;
    @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h10000120;
    @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011E;
    @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011C;
    @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h18000120;
    @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000011A;
    @(posedge clk) MAR <= 'h110; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hB8000001;
    @(posedge clk) MAR <= 'h112; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1800011A;
    @(posedge clk) MAR <= 'h114; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h28000400;
    @(posedge clk) MAR <= 'h116; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h30000100;
    @(posedge clk) MAR <= 'h118; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h08000000;
    @(posedge clk) MAR <= 'h11A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h7800000A;
    @(posedge clk) MAR <= 'h11C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    @(posedge clk) MAR <= 'h11E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000000;
    @(posedge clk) MAR <= 'h120; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h78000001;



    @(posedge clk) PC <= 'h100;
    
    for (i = 0; i < 125; i = i+1) begin

          // Fetch
          @(posedge clk) MAR <= PC; we <= 0; cs <= 1; oe <= 1;
          @(posedge clk) IR <= data;
          @(posedge clk) PC <= PC + 1;
          // Decode and execute
          case(IR[31])
          1'b0: begin            // Register addressing

          //$display("%h THIS IS SOMETHING\n", MAR);

          case(IR[30:27])
            4'b0000: begin  // add
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR <= data;
                  @(posedge clk) ALU_Sel <= 'b001; A <= AC; B <= MBR;
                  @(posedge clk) AC <= ALU_Out;
            end 
    		4'b0001: begin  // halt
                  $display("%h THIS IS HALT\n", MAR);
                  @(posedge clk) PC <= 'h122;   // used to be PC - 1. 


                       
            end
            4'b0010: begin   // load
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR = cache_data;                          // this is new, the = instead of <= is intentional. 
                  if(!found) begin
                    @(posedge clk) MBR <= data;  // read from main memory instead 
                    cache_reg <= data;
                    cwe <= 1;
                    coe <= 1;
                    @(posedge clk)
                    cwe <= 0;
                    coe <= 0;
                  end
                                    
                  @(posedge clk) AC <= MBR;
                  #1
                  $display("%b AC %h %d\n", AC, MAR, AC[11:0]);
            end
            4'b0011: begin    // store
                  @(posedge clk) MAR <= IR[26:0];
                  @(posedge clk) MBR <= AC;
                  @(posedge clk) we <= 1; oe <= 0; cwe <= 1; coe <= 1; testbench_data <= MBR; 
                  cache_reg <= MBR; // for write-through. 
                  
                  @(posedge clk)
                  cwe <= 0;
                  coe <= 0;
            end
            4'b0100: begin  // clear
                @(posedge clk) AC <= 0;
                
            end
            4'b0101: begin  // skip 
                @(posedge clk)
                if(IR[11:10]==2'b01 && AC == 0) PC <= PC + 1;
                else if(IR[11:10]==2'b00 && AC < 0) PC <= PC + 1;
                else if(IR[11:10]==2'b10 && AC > 0) PC <= PC + 1;
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
          1'b1: begin          // Immediate addressing

          case(IR[30:27])
            4'b0000: begin  // addi 
                  @(posedge clk) AC <= AC + IR[26:0];
            end 

            4'b0111: begin // subi 
              @(posedge clk) AC <= AC - IR[26:0];
            end

            4'b1000: begin // andi 
              @(posedge clk) AC <= AC & IR[26:0];
            end

            4'b1001: begin // ori 
              @(posedge clk) AC <= AC | IR[26:0];
            end
              
          endcase





          end
          endcase

         
    end
    
      
    @(posedge clk) MAR <= 'h10D; we <= 0; cs <= 1; oe <= 1;
    
    @(posedge clk)
        
   #20 $finish;
  end

endmodule
