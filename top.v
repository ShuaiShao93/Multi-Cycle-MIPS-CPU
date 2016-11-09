module top (input PClk, Reset);
    wire [31:0] PrRData, PrWData, Din_IM, Din_DM, DOut_DM;
    wire [31:2] PrA;
    wire [12:2] A_IM;
    wire [14:2] A_DM;
    wire [6:2] HWInt;
    wire [3:0] PrBE, BE;
    wire IorD, PrReq, PrRW, PrReady, We_DM;
    wire [6:2] ADR_WB;
    wire WE_WB, ACK_UART, STB_UART, ACK_TMR, STB_TMR;
    wire [7:0] DAT_WB, DAT_UART, DAT_TMR;
    mips mips(PClk, Reset, IorD, PrA, PrBE, PrRData, PrWData, PrReq, PrRW, PrReady, HWInt);
    Bridge bridge(PClk, IorD, PrA, PrBE, PrWData, PrRData, PrReq, PrRW, PrReady, Din_IM, Din_DM, DOut_DM, A_IM, A_DM, BE, We_DM, ADR_WB, DAT_WB[7:0], WE_WB, ACK_UART, STB_UART, DAT_UART, ACK_TMR, STB_TMR, DAT_TMR);
    IM IM(PClk, Reset, A_IM, Din_IM);
    DM DM(PClk, Reset, A_DM, BE, Din_DM, DOut_DM, We_DM);
    Wishbone wishbone(PClk, Reset, ADR_WB, DAT_WB, WE_WB, ACK_UART, STB_UART, DAT_UART, ACK_TMR, STB_TMR, DAT_TMR, HWInt);
endmodule