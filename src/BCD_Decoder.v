// BCD to 7-segment display decoder
module BCD_Decoder(
  input [3:0] i_BCD,
  output [6:0] o_Segments);

  function [6:0] f(input [3:0] bcd);
    case (bcd)
        4'b0000: f = 7'b1111110;
        4'b0001: f = 7'b0110000;
        4'b0010: f = 7'b1101101;
        4'b0011: f = 7'b1111001;
        4'b0100: f = 7'b0110011;
        4'b0101: f = 7'b1011011;
        4'b0110: f = 7'b1011111;
        4'b0111: f = 7'b1110000;
        4'b1000: f = 7'b1111111;
        4'b1001: f = 7'b1111011;
        default: f = 7'b0000001;
    endcase
  endfunction

  assign o_Segments = f(i_BCD);

endmodule