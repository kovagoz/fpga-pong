`include "Config.v"
`include "Vga_Timing.v"

/*
------------------------------------------------------------------
  Ball horizontal circuit. The output, o_Video, is asserted when
  the ball is visible in the current line.
------------------------------------------------------------------
*/

module Ball_Vertical(
  input  i_Clk,
  input  i_HReset,
  input  i_VBlank,
  input  i_VDir,
  output o_Video);

  // How much bits needed to describe the screen's height.
  localparam HEIGHT_BITS = $clog2(`V_VISIBLE_AREA);

  // What is the maximum value of the vertical counter?
  localparam V_COUNTER_MAX = (1 << HEIGHT_BITS) - 1;

  // Calculate the counter's initial value if the end is the maximum.
  localparam BALL_RESET = V_COUNTER_MAX - `V_VISIBLE_AREA + 1;

  // Initial position can be overwrite for testing.
  parameter p_POS = BALL_RESET;

  // Size of counter's register follows the actual screen size.
  reg [HEIGHT_BITS-1:0] pos = p_POS;

  // Shape the vertical component of the ball's video signal.
  assign o_Video = pos > BALL_RESET + (`V_VISIBLE_AREA - `BALL_SIZE) / 2
    && pos <= BALL_RESET + (`V_VISIBLE_AREA + `BALL_SIZE) / 2;

  // Vertical Position Counter
  always @(posedge i_Clk) begin
    // TODO or i_VBlank && ball_speed > 0
    if (~i_VBlank && i_HReset) begin
      if (pos == V_COUNTER_MAX) begin
        pos <= BALL_RESET + (i_VDir ? 1 : -1);
      end else begin
        pos <= pos + 1;
      end
    end
  end

endmodule
