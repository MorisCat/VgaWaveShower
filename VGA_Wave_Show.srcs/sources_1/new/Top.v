`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/11 10:06:15
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
input                           sys_clk,
input                           sys_rst_p,

output          [3:0]           VGA_R,
output          [3:0]           VGA_G,
output          [3:0]           VGA_B,
output                          HSYNC,
output                          VSYNC
    );
 
 wire                           vga_clk;
 wire                           locked;    
 wire                           mod_rst_p;
 wire           [11:0]          vga_data;
 wire           [11:0]          rgb_data;
 wire           [9:0]           pos_x;
 wire           [9:0]           pos_y;
 wire                           data_valid;
 wire                           img_valid;
 
 assign mod_rst_p = sys_rst_p && locked;
 assign VGA_R     = vga_data[11:8];
 assign VGA_G     = vga_data[7:4];
 assign VGA_B     = vga_data[3:0];
 
clk_wiz_0 u0_clk(
. clk_out1(vga_clk),
. reset(sys_rst_p),
. locked(locked),
. clk_in1(sys_clk)
);

    
VGA_Ctrl u0_VGA_Ctrl(
.vga_clk(vga_clk),
.rst_p(mod_rst_p),
.rgb_data(rgb_data),

.img_data_valid(img_valid),
.vga_data_valid(data_valid),
.vga_data(vga_data),
.vga_hsync(HSYNC),  
.vga_vsync(VSYNC),
.pos_x(pos_x),  
.pos_y(pos_y)   
);


frame_control u0_frame_control(
.vga_clk(vga_clk),
.rst_p(mod_rst_p),

.vga_data_valid(data_valid),
.data_valid(img_valid),
.pos_x(pos_x),
.pos_y(pos_y),
.img_data(rgb_data)  //RGB444
);

endmodule
