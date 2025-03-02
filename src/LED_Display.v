// Define the area of the 7 segments
`define LED_SEGMENT_A 0, 0, 4, 1
`define LED_SEGMENT_B 3, 0, 1, 4
`define LED_SEGMENT_C 3, 3, 1, 4
`define LED_SEGMENT_D 0, 6, 4, 1
`define LED_SEGMENT_E 0, 3, 1, 4
`define LED_SEGMENT_F 0, 0, 1, 4
`define LED_SEGMENT_G 0, 3, 4, 1

// Draw a single digit number on the screen like a 7 segment LED display
module LED_Display(
  input [6:0] i_Segments, // The state of the 7 segments
  input [9:0] i_HC,
  input [9:0] i_VC,
  output o_Video);

  parameter p_POSX = 0;
  parameter p_POSY = 0;
  
  localparam p_DOT_SIZE = 8;

  assign o_Video = i_Segments[6] && in_area(`LED_SEGMENT_A)
    || i_Segments[5] && in_area(`LED_SEGMENT_B)
    || i_Segments[4] && in_area(`LED_SEGMENT_C)
    || i_Segments[3] && in_area(`LED_SEGMENT_D)
    || i_Segments[2] && in_area(`LED_SEGMENT_E)
    || i_Segments[1] && in_area(`LED_SEGMENT_F)
    || i_Segments[0] && in_area(`LED_SEGMENT_G);

  // Check if the electron beam is in the area of the given segment
  function in_area(
    input [3:0] x,
    input [3:0] y,
    input [3:0] w,
    input [3:0] h);

    in_area = (i_HC >= p_POSX + p_DOT_SIZE * x) && (i_HC < p_POSX + p_DOT_SIZE * (x + w))
        && (i_VC >= p_POSY + p_DOT_SIZE * y) && (i_VC < p_POSY + p_DOT_SIZE * (y + h));

  endfunction

endmodule