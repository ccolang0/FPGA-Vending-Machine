`timescale 1ns / 1ps

module Hex_To_Sev_Seg(
    input [3:0] x,
    output reg [6:0] ca
    );
    
    always @(x) begin
        case (x)                // 1 = OFF, 0 = ON
            0  : ca = 7'b0000001;  // 0
            1  : ca = 7'b1001111;  // 1
            2  : ca = 7'b0010010;  // 2
            3  : ca = 7'b0000110;  // 3
            4  : ca = 7'b1001100;  // 4
            5  : ca = 7'b0100100;  // 5
            6  : ca = 7'b0100000;  // 6
            7  : ca = 7'b0001111;  // 7
            8  : ca = 7'b0000000;  // 8
            9  : ca = 7'b0000100;  // 9
            10 : ca = 7'b0001000;  // A
            11 : ca = 7'b1100000;  // B
            12 : ca = 7'b0110001;  // C
            13 : ca = 7'b1000010;  // D
            14 : ca = 7'b0110000;  // E
            15 : ca = 7'b0111000;  // F
            default : ca = 7'b1111111;      // All OFF
        endcase
    end
endmodule