module Wishbone(
    input PClk, Reset,
    input [6:2] ADR, 
    input [7:0] DAT, 
    input WE, 
    output ACK_UART, 
    input STB_UART, 
    output [7:0] DAT_UART, 
    output ACK_TMR, 
    input STB_TMR, 
    output [7:0] DAT_TMR,
    output [6:2] HWInt);
    wire [2:0] OUT;
    wire [31:0] TCOut;
    wire [5:2] A;
    assign A = (ADR == 5'b01000)? 4'b0000 :
               (ADR == 5'b01001)? 4'b0001 :
               (ADR == 5'b01010)? 4'b0010 :
               (ADR == 5'b01100)? 4'b0011 :
               (ADR == 5'b01101)? 4'b0100 :
               (ADR == 5'b01110)? 4'b0101 :
               (ADR == 5'b10000)? 4'b0110 :
               (ADR == 5'b10001)? 4'b0111 :
               (ADR == 5'b10010)? 4'b1000 : 0;
    TC TC(PClk, Reset, ADR[5:2], STB_TMR, WE, {24'b0, DAT}, TCOut, OUT);
    assign DAT_TMR = TCOut[7:0];
    assign ACK_TMR = STB_TMR;
    assign HWInt[2] = OUT[0];
endmodule