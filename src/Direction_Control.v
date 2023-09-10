/*
------------------------------------------------------------------
  With this module you can change the direction of the ball
  using the buttons on the Go Board.

  For development purpose only.
------------------------------------------------------------------
*/

module Direction_Control(
  input  i_Clk,
  input  i_HReset,
  input  i_VReset,
  input  i_HBlank,
  input  i_VBlank,
  input  i_HBall,
  input  i_VBall,
  input  i_Switch_1,
  input  i_Switch_2,
  input  i_Switch_3,
  input  i_Switch_4,
  input  i_Hit,
  output o_HDir,
  output o_VDir);

  localparam RIGHT = 1'b0;
  localparam LEFT  = 1'b1;
  localparam UP    = 1'b1;
  localparam DOWN  = 1'b0;

  reg hdir = RIGHT;
  reg vdir = UP;

  assign o_HDir = hdir;
  assign o_VDir = vdir;

  always @(negedge i_Clk) begin
    // Bounce off the top edge of the screen.
    if (i_VBall && i_VReset) begin
      vdir <= DOWN;
    end

    // Bounce off the bottom edge of the screen.
    if (i_VBall && i_VBlank) begin
      vdir <= UP;
    end

    // Bounce off the right edge of the screen.
    if (i_HBall && i_HBlank) begin
      hdir <= LEFT;
    end

    // Bounce off the left edge of the screen.
    if (i_HBall && i_HReset) begin
      hdir <= RIGHT;
    end

    if (i_Hit) begin
      hdir <= RIGHT;
    end

    if (i_Switch_1) begin
      hdir <= LEFT;
      vdir <= UP;
    end

    if (i_Switch_2) begin
      hdir <= LEFT;
      vdir <= DOWN;
    end

    if (i_Switch_3) begin
      hdir <= RIGHT;
      vdir <= UP;
    end

    if (i_Switch_4) begin
      hdir <= RIGHT;
      vdir <= DOWN;
    end
  end
endmodule
