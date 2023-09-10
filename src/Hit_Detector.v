/*
------------------------------------------------------------------
  Signals if the paddle hits the ball.
------------------------------------------------------------------
*/

module Hit_Detector(
  input  i_Clk,
  input  i_Ball,
  input  i_Paddle,
  output o_Hit);

  assign o_Hit = i_Paddle & i_Ball;

endmodule
