module datapath(input PClk, Reset, PCWrite, IRWrite, RegWrite,
                input [1:0] RF_Dst, RF_Src,
                input [4:0] ALUOp,
                input [1:0] SHTOp,
                input MulSelMD, MulSelSU, MulStart, MulSelHL, MulWrite,
                input CP0Write,
                input ExcEnter,
                input [6:2] ExcCode, HWInt,
                output [7:2] SR_IM,
                output SR_EXL, SR_IE,
                input [1:0] ExtFunct,
                input [1:0] RegDst, RFSource,
                input ALUSrcA,
                input [1:0] ALUSrcB,
                input SHTNumSrc,
                input [2:0] ALUOutSrc,
                input CP0ASrc,
                input [2:0] PCSource,
                input IorD,
                input [1:0] CP0DSrc,
                input [2:0] DExtFunct,
                output Compare,
                output MulReady,
                output [5:0] Opcode, Funct,
                output [4:0] RS, RT,
                output [31:0] ADDR,
                input [31:0] RData,
                output [31:0] WData,
                input eret);
    wire [31:0] NextPC, PCW, Pc, IMData, Ir, RData1, RData2, ALU1, ALU2, Alu, SHTOut, MulOut, ALUOutIn, Imm, SImm, CP0DIn, CP0DOut, vector, WbData, Dae, EPC;
    wire [4:0] RD, SHTLen, CP0Idx;
    wire IRWr, Zero;
    reg [31:0] A, B, ALUOut, DR;
    PC pc(PClk, Reset, NextPC, PCWrite, Pc);
    IR ir(PClk, Reset, RData, IRWrite, Ir);
    assign Opcode = Ir[31:26];
    assign Funct = Ir[5:0];
    assign RT = Ir[20:16];
    MUX2 #(32) M0(Pc, ALUOut, IorD, ADDR);
    MUX3 #(5) M1(Ir[20:16], Ir[15:11], 5'h1F, RegDst, RD);
    RegFile RF(PClk, Reset, Ir[25:21], Ir[20:16], RD, RegWrite, WbData, RData1, RData2);
    Ext ext(Ir[15:0], ExtFunct, Imm);
    assign SImm = {Imm[29:0], 2'b00};
    MUX2 #(32) M3(Pc, A, ALUSrcA, ALU1);
    MUX4 #(32) M4(B, 32'b100, Imm, SImm, ALUSrcB, ALU2);
    ALU alu(ALU1, ALU2, ALUOp, Alu, Zero, Compare);
    MUX2 #(5) M5(A[4:0], Ir[10:6], SHTNumSrc, SHTLen);
    Shifter shifter(B, SHTLen, SHTOp, SHTOut);
    MulDiv MulDiv(PClk, Reset, A, B, MulStart, MulSelMD, MulSelSU, MulSelHL, MulWrite, MulReady, MulOut);
    MUX5 #(32) M6(Alu, SHTOut, MulOut, Imm, CP0DOut, ALUOutSrc, ALUOutIn);
    MUX2 #(5) M7(5'h0E, Ir[15:11], CP0ASrc, CP0Idx);
    MUX3 #(32) M9(ALUOut, Alu, Pc, CP0DSrc, CP0DIn);
    CP0 CP0(PClk, Reset, CP0Idx, CP0DIn, CP0Write, ExcEnter, ExcCode, HWInt, CP0DOut, SR_IM, SR_EXL, SR_IE, EPC, eret);
    assign WData = B;
    DExt dext(DR, DExtFunct, ALUOut[1:0], Dae);
    MUX3 #(32) M2(ALUOut, Dae, Pc, RFSource, WbData);
    Vector Vector(ExcCode, vector);
    MUX6 #(32) M8(Alu, ALUOut, {Pc[31:28], Ir[25:0], 2'b0}, A, vector, EPC, PCSource, NextPC);
    always @(posedge PClk)begin
        A <= RData1;
        B <= RData2;
        ALUOut <= ALUOutIn;
        DR <= RData;
    end
endmodule

