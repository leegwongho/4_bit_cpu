`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 09:41:47
// Design Name: 
// Module Name: block_alu_acc
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


module block_alu_acc(
    input               clk, 
    input               reset_p,
    // acc
    input               acc_high_reset_p, 
    input               rd_en,
    input               acc_in_select,
    input [1:0]         acc_high_select_in,
    input [1:0]         acc_low_select,
    input [3:0]         bus_data,
    /// alu
    input               op_add,
    input               op_sub,
    input               op_mul,
    input               op_div,
    input               op_and,
    input [3:0]         bus_reg_data,
    output              zero_flag,
    output              sign_flag,    
    output [7:0]        acc_data);

    
    wire w_fill_value;
    wire [3:0]        w_alu_data;
    wire [3:0]        w_high_data2bus;
    wire [3:0]        w_acc_high_data2alu;
    wire [3:0]        w_low_data2bus;
    wire [3:0]        w_acc_low_data2alu;
    
    wire              w_carry_flag;
    wire              w_cout;

    wire [1:0] acc_high_select;

    assign w_fill_value = w_carry_flag;
    assign acc_data = {w_high_data2bus, w_low_data2bus};

    assign acc_high_select[1] = (op_mul | op_div) ?  (op_mul & w_acc_low_data2alu[0]) | (op_div & w_cout)   : acc_high_select_in[1];    //  cout 으로 뺼수있는지를 판단.
    assign acc_high_select[0] = (op_mul | op_div) ?  (op_mul & w_acc_low_data2alu[0]) | (op_div & w_cout)   : acc_high_select_in[0];

    acc block_acc (
                .clk(clk), 
                .reset_p(reset_p),
                .acc_high_reset_p(acc_high_reset_p),
                .fill_value(w_fill_value),
                .rd_en(rd_en),
                .acc_in_select(acc_in_select),
                .acc_high_select(acc_high_select),
                .acc_low_select(acc_low_select),
                .bus_data(bus_data),
                .alu_data(w_alu_data),
                .high_data2bus(w_high_data2bus),
                .acc_high_data2alu(w_acc_high_data2alu),
                .low_data2bus(w_low_data2bus),
                .acc_low_data2alu(w_acc_low_data2alu) );

    alu block_alu(
                    .clk(clk),
                    .reset_p(reset_p),

                    .op_add(op_add),
                    .op_sub(op_sub),
                    .op_mul(op_mul),
                    .op_div(op_div),
                    .op_and(op_and),

                    .acc_lsb(w_acc_high_data2alu[0]),                // alu data를 받은 acc의 최하위 비트를 받음

                    .acc_high_data(w_acc_high_data2alu),
                    .bus_reg_data(bus_reg_data),

                    .alu_data(w_alu_data),

                    .carry_flag(w_carry_flag),
                    .zero_flag(zero_flag),
                    .sign_flag(sign_flag),
                    .cout(w_cout) );
    // alu는 항상 더하고 있음 acc에서 alu 데이터를 load를 하면 무조건 덧셈을 빋는거임 
    // 곱셈을 위해 acc high select 를 변경



endmodule
