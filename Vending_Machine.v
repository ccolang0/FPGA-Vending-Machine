`timescale 1ns / 1ps

module Vending_Machine ( 
    input clk, 
    input reset,
    input [3:0] item, 
    input [2:0] coin, 
    output reg [7:0] left_display, 
    output reg [7:0] right_display, 
    output reg [3:0] item_dispense 
    ); 
    
    parameter e0 = 8'h00, e5 = 8'h05, e10 = 8'h10, e15 = 8'h15; 
    parameter e20 = 8'h20, e25 = 8'h25, e30 = 8'h30, e35 = 8'h35; 
    parameter c0 = 8'h36, c5 = 8'h37, c10 = 8'h38, c15 = 8'h39, c20 = 8'h40; 
    parameter p15 = 4'b0001, p20 = 4'b0010, p25 = 4'b0100, p30 = 4'b1000; 
    
    reg [7:0] coin_amt; 
    reg [7:0] state = e0; 
    reg [7:0] amount; 
    reg [7:0] price; 
    reg [7:0] change; 
    
    always @(price or coin) begin 
        case (state) 
            e0: begin 
                if (coin == 3'b001) 
                    amount <= e5; 
                else if (coin == 3'b010) 
                    amount <= e10; 
                else if (coin == 3'b100) 
                    amount <= e25; 
                else 
                    amount <= e0; 
                end 
            e5: 
                if (coin == 3'b001) 
                    amount <= e10; 
                else if (coin == 3'b010) 
                    amount <= e15; 
                else if (coin == 3'b100) 
                    amount <= e30; 
                else 
                    amount <= e5; 
            e10: 
                if (coin == 3'b001) 
                    amount <= e15;
                else if(coin == 3'b010) 
                    amount <= e20; 
                else if (coin == 3'b100) 
                    amount <= e35; 
                else
                    amount <= e10; 
            e15: 
                if (coin == 3'b001) 
                    amount <= e20; 
                else if (coin == 3'b010) 
                    amount <= e25; 
                else if (coin == 3'b100) 
                    amount <= e35; 
                else if (price == e15) 
                    amount <= c0; 
                else
                    amount <= e15; 
            e20: 
                if (coin == 3'b001) 
                    amount <= e25; 
                else if (coin == 3'b010) 
                    amount <= e30; 
                else if (coin == 3'b100) 
                    amount <= e35; 
                else if (price == e20) 
                    amount <= c0; 
                else if (price == e15) 
                    amount <= e5; 
                else
                    amount <= e20; 
            e25: 
                if (coin == 3'b001) 
                    amount <= e30; 
                else if (coin == 3'b010 | coin == 3'b100) 
                    amount <= e35; 
                else if (price == e25) 
                    amount <= c0; 
                else if (price == e20) 
                    amount <= c5; 
                else if (price == e15) 
                    amount <= c10; 
                else
                    amount <= e25; 
            e30:
                if (coin == 3'b001 | coin == 3'b010 | coin == 3'b100) 
                    amount <= e35; 
                else if (price == e30) 
                    amount <= c0; 
                else if (price == e25) 
                    amount <= c5; 
                else if (price == e20) 
                    amount <= c10; 
                else if (price == e15) 
                    amount <= c15; 
                else
                    amount <= e30; 
            e35: 
                if (price == e30) 
                    amount <= c5; 
                else if (price == e25) 
                    amount <= c10; 
                else if (price == e20) 
                    amount <= c15; 
                else if (price == e15) 
                    amount <= c20; 
                else
                    amount <= e35; 
            c0:
                amount <= e0; 
            c5: 
                amount <= e5; 
            c10: 
                amount <= e10; 
            c15: 
                amount <= e15; 
            c20: 
                amount <= e20; 
            default: 
                amount <= e0; 
        endcase 
    end 
    
    always @(posedge clk or posedge reset) begin 
        if (reset == 1) begin 
            state <= 0; 
        end else begin 
            state <= amount; 
        end 
    end
    
    always @(state or item) begin 
        case(item) 
            p15: 
                price <= e15; 
            p20:
                price <= e20; 
            p25: 
                price <= e25; 
            p30: 
                price <= e30; 
            default: 
                price <= e0; 
        endcase 
        
        case (state) 
            c0: begin 
                left_display <= e0; 
                right_display <= price; 
                item_dispense <= item; 
            end c5: begin 
                left_display <= e5; 
                right_display <= price; 
                item_dispense <= item; 
            end c10: begin 
                left_display <= e10; 
                right_display <= price; 
                item_dispense <= item; 
            end c15: begin 
                left_display <= e15; 
                right_display <= price; 
                item_dispense <= item; 
            end c20: begin 
                left_display <= e20; 
                right_display <= price; 
                item_dispense <= item; 
            end default: begin 
                left_display <= state; 
                right_display <= price; 
                item_dispense <= 0; 
            end 
        endcase 
    end 
endmodule 
