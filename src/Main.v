`include "Ball_Horizontal.v"
`include "Ball_Vertical.v"
`include "Config.v"
`include "Direction_Control.v"
`include "Hit_Detector.v"
`include "Net.v"
`include "Paddle.v"
`include "Score_Board.v"
`include "Vga.v"

module Main(
  input  i_Clk,

  input  i_Switch_1,
  input  i_Switch_2,
  input  i_Switch_3,
  input  i_Switch_4,

  input  io_PMOD_1,
  output io_PMOD_2,

  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,

  output o_VGA_HSync,
  output o_VGA_VSync,

  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,

  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,

  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2);

  //------------------------------
  //  Paddle
  //------------------------------

  wire w_Paddle_Video;

  Paddle left(
    .i_Clk(i_Clk),
    .i_VSync(o_VGA_VSync),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_555_Output(io_PMOD_1),
    .o_555_Trigger(io_PMOD_2),
    .o_Video(w_Paddle_Video)
  );

  //------------------------------
  //  Hit detector
  //------------------------------

  wire w_Hit;

  Hit_Detector hit(
    .i_Clk(i_Clk),
    .i_Ball(w_Ball_Video),
    .i_Paddle(w_Paddle_Video),
    .o_Hit(w_Hit)
  );

  //------------------------------
  //  Ball Direction Control
  //------------------------------

  wire w_HDir;
  wire w_VDir;

  Direction_Control dir_ctrl(
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_HBall(w_HBall_Video),
    .i_VBall(w_VBall_Video),
    .i_Switch_1(i_Switch_1),
    .i_Switch_2(i_Switch_2),
    .i_Switch_3(i_Switch_3),
    .i_Switch_4(i_Switch_4),
    .i_Hit(w_Hit),
    .o_HDir(w_HDir),
    .o_VDir(w_VDir)
  );

  //------------------------------
  //  Ball
  //------------------------------

  wire w_HBall_Video;

  Ball_Horizontal #(.p_SPEED(3)) ball_h(
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_HDir(w_HDir),
    .o_Video(w_HBall_Video)
  );

  wire w_VBall_Video;

  Ball_Vertical ball_v (
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_VBlank(w_VBlank),
    .i_VDir(w_VDir),
    .o_Video(w_VBall_Video)
  );

  // Create the composite ball video signal
  wire w_Ball_Video = w_HBall_Video & w_VBall_Video;

  //------------------------------
  //  Net
  //------------------------------

  wire w_Net_Video;

  Net net(
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .o_Video(w_Net_Video)
  );

  //------------------------------
  //  Score Board
  //------------------------------

  wire w_Score_Board_Video;

  Score_Board sb(
    .i_Clk(i_Clk),
    .i_HC(w_HC),
    .i_VC(w_VC),
    .o_Video(w_Score_Board_Video)
  );

  //------------------------------
  //  VGA
  //------------------------------

  wire w_HReset;
  wire w_VReset;
  wire w_HBlank;
  wire w_VBlank;
  wire w_Video;
  wire [9:0] w_HC;
  wire [9:0] w_VC;

  Vga vga(
    .i_Clk(i_Clk),
    .i_Video(w_Paddle_Video | w_Ball_Video | w_Net_Video | w_Score_Board_Video),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_HReset(w_HReset),
    .o_VReset(w_VReset),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HC(w_HC),
    .o_VC(w_VC),
    .o_Video(w_Video)
  );

  // Send 1-bit video signal to all VGA outputs => B/W image.

  assign o_VGA_Red_0 = w_Video | (`BALL_TRACKING & w_HBall_Video);
  assign o_VGA_Red_1 = w_Video;
  assign o_VGA_Red_2 = w_Video;

  assign o_VGA_Grn_0 = w_Video | (`BALL_TRACKING & w_VBall_Video);
  assign o_VGA_Grn_1 = w_Video;
  assign o_VGA_Grn_2 = w_Video;

  assign o_VGA_Blu_0 = w_Video;
  assign o_VGA_Blu_1 = w_Video;
  assign o_VGA_Blu_2 = w_Video;

  //------------------------------
  //  Running light
  //------------------------------

  reg [3:0] led_state = 1;

  assign {o_LED_1, o_LED_2, o_LED_3, o_LED_4} = led_state;

  reg [24:0] led_counter = 0;

  always @(posedge i_Clk) begin
    if (led_counter == 12500000) begin
      led_counter <= 0;

      if (led_state == 8)
        led_state <= 1;
      else
        led_state <= led_state << 1;
    end else
      led_counter <= led_counter + 1;
  end

endmodule
