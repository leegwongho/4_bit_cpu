`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 11:36:34
// Design Name: 
// Module Name: acc
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


module acc(
    input               clk, 
    input               reset_p,
    input               acc_high_reset_p,
    input               fill_value,
    input               rd_en,
    input               acc_in_select,
    input [1:0]         acc_high_select,
    input [1:0]         acc_low_select,
    input [3:0]         bus_data,
    input [3:0]         alu_data,
    output [3:0]        high_data2bus,
    output [3:0]        acc_high_data2alu,
    output [3:0]        low_data2bus,
    output [3:0]        acc_low_data2alu );

    wire [3:0] acc_high_in;

    assign acc_high_in = acc_in_select ? bus_data : alu_data;   // acc_in_select 로 입력할 데이터 정함

    half_acc acc_high(
    .clk(clk), 
    .reset_p(reset_p | acc_high_reset_p),
    .load_msb(fill_value),                                      // 쉬프트후 빈자리에 들어갈 비트
    .load_lsb(acc_low_data2alu[3]),                             // low 의 msb를 high 의 lsb로 입력
    .rd_en(rd_en),
    .s(acc_high_select),                                        // 00 idie, 01 left shift 10 rigth shift 11 load
    .data_in(acc_high_in),      
    .data2bus(high_data2bus),                                   // bus 와 연결될 출력
    .register_data(acc_high_data2alu));                         // alu 와 연결될 출력

    half_acc acc_low(
    .clk(clk), 
    .reset_p(reset_p),
    .load_msb(acc_high_data2alu[0]),                            // low 의 msb를 high 의 lsb로 입력
    .load_lsb(fill_value),                                      // 쉬프트후 빈자리에 들어갈 비트
    .rd_en(rd_en),
    .s(acc_low_select),                                         // 00 idie, 01 left shift 10 rigth shift 11 load
    .data_in(acc_high_data2alu),
    .data2bus(low_data2bus),                                    // bus 와 연결될 출력
    .register_data(acc_low_data2alu));                          // alu 와 연결될 출력


endmodule


module half_acc(
    input               clk, 
    input               reset_p,
    input               load_msb,
    input               load_lsb,
    input               rd_en,
    input [1:0]         s,
    input [3:0]         data_in,
    output [3:0]        data2bus,
    output [3:0]        register_data);

    parameter IDLE =        2'b00; 
    parameter SHIFT_RIGHT = 2'b01;
    parameter SHIFT_LEFT =  2'b10;
    parameter LOAD =        2'b11;
    

    reg [3:0] d;

    

    always @ * begin
        case(s)
            IDLE: begin
                d = register_data;
            end
            SHIFT_RIGHT: begin
                d = {load_msb, register_data[3:1]};
            end
            SHIFT_LEFT: begin
                d = {register_data[2:0], load_lsb};
            end
            LOAD: begin
                d = data_in;
            end
        endcase
    end

    register_Nbit_p #(.N(4))  h_acc(
    .d(d),
    .clk(clk),
    .reset_p(reset_p),
    .wr_en(1), .rd_en(rd_en),
    .register_data(register_data),
    .q(data2bus));



endmodule