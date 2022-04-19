`include "Test_Bench.v"
`include "Ball_Vertical.v"
`include "Vga.v"

/*
--------------------------------------------------------
  Simulate the ball and VGA signals at the edge of the
  VBLANK area.
--------------------------------------------------------
*/

module Ball_Vertical_Test();

  `INIT_TEST

  integer i;

  reg clk = 0;

  wire w_HSync;
  wire w_HBlank;
  wire w_VBlank;
  wire w_HReset;
  wire w_Ball_Video;

  Vga #(.p_HPOS(1), .p_VPOS(480)) vga(
    .i_Clk(clk),
    .o_HSync(w_HSync),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset)
  );

  Ball_Vertical #(.p_POS(788)) uut(
    .i_Clk(clk),
    .i_HReset(w_HReset),
    .i_VBlank(w_VBlank),
    .i_VDir(1),
    .o_Video(w_Ball_Video)
  );

  initial begin
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
