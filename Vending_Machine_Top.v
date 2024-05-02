`timescale 1ns / 1ps

module Vending_Machine_Top(
    input [3:0] sw,
    input [2:0] btn,
    input [1:0] clr,
    input clk,
    output [3:0] leds,      // LSB = 15c product
    output [3:0] an,
    output [6:0] ca
//    ,output clk_en
//    output [3:0] w_dig1,
//    output [3:0] w_dig2,
//    output [3:0] w_dig3,
//    output [3:0] w_dig4,
//    ,output [7:0] left_disp, right_disp
//    ,output [3:0] w_pres,
//    output [3:0] w_next
    );
    
    wire clk_en;
    wire [7:0] left_disp, right_disp;
    
    Clock_Enable_1Hz clk_en_1hz_mod(.clk(clk),
                                    .clr(clr[1] | clr[0]),
                                    .clk_en(clk_en));
                                                                   
    Vending_Machine vend(.item(sw),
                         .coin(btn),
                         .reset(clr[1] | clr[0]),
                         .clk(clk_en),
                         .item_dispense(leds),
                         .left_display(left_disp),
                         .right_display(right_disp)
                         );

    Display seg_disp(.clk(clk),
                     .clr(clr[1] | clr[0]),
                     .dig1(left_disp[7:4]),
                     .dig2(left_disp[3:0]),
                     .dig3(right_disp[7:4]),
                     .dig4(right_disp[3:0]),
                     .an(an),
                     .ca(ca));
    
endmodule