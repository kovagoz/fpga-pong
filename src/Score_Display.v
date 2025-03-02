`include "BCD_Decoder.v"
`include "LED_Display.v"

// Display the score of one of the players
module Score_Display(
  input [3:0] i_Score,
  input [9:0] i_HC,
  input [9:0] i_VC,
  output o_Video
);

  parameter p_POSX = 0;
  parameter p_POSY = 0;

  wire [6:0] segments;

  BCD_Decoder bcd(
    .i_BCD(i_Score),
    .o_Segments(segments)
  );

  LED_Display #(
    .p_POSX(p_POSX),
    .p_POSY(p_POSY)
  ) led(
    .i_Segments(segments),
    .i_HC(i_HC),
    .i_VC(i_VC),
    .o_Video(o_Video)
  );

endmodule