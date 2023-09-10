//-------------------------------------
//  Definition of VGA sync pulses
//-------------------------------------

`ifndef VGA_TIMING_V
`define VGA_TIMING_V

// Total width of the screen is 800 pixels.
`define H_VISIBLE_AREA 640
`define H_FRONT_PORCH   16
`define H_PULSE         96
`define H_BACK_PORCH    48

// First clock cycle of the HSync pulse.
`define H_PULSE_HEAD `H_VISIBLE_AREA + `H_FRONT_PORCH + 1
// Last clock cycle of the HSync pulse.
`define H_PULSE_TAIL `H_PULSE_HEAD   + `H_PULSE - 1
// Last clock cycle of the horizontal counter.
`define H_MAX        `H_PULSE_TAIL   + `H_BACK_PORCH

// Total width of the screen is 600 pixels.
`define V_VISIBLE_AREA 480
`define V_FRONT_PORCH   10
`define V_PULSE          2
`define V_BACK_PORCH    33

// First clock cycle of the VSync pulse.
`define V_PULSE_HEAD `V_VISIBLE_AREA + `V_FRONT_PORCH + 1
// Last clock cycle of the VSync pulse.
`define V_PULSE_TAIL `V_PULSE_HEAD   + `V_PULSE - 1
// Last clock cycle of the vertical counter.
`define V_MAX        `V_PULSE_TAIL   + `V_BACK_PORCH

`endif
