`include "Ball_Horizontal.v"
`include "Config.v"
`include "Test_Bench.v"
`include "Vga.v"

/*
--------------------------------------------------------
  Simulate the ball and VGA signals at the edge of the
  HBLANK area (the right edge of the screen).
--------------------------------------------------------
*/

module Ball_Horizontal_Test();

  `INIT_TEST

  integer i;

  reg clk = 0;

  wire w_HSync;
  wire w_HBlank;
  wire w_VBlank;
  wire w_HReset;
  wire w_VReset;
  wire w_Ball_Video;

  // Set the position of the electron beam to the beginning of
  // the first visible line (the top left corner of the screen).
  Vga #(.p_HPOS(1), .p_VPOS(1)) vga(
    .i_Clk(clk),
    .o_HSync(w_HSync),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset),
    .o_VReset(w_VReset)
  );

  // Counter's position where the ball's right edge is.
  // localparam BALL_RIGHT_EDGE = 1023 - `H_VISIBLE_AREA + 1
  //   + (`H_VISIBLE_AREA + `BALL_SIZE) / 2;

  Ball_Horizontal #(.p_POS(709)) uut(
    .i_Clk(clk),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_HDir(0),
    .o_Video(w_Ball_Video)
  );

  initial begin
    // Make a little more clock cycles than a single row consists from.
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
