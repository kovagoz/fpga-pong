`include "Ball_Vertical.v"
`include "Config.v"
`include "Test_Bench.v"
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

  // Set the vertical position of the electron beam to the
  // beginning of the last visible line (the bottom left
  // corner of the screen).
  Vga #(.p_HPOS(1), .p_VPOS(`V_VISIBLE_AREA)) vga(
    .i_Clk(clk),
    .o_HSync(w_HSync),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset)
  );

  // Counter's position where the ball's bottom edge is.
  localparam BALL_BOTTOM_EDGE = 1023 - `V_VISIBLE_AREA + 1
    + (`V_VISIBLE_AREA + `BALL_SIZE) / 2;

  Ball_Vertical #(.p_POS(BALL_BOTTOM_EDGE)) uut(
    .i_Clk(clk),
    .i_HReset(w_HReset),
    .i_VBlank(w_VBlank),
    .i_VDir(1),
    .o_Video(w_Ball_Video)
  );

  initial begin
    // Make a little more clock cycles than a single row consists from.
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
