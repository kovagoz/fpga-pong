`include "Config.v"
`include "Vga_Timing.v"

/*
------------------------------------------------------------------
  Ball horizontal circuit. The output, o_Video, is asserted when
  the ball is visible in the current column.
------------------------------------------------------------------
*/

module Ball_Horizontal(
  input  i_Clk,
  input  i_HReset,
  input  i_VReset,
  input  i_HBlank,
  input  i_VBlank,
  input  i_HDir,
  output o_Video);

  // How much pixels the ball should move during a frame.
  parameter p_SPEED = 1;

  // How much bits needed to describe the screen's width.
  localparam WIDTH_BITS = $clog2(`H_VISIBLE_AREA);

  // What is the maximum value of the horizontal counter?
  localparam H_COUNTER_MAX = (1 << WIDTH_BITS) - 1;

  // Calculate the counter's initial value if the end is the maximum.
  localparam BALL_HRESET = H_COUNTER_MAX - `H_VISIBLE_AREA;

  // Size of counter's register follows the actual screen size.
  reg [WIDTH_BITS-1:0] pos   = BALL_HRESET;
  reg [2:0]            speed = p_SPEED;

  // This signal indicates that the ball should move along in horizontal
  // direction.
  wire w_Move = i_VBlank && speed > 0;

  // Shape the horizontal component of the ball's video signal.
  assign o_Video = pos > BALL_HRESET + (`H_VISIBLE_AREA - `BALL_SIZE) / 2
    && pos <= BALL_HRESET + (`H_VISIBLE_AREA + `BALL_SIZE) / 2;

  // Horizontal Position Counter
  always @(posedge i_Clk) begin
    if (~i_HBlank) begin
      if (pos == H_COUNTER_MAX) begin
        // In the vertical blank area, we load smaller or larger
        // value into the position register as many times as the
        // speed register indicates. This slip cause then the horizontal
        // motion of the ball. The higher the value in speed register, the
        // faster the ball will move.
        pos <= BALL_HRESET + (w_Move ? i_HDir * 2 : 1);

        if (w_Move) begin
          speed <= speed - 1;
        end
      end else begin
        pos <= pos + 1;
      end
    end

    // Reset the horizontal speed register at the end of the frame.
    if (i_VReset && i_HReset) begin
      speed <= p_SPEED;
    end
  end
endmodule
