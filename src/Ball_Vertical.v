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
  localparam BALL_VRESET = V_COUNTER_MAX - `V_VISIBLE_AREA + 1;

  // Size of counter's register follows the actual screen size.
  reg [HEIGHT_BITS-1:0] pos = BALL_VRESET;

  // Shape the vertical component of the ball's video signal.
  assign o_Video = ~i_VBlank
    && pos > BALL_VRESET + (`V_VISIBLE_AREA - `BALL_SIZE) / 2
    && pos <= BALL_VRESET + (`V_VISIBLE_AREA + `BALL_SIZE) / 2;

  // Vertical Position Counter
  always @(posedge i_Clk) begin
    if (~i_VBlank && i_HReset) begin
      if (pos == V_COUNTER_MAX) begin
        pos <= BALL_VRESET + (i_VDir ? 1 : -1);
      end else begin
        pos <= pos + 1;
      end
    end
  end

endmodule