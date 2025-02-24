/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_electronick_project (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

//   // All output pins must be assigned. If not used, assign to 0.
//   assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
//   assign uio_out = 0;
//   assign uio_oe  = 0;

//   // List all unused inputs to prevent warnings
//   wire _unused = &{ena, clk, rst_n, 1'b0};


	wire [9:0] h_count, v_count;
	wire [8:0] bird_pos, hole_pos;
	wire [9:0] pipe_pos;
	wire [7:0] score;
	wire red, green, blue;
	wire h_sync, v_sync;
	wire game_button;
	wire bright;
	
	assign uio_oe = 8'b11111111;
	assign uio_out = score;
	
	assign game_button = ui_in[0];
	
	// Tiny VGA PMOD compatible outputs
	assign uo_out[0] = red;    // R1
	assign uo_out[1] = green;  // G1
	assign uo_out[2] = blue;   // B1
	assign uo_out[3] = v_sync; // vsync
	assign uo_out[4] = red;    // R0
	assign uo_out[5] = green;  // G0
	assign uo_out[6] = blue;   // B0
	assign uo_out[7] = h_sync; // hsync
	
	gameControl game (clk, rst_n, v_sync, game_button, bird_pos, hole_pos, pipe_pos, score);
	
	vgaControl controller (clk, rst_n, h_sync, v_sync, bright, h_count, v_count);
	
	bitGen bitGenerator (clk, rst_n, bright, h_count, v_count, bird_pos, hole_pos, pipe_pos, red, green, blue);

endmodule