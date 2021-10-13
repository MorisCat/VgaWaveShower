`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/06 20:45:03
// Design Name: 
// Module Name: VGA_Ctrl
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


module VGA_Ctrl(
input   wire           vga_clk,
input   wire           rst_p,
input   wire   [11:0]  rgb_data,

output  wire   [11:0]  vga_data,
output  wire           vga_data_valid,
output  wire           img_data_valid,
output  wire           vga_hsync,  
output  wire           vga_vsync,
output  wire   [9:0]   pos_x,  
output  wire   [9:0]   pos_y            
    );
 //========================行参数===========================
 parameter     H_SYNC = 10'd96,
                H_BACK_LEFT = 10'd48,
                H_VALID = 10'd640,
                H_FRONT_RIGHT = 10'd16,
                H_TOTAL = 10'd800;
 
  //========================列参数===========================               
 parameter     V_SYNC = 10'd2,
                V_BACK_LEFT = 10'd33,
                V_VALID = 10'd480,
                V_RIGHT_FRONT =  10'd10,
                V_TOTAL = 10'd525;
  //=============显示区域的大小及在屏幕中的位置====================                
 parameter     PIC_X_HIGH = 10'd512,   //显示区域最大x坐标  HIGH == LOW+显示区域的长
                PIC_X_LOW  = 10'd0,     //显示区域最小x坐标
                PIC_Y_HIGH = 10'd460,   //显示区域最大y坐标  HIGH == LOW+显示区域的宽
                PIC_Y_LOW  = 10'd50,    //显示区域最小y坐标
                PIC_AREA = 17'd0;       //显示区域的像素总数
                
 //========================计数器===========================
 reg    [9:0]         h_cnt = 0;
 reg    [9:0]         v_cnt = 0;
 
// wire                 vga_data_valid;
//======================Main==========================
//行扫描
always@(posedge vga_clk or posedge rst_p)  begin
        if(rst_p)
            h_cnt <= 2'd0;
        else if(h_cnt == H_TOTAL - 10'd1)
            h_cnt <= 10'd0;
        else
            h_cnt <= h_cnt + 10'd1;       
end    

//列扫描
always@(posedge vga_clk or posedge rst_p)  begin
        if(rst_p)
            v_cnt <= 2'd0;
        else if((v_cnt == V_TOTAL - 10'd1) && (h_cnt == H_TOTAL - 10'd1))
            v_cnt <= 0;
        else if(h_cnt == H_TOTAL - 10'd1)
            v_cnt <= v_cnt + 10'd1;       
end    
//电子枪休息是否结束
assign vga_hsync = (h_cnt <= H_SYNC - 10'd1) ? 1'b1 : 1'b0; 
//电子枪休息是否结束
assign vga_vsync = (v_cnt <= V_SYNC - 10'd1) ? 1'b1 : 1'b0; 
//显示区域有效信号判别（扫描到用户想显示的区域）
assign img_data_valid = (
(vga_data_valid == 1) &&
(pos_x <=  PIC_X_HIGH)&&
(pos_x >  PIC_X_LOW)&&
(pos_y > PIC_Y_LOW)&&
(pos_y <= PIC_Y_HIGH)
)?1'b1:1'b0;
//vga显示有效信号判别（扫描到屏幕显示区域）
assign vga_data_valid = (
(h_cnt >= H_SYNC + H_BACK_LEFT - 10'd1)&&
(h_cnt <= H_SYNC + H_BACK_LEFT + H_VALID - 10'd1)&&
(v_cnt >= V_SYNC + V_BACK_LEFT)&&
(v_cnt <= V_SYNC + V_BACK_LEFT + V_VALID)
)?1'b1:1'b0;
//==================vga_data有效==================
assign vga_data = (img_data_valid == 1'b1) ? rgb_data : 12'd0;//用原始数据的低位进行补偿,拼接也可以用于扩展变量位宽   //md,老子改了半天才可以显示任意大小任意位置的图片，结果到头来改这一句就行了，woc，今天的我比昨天聪明。
//==================像素坐标======================
assign pos_x = (vga_data_valid == 1'b1) ? h_cnt - H_SYNC - H_BACK_LEFT + 1'b1 : 10'b0;
assign pos_y = (vga_data_valid == 1'b1) ? v_cnt - V_SYNC - V_BACK_LEFT : 10'b0;
endmodule
