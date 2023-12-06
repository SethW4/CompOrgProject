// 600,000 max bits to be used by L1 cache. 
// That makes 600,000 / 32 = 18,750 max indices. 
// So our max number of indices will be 2^14 = 16,384 indices. 
// Direct Mapped, 1-way associative. 

// Adopted from https://www.chipverify.com/verilog/verilog-single-port-ram
`timescale 1 ns / 1 ps

module cache
  (   input clk,
      inout [31:0] data,
      input found,
      input we,
      input oe
  );

  reg [31:0] tmp_data;
  reg [31:0] mem[15'b100000000000000]; // 16384 spaces
  reg temp_found;

  always @ (posedge clk) begin
    if (we) begin
      mem[data[13:0]][31:14] <= data[31:14]; // tag
      mem[data[13:0]][0] <= 1;               // valid
    end
  end
  
  always @ (negedge clk) begin
    if (!we) begin
    	if(mem[data[13:0]][0] == 1'b1 && mem[data[13:0]][31:14] == data[31:14]) // verify tags against each other
    	begin    
      		tmp_data[31:14] <= mem[data[13:0]][31:14];   // tag
      		tmp_data[13:0] <= data[13:0];                  // index
      		temp_found <= 1;
      	end
      	else begin
      		temp_found <= 0;  // make 'we' = 1 in the superclass after this. 
      	end
    end

  end

  assign data = oe & !we ? tmp_data : 'hz;
  assign found = temp_found; 
endmodule
