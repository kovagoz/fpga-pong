`include "Test_Bench.v"
`include "Vga.v"

/*
-----------------------------------------------------
  Simulate the last visible line and a little more.
-----------------------------------------------------
*/

module Vga_Test();

  `INIT_TEST

  integer i;

  reg clk = 0;

  wire w_HSync;
  wire w_HBlank;
  wire w_VBlank;
  wire w_HReset;

  Vga #(.p_HPOS(1), .p_VPOS(480)) uut(
    .i_Clk(clk),
    .o_HSync(w_HSync),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset)
  );

  initial begin
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
