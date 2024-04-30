`timescale 1ns / 1ps

module Vending_Machine_Top(
    input [3:0] sw,
    input [2:0] btn,
    input [1:0] clr,
    input clk,
    output [3:0] leds,      // LSB = 15c product
    output [3:0] an,
    output [6:0] ca
    ,output clk_en,
//    output [3:0] w_dig1,
//    output [3:0] w_dig2,
//    output [3:0] w_dig3,
//    output [3:0] w_dig4,
    output [7:0] left_disp, right_disp
    ,output [3:0] w_pres,
    output [3:0] w_next
    );
    
//    wire clk_en;
//    wire [7:0] left_disp, right_disp;
    
    Clock_Enable #(.src_freq(100000000), .target_freq(1000)) clk_1Hz (.clk(clk),
                                                                   .clr(clr[1] | clr[0]),
                                                                   .clk_en(clk_en) );
                                                                   
    Vending_Machine_Controller vend_control(.sw(sw),
                                            .btn(btn),
                                            .clr(clr[1] | clr[0]),
                                            .clk(clk_en),
                                            .leds(leds),
                                            .left_disp(left_disp),
                                            .right_disp(right_disp)
                                            ,.pres(w_pres),
                                            .next(w_next)
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
