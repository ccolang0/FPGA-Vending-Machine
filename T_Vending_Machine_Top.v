`timescale 1ns / 1ps

module T_Vending_Machine_Top;

reg clk, clr;
reg [3:0] sw;
reg [2:0] btn;
wire [7:0] left_disp, right_disp;
wire [3:0] leds;
wire [3:0] pres;
wire [3:0] next;
wire [3:0] an;
wire [6:0] ca;
wire clk_en;

always #2 clk = ~clk;

Vending_Machine_Top M_UUT_Vend_Top(.sw(sw),
                                   .btn(btn),
                                   .clr({clr, clr}),
                                   .clk(clk),
                                   .leds(leds),      // LSB = 15c product
                                   .an(an),
                                   .ca(ca)
                                   ,.left_disp(left_disp)
                                   ,.right_disp(right_disp)
//                                   .w_pres(pres),
//                                   .w_next(next),
                                   ,.clk_en(clk_en)
                                   );
                                    
initial begin
    clk <= 0;
    clr <= 0;
    btn <= 3'b000;
    sw <= 4'b0000;
    
    #1 clr <= 1;
    #10 clr <= 0;
    
    // enter 5c
    #1000000 btn <= 3'b001;
    #1000000 btn <= 3'b000;
    
    // attempt to buy 15c item
    #1000100 sw <= 4'b0001;
    #1000100 sw <= 4'b0000;
    
    // enter 10c
    #1000100 btn <= 3'b010;
    #1000000 btn <= 3'b000;
    
    // buy 15c item
    #1000100 sw <= 4'b0001;
    #1000100 sw <= 4'b0000;
    
    // enter 25c twice
    #1000100 btn <= 3'b100;
    #1000000 btn <= 3'b000;
    #1000100 btn <= 3'b100;
    #1000000 btn <= 3'b000;
    
    // buy 25c item
    #1000100 sw <= 4'b0100;
    #1000100 sw <= 4'b0000;
    
    #5000000 $finish;
    
end

endmodule