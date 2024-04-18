`timescale 1ns / 1ps

module Vending_Machine_Controller(
    input [3:0] sw,
    input [2:0] btn,
    input clk, clr,
    output reg [7:0] left_disp,
    output reg [7:0] right_disp,
    output reg [3:0] leds
//    ,output reg [3:0] pres,
//    output reg [3:0] next
    );
    
    reg [2:0] btn_d, sw_d;
    reg [3:0] pres, next;
    
    parameter A00 = 4'b0000, A05 = 4'b0001, A10 = 4'b0010, A15 = 4'b0011,
              A20 = 4'b0100, A25 = 4'b0101, A30 = 4'b0110, A35 = 4'b0111,
              C00 = 4'b1111, C05 = 4'b1110, C10 = 4'b1101, C15 = 4'b1100, C20 = 4'b1011;
    
    always @(posedge sw or posedge btn) begin
        // encode buttons into three data lines
        
        case (btn)
            3'b001: btn_d <= 3'b001;
            3'b010: btn_d <= 3'b010;
            3'b100: btn_d <= 3'b101;
            default btn_d <= 3'b000;
        endcase
                                                // encode switches into three data lines
        if (sw[0])                              // sw[0] corresponds to 15c product
            sw_d = 3'b011;
        else if (sw[1])
            sw_d = 3'b100;
        else if (sw[2])
            sw_d = 3'b101;
        else if (sw[3])
            sw_d = 3'b110;
        else
            sw_d = 3'b000;
        
        if (btn_d != 3'b000) begin
            if (pres > A35) begin
                next <= {1'b0, btn_d};           // if money entered while in change state, then the next state should be the amount entered
//                pres = A00;
            end
            if (pres >= A30)                    // setting overflow additions to A35
                next = A35;
            else if (pres == A25 && btn_d >= 3'b010)
                next = A35;
            else if (pres >= A10 && btn_d == 3'b101)
                next = A35;
            else
                next = pres + {1'b0, btn_d};            // can perform all other add amts normally
        end

        if (sw_d != 3'b000) begin
            if (pres <= A35 && pres >= sw_d)
                next = sw_d - pres - 1;
        end
        
    end
    
    always @(posedge clr or posedge clk) begin
        if (clr == 1) begin
            pres <= A00;
        end
        else begin                                  // else, clk cycle
            pres <= next;                               // case 2: regular clk
        end
    end
    
    always @(posedge clk) begin
        case (sw)
            4'b0001 :   left_disp = 8'h15;
            4'b0010 :   left_disp = 8'h20;
            4'b0100 :   left_disp = 8'h25;
            4'b1000 :   left_disp = 8'h30;
        endcase
        
        if (pres <= A35) begin                  // if entering money
            leds = 0;
//            disp_dig1 <= 0;                         // no product selected
//            disp_dig2 <= 0;
//            disp_dig3 = {2'b00, pres[2:1]};      // amt entered most signif digit (MSD)
//            disp_dig4 = {3'b000, 5*pres[0]};     // amt entered least signif digit (LSD)
            case (pres)
                A00 :   right_disp = 8'h00;
                A05 :   right_disp = 8'h05;
                A10 :   right_disp = 8'h10;
                A15 :   right_disp = 8'h15;
                A20 :   right_disp = 8'h20;
                A25 :   right_disp = 8'h25;
                A30 :   right_disp = 8'h30;
                A35 :   right_disp = 8'h35;
            endcase
        end
        else begin                              // if product selected  
            leds = sw;      
            case (pres)                             // change back displayed digits
                C00 :   right_disp = 8'h00;
                C05 :   right_disp = 8'h05;
                C10 :   right_disp = 8'h10;
                C15 :   right_disp = 8'h15;
                C20 :   right_disp = 8'h20;
            endcase
        end
    end
    
endmodule
