`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/17 21:10:39
// Design Name: 
// Module Name: tb_top
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


module tbfile();

reg sys_clk; 
reg sys_rst_p;
 
initial begin
sys_clk <= 1'b1;
sys_rst_p<= 1'b1;
#20
sys_rst_p <= 1'b0;
end

always #5 sys_clk = ~sys_clk;

Top u0_Top(
.sys_clk    (sys_clk ),
.sys_rst_p  (sys_rst_p)
);
endmodule
