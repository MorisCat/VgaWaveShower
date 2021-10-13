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

parameter   WAVE_POS_Y = 26'd350,    //������������Ļ��y�����λ�ã��˲���Խ�󣬲���Խ����;����ط�λ��Ҫָ���Ĵ�һЩ��λ��ָ��Ϊ26û����
             LINE_THICK  = 10'd900,   //�����ߵĴ�ϸ��Խ����Խ�֣��ֵ�һ���̶ȿ��ܻ���ֵײ�ʧ�棬����LIMIT_PARAM��������
             WAVE_BITSHIFT = 5'd8,    //������ߵ����͵�ľ��루��λ���֣���Խ�����ԽС
             LIMIT_PARAM = 16'd1000,  //��������ʾ�Ĳ��εײ�ʧ�棬�����������
             /*****************************************************/
             /*����Ĳ���Ϊ����ϵͳ�Ĳ������ԣ���û���ڴ�����ʵ��ʹ��*/
             /****************************************************/
             ADDATA_WIDTH = 10'd16,   //AD����λ��
             PIC_DEPTH = 10'd512;     //�����ĵ���
             
reg     [9:0]        pos_x_back = 10'b0;//���ź�λ����BROM(BRAM)����
reg     [16:0]       addras = 17'b0;
reg     [16:0]       addrabackup = 17'b0;
wire    [15:0]       out_data;       //AD����λ��16λ

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
