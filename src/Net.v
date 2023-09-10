`include "Vga_Timing.v"

/*
-----------------------------------------------------
  Draw a dashed line down the middle of the screen.
-----------------------------------------------------
*/

module Net(
  input  i_Clk,
  input  i_HReset,
  input  i_VReset,
  output o_Video);

  parameter p_WIDTH = 8;

  // Shift the net vertically to balance between
  // the top and bottom edges of the screen.
  localparam dy = 4;

  reg [8:0] x = 0;
  reg [3:0] y = dy;

  assign o_Video = (y & 8)
    && x >= `H_VISIBLE_AREA / 2 - p_WIDTH / 2
    && x < `H_VISIBLE_AREA / 2 + p_WIDTH / 2;

  always @(posedge i_Clk) begin
    x <= i_HReset ? 0 : x + 1;

    if (i_HReset) begin
      y <= i_VReset ? dy : y + 1;
    end
  end

endmodule
