`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 10:27:05
// Design Name: 
// Module Name: alu
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


module alu(
    input               clk,
    input               reset_p,
    //  연산자
    input               op_add,
    input               op_sub,
    input               op_mul,
    input               op_div,
    input               op_and,
    // shift 를위한 
    input               acc_lsb,        // alu data를 받은 acc의 최하위 비트를 받음
    // 입력 
    input [3:0]         acc_high_data,
    input [3:0]         bus_reg_data,
    // 출력
    output [3:0]        alu_data,
    // flag
    output              carry_flag,
    output              zero_flag,
    output              sign_flag,
    output              cout );

    wire [3:0] sum;
    // add, sub
    fadd_sub_4bit_dataflow fadd_sub(    .a(acc_high_data), .b(bus_reg_data),                        
                                        .s(op_sub | op_div),                                 
                                        .sum(sum),                        
                                        .carry(cout));        


    assign alu_data = op_and ? (acc_high_data & bus_reg_data) : sum;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // flag // 

    register_Nbit_p #(.N(1))  zero_f(
    .d(~(|sum)),
    .clk(clk),
    .reset_p(reset_p),
    .wr_en(op_sub), .rd_en(1),
    .q(zero_flag));

    register_Nbit_p #(.N(1))  sign_f(
    .d((~cout) & (op_sub)),
    .clk(clk),
    .reset_p(reset_p),
    .wr_en(op_sub), .rd_en(1),
    .q(sign_flag));

    register_Nbit_p #(.N(1))  carry_f(
    .d(cout & (op_add | (op_mul & acc_lsb) | op_div) ),
    .clk(clk),
    .reset_p(reset_p),
    .wr_en(1), .rd_en(1),
    .q(carry_flag));

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



endmodule
