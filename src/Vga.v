/*
---------------------------------------------------

  The generated signals:

  639   640          799   800   1
  /""\__/""\__ ... __/""\__/""\__/""\__  CLK
  ______________________/"""""\________  HRESET
  _________/""""""""""""""""""\________  HBLANK

  480     481               525     1
  """"\_/"""""\_/" ... "\_/"""""\_/""""  VSYNC
  __________________________/"""""""\__  VRESET
  ________/"""""""""""""""""""""""""\__  VBLANK

---------------------------------------------------
*/

`include "Vga_Timing.v"

// Tell if the given (x, y) coordinate is in the visible area of
// the sceeen or not.
`define IS_VISIBLE(x, y) x <= `H_VISIBLE_AREA && y <= `V_VISIBLE_AREA

module Vga(
  input  i_Clk,
  input  i_Video,

  output o_HSync,
  output o_VSync,

  output o_HBlank,
  output o_VBlank,

  output o_HReset,
  output o_VReset,

  output o_Video);

  // Initial position of the H/V counters (useful for testing).
  parameter p_HPOS = 1;
  parameter p_VPOS = 1;

  // X/Y position of the "electron beam".
  reg [9:0] x = p_HPOS;
  reg [9:0] y = p_VPOS;

  // Levels of the RESET signals.
  reg rx = 0;
  reg ry = 0;

  // Levels of the BLANK signals.
  reg bx = 0;
  reg by = 0;

  // Horizontal counter from 1 to H_MAX.
  always @(posedge i_Clk) begin
    if (x == `H_MAX)
      x <= 1;
    else
      x <= x + 1;
  end

  // Shape the horizontal RESET and BLANK signals.
  always @(negedge i_Clk) begin
    rx <= x == `H_MAX - 1;
    bx <= x >= `H_VISIBLE_AREA && x < `H_MAX;
  end

  // Vertical counter from 1 to V_MAX.
  always @(posedge i_Clk) begin
    if (o_HReset) begin
      if (y == `V_MAX)
        y <= 1;
      else
        y <= y + 1;
    end
  end

  // Shape the vertical RESET and BLANK signals.
  always @(negedge i_Clk) begin
    ry <= y == `V_MAX;
    by <= y > `V_VISIBLE_AREA && y <= `V_MAX;
  end

  // Shape the horizontal and vertical sync pulses.
  assign o_HSync = (x < `H_PULSE_HEAD) || (x > `H_PULSE_TAIL);
  assign o_VSync = (y < `V_PULSE_HEAD) || (y > `V_PULSE_TAIL);

  assign o_HBlank = bx;
  assign o_VBlank = by;

  assign o_HReset = rx;
  assign o_VReset = ry;

  // Enable video signal only in the visible area of the screen.
  assign o_Video = (`IS_VISIBLE(x, y) && i_Video);

endmodule
