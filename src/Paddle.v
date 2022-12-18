module Paddle(
  input i_Clk,
  input i_VSync,
  input i_HReset,
  input i_VReset,
  input i_555_Output, // => i_Enable

  output o_555_Trigger,
  output o_Video);

  // TODO remove the PADDLE prefix
  parameter p_PADDLE_HEIGHT   = 55;
  parameter p_PADDLE_DISTANCE = 30;
  parameter p_PADDLE_WIDTH    = 12;

  // Counter to track the height of the paddle.
  reg [5:0] paddle = 1;

  // Counter to measure the distance from the left edge of the screen.
  // TODO make the size calculated from p_PADDLE_HEIGHT
  reg [5:0] dx = 0;

  // Shape the paddle video signal.
  // TODO split video signal to horizontal and vertical components
  assign o_Video = ~i_555_Output
    && paddle > 0
    && paddle <= p_PADDLE_HEIGHT
    && dx > p_PADDLE_DISTANCE
    && dx < p_PADDLE_DISTANCE + p_PADDLE_WIDTH;

  // Send VSYNC to the 555's trigger pin.
  assign o_555_Trigger = i_VSync;

  // Paddle height counting.
  always @(posedge i_Clk) begin
    if (i_VReset) begin
      paddle <= 1;
    end else if (i_HReset && ~i_555_Output && paddle > 0) begin
      paddle <= paddle + 1;
    end
  end

  // Count pixels from the left edge of the screen.
  always @(posedge i_Clk) begin
    if (i_HReset) begin
      dx <= 0;
    end else if (dx < 63) begin
      dx <= dx + 1;
    end
  end

endmodule
