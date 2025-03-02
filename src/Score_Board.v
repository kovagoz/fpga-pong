`include "Score_Display.v"
`include "Vga_Timing.v"

// Display the score counters
module Score_Board(
  input i_Clk,
  input [9:0] i_HC,
  input [9:0] i_VC,
  output o_Video);

  parameter p_TOP  = 24;  // Distance from the top of the screen
  parameter p_DIST = 128; // Distance between the two scores

  wire [1:0] video; // Video signals of the two LED displays

  Score_Display #(
    .p_POSX(`H_VISIBLE_AREA / 2 - p_DIST / 2 - 32),
    .p_POSY(p_TOP)
  ) sd0(
    .i_Score(number),
    .i_HC(i_HC),
    .i_VC(i_VC),
    .o_Video(video[0])
  );

  Score_Display #(
    .p_POSX(`H_VISIBLE_AREA / 2 + p_DIST / 2),
    .p_POSY(p_TOP)
  ) sd1(
    .i_Score(number),
    .i_HC(i_HC),
    .i_VC(i_VC),
    .o_Video(video[1])
  );

  // Merge the two video signals
  assign o_Video = video > 0;

  //------------- TO BE DELETED -------------

  reg [3:0] number = 0;
  reg [24:0] counter = 0;

  always @(posedge i_Clk) begin
    if (counter == 12500000) begin
      counter <= 0;

      if (number < 9)
        number <= number + 1;
      else
        number <= 0;
    end else
      counter <= counter + 1;
  end

endmodule