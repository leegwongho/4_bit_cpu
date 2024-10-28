`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 11:26:53
// Design Name: 
// Module Name: tb_block_alu_acc
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


module tb_block_alu_acc();

    reg               clk;
    reg               reset_p;

    reg               acc_high_reset_p;
    reg               rd_en;
    reg               acc_in_select;
    reg [1:0]         acc_high_select_in;
    reg [1:0]         acc_low_select;
    reg [3:0]         bus_data;
    reg               op_add;
    reg               op_sub;
    reg               op_mul;
    reg               op_div;
    reg               op_and;
    reg [3:0]         bus_reg_data;

    wire              zero_flag;          
    wire              sign_flag;          
    wire [7:0]        acc_data;                      


    block_alu_acc DUT(
                            clk, 
                            reset_p,

                            acc_high_reset_p, 
                            rd_en,
                            acc_in_select,
                            acc_high_select_in,
                            acc_low_select,
                            bus_data,

                            op_add,
                            op_sub,
                            op_mul,
                            op_div,
                            op_and,
                            bus_reg_data,
                            zero_flag,
                            sign_flag,    
                            acc_data);

    parameter IDLE =        2'b00; 
    parameter SHIFT_RIGHT = 2'b01;
    parameter SHIFT_LEFT =  2'b10;
    parameter LOAD =        2'b11;

    parameter alu = 1'b0;
    parameter bus = 1'b1;


    initial begin
        clk = 0;
        reset_p = 1;
        acc_high_reset_p = 0;
        rd_en = 1;
        acc_in_select = bus;
        acc_high_select_in = IDLE;
        acc_low_select = IDLE;
        bus_data =4'b1011;
        bus_reg_data = 4'b0101;
        op_add = 0; 
        op_sub = 0;
        op_mul = 0;
        op_div = 0;
        op_and = 0;
    end

    always #5 clk = ~clk;

    initial begin
        #10;
        reset_p = 0;
        #10;
        acc_in_select = bus;
        acc_high_select_in = LOAD; 
        #10;
        acc_in_select = alu;
        acc_high_select_in = IDLE;
        #10;
        acc_low_select = LOAD;
        #10;
        acc_low_select = IDLE;
        acc_high_reset_p = 1;
        #10;
        acc_high_reset_p = 0;
        #10;
        acc_high_select_in = SHIFT_LEFT;
        acc_low_select = SHIFT_LEFT; 
        #10;
        acc_high_select_in = IDLE;
        acc_low_select = IDLE;
        op_div = 1;
        #10;
        op_div = 0;
        acc_high_select_in = SHIFT_LEFT;
        acc_low_select = SHIFT_LEFT;
        #10;
        acc_high_select_in = IDLE;
        acc_low_select = IDLE;
        op_div = 1;
        #10;
        op_div = 0;
        acc_high_select_in = SHIFT_LEFT;
        acc_low_select = SHIFT_LEFT;
        #10;
        acc_high_select_in = IDLE;
        acc_low_select = IDLE;
        op_div = 1;
        #10;
        op_div = 0;
        acc_high_select_in = SHIFT_LEFT;
        acc_low_select = SHIFT_LEFT;
        #10;
        op_div = 1;
        acc_high_select_in = IDLE;
        acc_low_select = IDLE;
        #10;
        op_div = 0;
        acc_high_select_in = IDLE;
        acc_low_select = SHIFT_LEFT;
        #15;
        $stop;
        
        





    end










    // initial begin
    //     #10;
    //     reset_p = 0;
    //     #10;
    //     acc_in_select = bus;
    //     acc_high_select_in = LOAD; 
    //     #10;
    //     acc_in_select = alu;
    //     acc_high_select_in = IDLE;
    //     #10;
    //     acc_low_select = LOAD;
    //     #10;
    //     acc_low_select = IDLE;
    //     acc_high_reset_p = 1;
    //     #10;
    //     acc_high_reset_p = 0;
    //     #10;
    //     op_mul = 1; 
    //     #10;
    //     op_mul = 0;
    //     acc_high_select_in = SHIFT_RIGHT;
    //     acc_low_select = SHIFT_RIGHT;
    //     #10;
    //     acc_high_select_in = IDLE;
    //     acc_low_select = IDLE;
    //     op_mul = 1;
    //     #10;
    //     op_mul = 0;
    //     acc_high_select_in = SHIFT_RIGHT;
    //     acc_low_select = SHIFT_RIGHT;
    //     #10;
    //     acc_high_select_in = IDLE;
    //     acc_low_select = IDLE;
    //     op_mul = 1;
    //     #10;
    //     op_mul = 0;
    //     acc_high_select_in = SHIFT_RIGHT;
    //     acc_low_select = SHIFT_RIGHT;
    //     #10;
    //     acc_high_select_in = IDLE;
    //     acc_low_select = IDLE;
    //     op_mul = 1;
    //     #10;
    //     op_mul = 0;
    //     acc_high_select_in = SHIFT_RIGHT;
    //     acc_low_select = SHIFT_RIGHT;
    //     #10;
    //     // 곱셈 결과 출력 8클럭 값에 따라서 클럭이 변하지않음 ㅇㅇ
    //     $stop; 
    // end







endmodule
