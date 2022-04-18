/*
------------------------------------------------------------------
  With this module you can change the direction of the ball
  using the buttons on the Go Board.

  For development purpose only.
------------------------------------------------------------------
*/

module Direction_Control(
  input  i_Clk,
  input  i_Switch_1,
  input  i_Switch_2,
  input  i_Switch_3,
  input  i_Switch_4,
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

  always @(posedge i_Clk) begin
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
