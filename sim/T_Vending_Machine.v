`timescale 1ns / 1ps

module T_vend_controller;

reg clk, clr;
reg [3:0] sw;
reg [2:0] btn;
wire [3:0] dig1;
wire [3:0] dig2;
wire [3:0] dig3;
wire [3:0] dig4;
wire [3:0] leds;

always #2 clk = ~clk;

Vending_Machine M_UUT_Vend_Control(.clk(clk),
                                   .clr(clr),
                                   .sw(sw),
                                   .btn(btn),
                                   .disp_dig1(dig1),
                                   .disp_dig2(dig2),
                                   .disp_dig3(dig3),
                                   .disp_dig4(dig4),
                                   .leds(leds));

initial begin
    clk <= 0;
    clr <= 0;
    btn <= 3'b000;
    sw <= 4'b0000;
    
    #1 clr <= 1;
    #10 clr <= 0;
    
    // enter 5c
    #10 btn <= 3'b001;
    #10 btn <= 3'b000;
    
    // attempt to buy 15c item
    #10 sw <= 4'b0001;
    #10 sw <= 4'b0000;
    
    // enter 10c
    #10 btn <= 3'b010;
    #10 btn <= 3'b000;
    
    // buy 15c item
    #10 sw <= 4'b0001;
    #10 sw <= 4'b0000;
    
    // enter 25c twice
    #10 btn <= 3'b100;
    #10 btn <= 3'b000;
    #10 btn <= 3'b100;
    #10 btn <= 3'b000;
    
    // buy 25c item
    #10 sw <= 4'b0100;
    #10 sw <= 4'b0000;
    
    #150 $finish;
    
end

endmodule