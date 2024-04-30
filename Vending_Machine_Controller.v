`timescale 1ns / 1ps

module Vending_Machine_Controller(
    input [3:0] sw,
    input [2:0] btn,
    input clk, clr,
    output reg [7:0] left_disp,
    output reg [7:0] right_disp,
    output reg [3:0] leds
    ,output reg [3:0] pres,
    output reg [3:0] next
    );
    
    reg [2:0] btn_d, sw_d;
//    reg [3:0] pres, next;
    
    parameter A00 = 4'b0000, A05 = 4'b0001, A10 = 4'b0010, A15 = 4'b0011,
              A20 = 4'b0100, A25 = 4'b0101, A30 = 4'b0110, A35 = 4'b0111,
              C00 = 4'b1111, C05 = 4'b1110, C10 = 4'b1101, C15 = 4'b1100, C20 = 4'b1011;
    
    // combinational logic to change change next state based on sw and btn inputs
    always @(sw or btn) begin
        
        case (btn)
            3'b001: btn_d = 3'b001;
            3'b010: btn_d = 3'b010;
            3'b100: btn_d = 3'b101;
            default btn_d = 3'b000;
        endcase
        
        case (pres)
            A00 : begin
                    if (btn != 3'b000)
                        next <= btn_d;
                  end
            A05 : begin
                    if (btn != 3'b000)
                        next <= A05 + btn_d;
                  end
            A10 : begin
                    if (btn != 3'b000)
                        next <= A10 + btn_d;
                  end
            A15 : begin
                    if (btn == 3'b001 | btn == 3'b010)
                        next <= A15 + btn_d;
                    else if (btn_d == 3'b101)
                        next = A35;
                    else if (sw == 4'b0001)
                        next = C00;
                  end
            A20 : begin
                    if (btn_d == 3'b001 | btn_d == 3'b010)
                        next <= A20 + btn_d;
                    else if (btn_d == 3'b101)
                        next = A35;
                    else if (sw == 4'b0001)
                        next = C05;
                    else if (sw == 4'b0010)
                        next = C00;
                  end
            A25 : begin
                    if (btn_d == 3'b001 || btn_d == 3'b010)
                        next <= A25 + btn_d;
                    else if (btn_d == 3'b101)
                        next = A35;
                    else if (sw == 4'b0001)
                        next = C10;
                    else if (sw == 4'b0010)
                        next = C05;
                    else if (sw == 4'b0100)
                        next = C00;
                  end
            A30 : begin
                    if (btn_d != 3'b000)
                        next = A35;
                    else if (sw == 4'b0001)
                        next = C15;
                    else if (sw == 4'b0010)
                        next = C10;
                    else if (sw == 4'b0100)
                        next = C05;
                    else if (sw == 4'b1000)
                        next = C00;
                  end
            A35 : begin
                    if (btn_d != 3'b000)
                        next = A35;
                    else if (sw == 4'b0001)
                        next = C20;
                    else if (sw == 4'b0010)
                        next = C15;
                    else if (sw == 4'b0100)
                        next = C10;
                    else if (sw == 4'b1000)
                        next = C05;
                  end
            C00, C05, C10, C15, C20: next <= btn_d;
            //default next = A00;
        endcase
        
    end
    
    // sequential block to update present state on clk or clr
    always @(posedge clr or posedge clk) begin
        if (clr == 1) begin
            pres <= A00;
            next <= A00;
        end
        else begin                                  // else, clk cycle
            pres <= next;                               // case 2: regular clk
        end
    end
    
    // combinational block to change outputs based on present state every clock cycle
    always @(sw or pres) begin
        case (sw)
            4'b0001 :   left_disp = 8'h15;
            4'b0010 :   left_disp = 8'h20;
            4'b0100 :   left_disp = 8'h25;
            4'b1000 :   left_disp = 8'h30;
            default :   left_disp = 8'h00;
        endcase
        
        if (pres <= A35) begin                  // if entering money
            leds = 0;
            case (pres)
                A00 :   right_disp = 8'h00;
                A05 :   right_disp = 8'h05;
                A10 :   right_disp = 8'h10;
                A15 :   right_disp = 8'h15;
                A20 :   right_disp = 8'h20;
                A25 :   right_disp = 8'h25;
                A30 :   right_disp = 8'h30;
                A35 :   right_disp = 8'h35;
                default right_disp = 8'haa;
            endcase
        end
        else begin                              // if product selected  
            leds <= sw;      
            case (pres)                             // change back displayed digits
                C00 :   right_disp = 8'h00;
                C05 :   right_disp = 8'h05;
                C10 :   right_disp = 8'h10;
                C15 :   right_disp = 8'h15;
                C20 :   right_disp = 8'h20;
                default right_disp = 8'haa;
            endcase
        end
    end
    
endmodule
