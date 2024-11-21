`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 14:16:20
// Design Name: 
// Module Name: tb_acc
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


module tb_acc();

    reg               clk; 
    reg               reset_p;
    reg               acc_high_reset_p;
    reg               fill_value;
    reg               rd_en;
    reg               acc_in_select;
    reg [1:0]         acc_high_select;
    reg [1:0]         acc_low_select;
    reg [3:0]         bus_data;
    reg [3:0]         alu_data;
    
    wire [3:0]        high_data2bus;
    wire [3:0]        acc_high_data2alu;
    wire [3:0]        acc_low_data2alu;
    wire [3:0]        low_data2bus;

    acc DUT(            clk, 
                        reset_p,
                        acc_high_reset_p,
                        fill_value,
                        rd_en,
                        acc_in_select,
                        acc_high_select,
                        acc_low_select,
                        bus_data,
                        alu_data,
                        high_data2bus,
                        acc_high_data2alu,
                        low_data2bus,
                        acc_low_data2alu );


    parameter IDLE =        2'b00; 
    parameter SHIFT_RIGHT = 2'b01;
    parameter SHIFT_LEFT =  2'b10;
    parameter LOAD =        2'b11;
    parameter DATA_ALU = 0;
    parameter DATA_BUS = 1;

    initial begin
        clk = 0; reset_p = 1; fill_value = 0; rd_en = 1;
        acc_in_select = DATA_ALU; acc_high_select = IDLE; acc_low_select = IDLE;
        bus_data = 4'b0010; alu_data = 4'b0101; acc_high_reset_p = 0;
    end

    always #5 clk = ~clk;

    initial begin
        #10
        reset_p = 0;
        #10;
        acc_high_select = LOAD;    // high acc alu data load
        #10;
        acc_high_select = IDLE;    // high accidle
        #10
        acc_in_select = DATA_BUS;
        acc_high_select = LOAD;   // bus data load
        #10
        acc_high_select = IDLE;    // high acc idle
        #10
        acc_low_select = LOAD;     // low acc load
        #10
        acc_low_select = IDLE;     
        #10
        // shift right
        acc_in_select = DATA_ALU;  
        acc_high_select = LOAD;
        #10
        acc_low_select = LOAD;
        #10
        acc_low_select = SHIFT_RIGHT;
        acc_high_select = SHIFT_RIGHT;
        #40
        // shift left
        acc_in_select = DATA_BUS; acc_high_select = LOAD; 
        #10
        acc_high_select = IDLE; acc_low_select = LOAD; 
        #10
        acc_low_select = IDLE; 
        #10;
        acc_low_select = SHIFT_LEFT;
        acc_high_select = SHIFT_LEFT;
        #40

        reset_p = 1;
        #10
        reset_p = 0;

        acc_in_select = DATA_BUS;
        acc_high_select = LOAD;
        #10
        acc_low_select = LOAD;
        #10
        acc_low_select = IDLE;
        #10
        acc_high_reset_p = 1;
        #10
        acc_high_reset_p = 0;
        #10 

        $finish;
    end


// 테스트


endmodule
