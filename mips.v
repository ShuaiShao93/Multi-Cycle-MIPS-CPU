module mips (input PClk, Reset,
             output IorD,
             output [31: 2] ADDR,
             output [3:0] BE,
             input [31:0] RData,
             output [31:0] WData,
             output Req, RW,
             input Ready,
             input [6:2] HWInt);
    wire PCWrite, IRWrite, RegWrite, MulSelMD, MulSelSU, MulStart, MulSelHL, MulWrite, MulReady, CP0Write, PrExcEnter, SR_EXL, SR_IE, ALUSrcA, SHTNumSrc, CP0ASrc, Compare, eret;
    wire [1:0] RF_Dst, RF_Src, SHTOp, RFSource, ALUSrcB, RegDst, CP0DSrc, ExtFunct;
    wire [2:0] ALUOutSrc, PCSource, DExtFunct;
    wire [4:0] ALUOp, RS, RT;
    wire [5:0] Opcode, Funct;
    wire [6:2] PrExcCode;
    wire [7:2] SR_IM;
    wire [31:0] A;
    assign ADDR = A[31:2];
    datapath DP(PClk, Reset, PCWrite, IRWrite, RegWrite, RF_Dst, RF_Src, ALUOp, SHTOp, MulSelMD, MulSelSU, MulStart, MulSelHL, MulWrite, CP0Write, PrExcEnter, PrExcCode, HWInt, SR_IM, SR_EXL, SR_IE, ExtFunct, RegDst, RFSource, ALUSrcA, ALUSrcB, SHTNumSrc, ALUOutSrc, CP0ASrc, PCSource, IorD, CP0DSrc, DExtFunct, Compare, MulReady, Opcode, Funct, RS, RT, A, RData, WData, eret);
    control Ctrl(PClk, Reset, Opcode, Funct, RS, RT, Compare, PCWrite, IRWrite, RegWrite, RF_Dst, RF_Src, ALUOp, SHTOp, MulSelMD, MulSelSU, MulStart, MulSelHL, MulWrite, MulReady, CP0Write, PrExcEnter, PrExcCode, HWInt, SR_IM, SR_EXL, SR_IE, IorD, ExtFunct, RegDst, RFSource, ALUSrcA, ALUSrcB, SHTNumSrc, ALUOutSrc, CP0ASrc, PCSource, CP0DSrc, DExtFunct, A[1:0], BE, Req, RW, Ready, eret);
endmodule
