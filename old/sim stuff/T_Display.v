`timescale 1ns / 1ps

module T_Display;

reg clk, clr;
reg [3:0] dig1;
reg [3:0] dig2;
reg [3:0] dig3;
reg [3:0] dig4;
wire [3:0] an;
wire [6:0] ca;

always #2 clk = ~clk;

Display M_UUT_Disp(.clk(clk),
                   .clr(clr),
                   .dig1(dig1),
                   .dig2(dig2),
                   .dig3(dig3),
                   .dig4(dig4),
                   .an(an),
                   .ca(ca));
                   
initial begin
    clk <= 0;
    #100000 clr <= 1;
    #100000 clr <= 0;
    
    #100000 dig1 <= 4'b0101;
          dig2 <= 4'b1010;
        
    #100000 dig3 <= 4'b0011;
          dig4 <= 4'b1010;
    
    #600000 $finish;

end

endmodule
