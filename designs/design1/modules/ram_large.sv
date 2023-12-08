// Adopted from https://www.chipverify.com/verilog/verilog-single-port-ram
`include "ram.sv"   // uncomment this if you need it? I think it just makes things crash otherwise.
`include "decoder.sv"

// Our main memory specs: 256Mi x 16 == 2147483648 bits x 16, aka 32768 rows of RAM???
// Ok new plan: we just expand the size of any single RAM chip.
// We're now down to 8192 rows of RAM chips. Still insane. More division by 2 required.
// Ok we're down to 8 rows of RAM chips, and I *think* this works.
// I can confirm the math checks out, and this does in fact represent 256Mi x 16.

// Wait I did this wrong.
// So 256Mi x 16 with a total main memory size of 1 Gi means that each RAM chip must have a total length of 256Mi with a width of 16 bits, and that there should be four chips.
// Meaning that the length of a single chip of RAM is 134217728 bits, aka 256Mi / 16 bits.
// So basically exactly what we had in the starter code, just extended a bit.

// Fixed. I can now confirm with 99% certainty that the memory is correct. It at least has the right dimensions.

`timescale 1 ns / 1 ps

module single_port_sync_ram_large
  # ( parameter ADDR_WIDTH = 14,
      parameter DATA_WIDTH = 16,
      parameter DATA_WIDTH_SHIFT = 1
    )

  (   input clk,
      input [ADDR_WIDTH-1:0] addr,
      inout [DATA_WIDTH-1:0] data,
      input cs_input,
      input we,
      input oe
  );

  wire [3:0] cs;

  decoder #(.ENCODE_WIDTH(2)) dec
  (   .in(addr[ADDR_WIDTH-1:ADDR_WIDTH-2]),
      .out(cs)
  );


  // Col 1:
  single_port_sync_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u00
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[0]),
      .we(we),
      .oe(oe)
  );
  // Col 2:
  single_port_sync_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u01
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[0]),
      .we(we),
      .oe(oe)
  );

  single_port_sync_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u10
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[1]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u11
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[1]),
      .we(we),
      .oe(oe)
  );

  single_port_sync_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u20
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[2]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u21
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[2]),
      .we(we),
      .oe(oe)
  );

  single_port_sync_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u30
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[3]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u31
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-1:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[3]),
      .we(we),
      .oe(oe)
  );


endmodule
