`timescale 1ns / 1ps

module Vending_Machine_Top(
    input [3:0] sw,
    input [2:0] btn,
    input [1:0] clr,
    input clk,
    output [3:0] leds,      // LSB = 15c product
    output [3:0] an,
    output [6:0] ca
//    ,output clk_en,
//    output [3:0] w_dig1,
//    output [3:0] w_dig2,
//    output [3:0] w_dig3,
//    output [3:0] w_dig4,
//    output [3:0] w_pres,
//    output [3:0] w_next
    );
    
    wire clk_en;
    wire [3:0] w_dig1;
    wire [3:0] w_dig2;
    wire [3:0] w_dig3;
    wire [3:0] w_dig4;
    
    Clock_Enable #(.src_freq(100000000), .target_freq(100)) clk_1Hz (.clk(clk),
                                                                   .clr(clr[1] | clr[0]),
                                                                   .clk_en(clk_en) );
                                                                   
    Vending_Machine_Controller vend_control(.sw(sw),
                                            .btn(btn),
                                            .clr(clr[1] | clr[0]),
                                            .clk(clk_en),
                                            .leds(leds),
                                            .disp_dig1(w_dig1),
                                            .disp_dig2(w_dig2),
                                            .disp_dig3(w_dig3),
                                            .disp_dig4(w_dig4)
//                                            ,.pres(w_pres),
//                                            .next(w_next)
                                            );
                                            
    Display seg_disp(.clk(clk),
                     .clr(clr[1] | clr[0]),
                     .dig1(w_dig1),
                     .dig2(w_dig2),
                     .dig3(w_dig3),
                     .dig4(w_dig4),
                     .an(an),
                     .ca(ca));
    
endmodule
