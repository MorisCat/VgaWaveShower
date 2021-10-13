`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/11 09:53:33
// Design Name: 
// Module Name: frame_control
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


module frame_control(
input           wire                    vga_clk,
input           wire                    rst_p,

input           wire    [9:0]           pos_x,
input           wire    [9:0]           pos_y,
input           wire                    data_valid,
input           wire                    vga_data_valid,
output          reg   [11:0]            img_data  //RGB444
    );

parameter   WAVE_POS_Y = 26'd350,    //调整波形在屏幕上y方向的位置，此参数越大，波形越靠下;这个地方位宽要指定的大一些，位宽指定为26没问题
             LINE_THICK  = 10'd900,   //波形线的粗细，越大波形越粗，粗到一定程度可能会出现底部失真，调整LIMIT_PARAM参数即可
             WAVE_BITSHIFT = 5'd8,    //波的最高点和最低点的距离（移位体现），越大距离越小
             LIMIT_PARAM = 16'd1000,  //若发现显示的波形底部失真，调大这个参数
             /*****************************************************/
             /*下面的参数为描述系统的采样特性，并没有在代码中实际使用*/
             /****************************************************/
             ADDATA_WIDTH = 10'd16,   //AD数据位宽
             PIC_DEPTH = 10'd512;     //采样的点数
             
reg     [9:0]        pos_x_back = 10'b0;//该信号位宽依BROM(BRAM)而定
reg     [16:0]       addras = 17'b0;
reg     [16:0]       addrabackup = 17'b0;
wire    [15:0]       out_data;       //AD数据位宽16位

always@(posedge vga_clk or posedge rst_p) begin
    if(rst_p)
        pos_x_back <= 10'b0;
    else if(data_valid == 1)
        pos_x_back <= pos_x;
    else
        pos_x_back <= 10'b0;
end



always@(posedge vga_clk or posedge rst_p) begin
    if(rst_p)
        img_data <= 1'b0;
    else if(out_data + LIMIT_PARAM <= ((WAVE_POS_Y - pos_y) << WAVE_BITSHIFT) + LINE_THICK && 
            out_data + LIMIT_PARAM >= ((WAVE_POS_Y - pos_y) << WAVE_BITSHIFT))
        img_data <= 16'hff0;
    else if(pos_y == 220)
        img_data <= 16'hf00;
    else
        img_data <= 16'h000;
end

blk_mem_gen_0 u0_mem(
.clka   (vga_clk),
.addra  (pos_x_back),
.douta  (out_data)
);

endmodule
