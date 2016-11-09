module control(input PClk,
               input Reset,
               input [5:0] Opcode,
               input [5:0] Funct,
               input [4:0] RS, RT,
               input Compare,
               output reg PCWrite, IRWrite, RegWrite,
               output reg [1:0] RF_Dst, RF_Src,
               output reg [4:0] ALUOp,
               output reg [1:0] SHTOp,
               output reg MorD, SorU, MulStart, HorL, MulWrite,
               input MulReady,
               output reg CP0Write,
               output reg PrExcEnter,
               output reg [6:2] PrExcCode,
               input [6:2] HWInt,
               input [7:2] SR_im,
               input SR_exl, SR_ie,
               output reg IorD,
               output reg [1:0] ExtFunct,
               output reg [1:0] RegDst, RFSource,
               output reg ALUSrcA,
               output reg [1:0] ALUSrcB,
               output reg SHTNumSrc,
               output reg [2:0] ALUOutSrc,
               output reg CP0ASrc,
               output reg [2:0] PCSource,
               output reg [1:0] CP0DSrc,
               output reg [2:0] DExtFunct,
               input [1:0] A,
               output reg [3:0] BE,
               output reg Req, RW,
               input Ready,
               output reg eret);
    `include "parameter.v"
    reg [4:0] state;
    wire Inter;
    assign Inter = SR_ie && ~SR_exl && ((HWInt[6] && SR_im[6]) || (HWInt[5] && SR_im[5]) || (HWInt[4] && SR_im[4]) || (HWInt[3] && SR_im[3]) || (HWInt[2] && SR_im[2]));
    always @(posedge PClk) begin
    if(Reset)
        state <= FETCH;
    else
    case(state)
        FETCH: begin
            if(Ready)
                state <= DECODE;
        end
        DECODE:begin
            if(Opcode == 6'b010000 && Funct == 6'b011000)
                state <= ERET;
            else
            case(Opcode)
                Op_R:  begin
                    case(Funct)
                        Funct_BREAK:begin
                            state <= BPEXCEPTION;
                        end
                        Funct_SYSCALL:begin
                            state <= SCEXCEPTION;
                        end
                        Funct_JR: begin
                            state <= JUMP;
                        end
                        Funct_JALR: begin
                            state <= JUMP;
                        end
                        default: begin
                                state <= EXECUTE;
                        end
                    endcase
                end
                Op_LW:  begin
                    state <= MEMADR;
                end
                Op_LBU: begin
                    state <= MEMADR;
                end
                Op_LHU:  begin
                    state <= MEMADR;
                end
                Op_LB:  begin
                    state <= MEMADR;
                end
                Op_LH:  begin
                    state <= MEMADR;
                end
                Op_SW: begin
                    state <= MEMADR;
                end
                Op_SB: begin
                    state <= MEMADR;
                end
                Op_SH: begin
                    state <= MEMADR;
                end
                Op_BEQ: begin
                    state <= BRANCH;
                end
                Op_BNE: begin
                    state <= BRANCH;
                end
                Op_BGEZ: begin
                    state <= BRANCH;
                end
                Op_BGTZ: begin
                    state <= BRANCH;
                end
                Op_BLEZ: begin
                    state <= BRANCH;
                end
                Op_BLTZ: begin
                    state <= BRANCH;
                end
                Op_ADDI: begin
                    state <= IEXECUTE;
                end
                Op_ADDIU: begin
                    state <= IEXECUTE;
                end
                Op_ANDI: begin
                    state <= IEXECUTE;
                end
                Op_ORI: begin
                    state <= IEXECUTE;
                end
                Op_XORI: begin
                    state <= IEXECUTE;
                end
                Op_LUI : begin
                    state <= IEXECUTE;
                end
                Op_SLTI: begin
                    state <= IEXECUTE;
                end
                Op_SLTIU: begin
                    state <= IEXECUTE;
                end
                Op_J: begin
                    state <= JUMP;
                end
                Op_JAL: begin
                    state <= JUMP;
                end
                Op_MFC0: begin
                    state <= EXECUTE;
                end
                default: begin
                    if(Inter)
                        state <= INTERRUPT;
                    else
                        state <= FETCH;
                end
            endcase
        end
        MEMADR:begin
            case(Opcode)
                Op_LW: state <= MEMREAD;
                Op_LBU: state <= MEMREAD;
                Op_LHU: state <= MEMREAD;
                Op_LB: state <= MEMREAD;
                Op_LH: state <= MEMREAD;
                Op_SB: state <= MEMW;
                Op_SW: state <= MEMW;
                Op_SH: state <= MEMW;
            endcase
        end
        MEMREAD:begin
            if(Ready)
                state <= MEMWB;
        end
        MEMWB:begin
            if(Inter)
                state <= INTERRUPT;
            else
                state <= FETCH;
        end
        MEMW:begin
            if(Inter)
                state <= INTERRUPT;
            else
                if(Ready)
                    state <= FETCH;
        end
        EXECUTE:begin
            if(((Funct == Funct_MULT || Funct == Funct_MULTU || Funct == Funct_DIV || Funct == Funct_DIVU) && MulReady) || Funct == Funct_MTHI || Funct == Funct_MTLO)
                if(Inter)
                    state <= INTERRUPT;
                else
                    state <= FETCH;
            else if((Funct == Funct_MULT || Funct == Funct_MULTU || Funct == Funct_DIV || Funct == Funct_DIVU) && ~MulReady)
                state <= EXECUTE;
            else if(Opcode == Op_R)
                state <= ALUWB;
            else if(Opcode == Op_MTC0 || RS == 5'b00100)
                if(Inter)
                    state <= INTERRUPT;
                else
                    state <= FETCH;
        end
        ALUWB:begin
            if(Inter)
                state <= INTERRUPT;
            else
                state <= FETCH;
        end
        BRANCH:begin
            if(Inter)
                state <= INTERRUPT;
            else
                state <= FETCH;
        end
        IEXECUTE:begin
            state <= IWB;
        end
        IWB:begin
            if(Inter)
                state <= INTERRUPT;
            else
                state <= FETCH;
        end
        JUMP:begin
            if(Inter)
                state <= INTERRUPT;
            else
                state <= FETCH;
        end
        INTERRUPT: begin
            state <= FETCH;
        end
        SCEXCEPTION: begin
            state <= FETCH;
        end
        BPEXCEPTION: begin
            state <= FETCH;
        end
        ERET: begin
            state <= FETCH;
        end
    endcase
end
always @(*)
    case(state)
        FETCH: begin
            if(Ready) begin
                PCWrite <= 1;
                IRWrite <= 1;
            end
            else begin
                PCWrite <= 0;
                IRWrite <= 0;
            end
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            eret <= 0;
            ExtFunct <= ExtFunct_SIGN;
            ALUOp <= ALUOp_ADDU;
            IorD <= IorD_PC;
            ALUSrcA <= ALUSrcA_PC;
            ALUSrcB <= ALUSrcB_4;
            PCSource <= PCSource_ALU;
            BE <= 4'b1111;
            Req <= 1;
            RW <= RW_R;
        end
        DECODE: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            ExtFunct <= ExtFunct_SIGN;
            ALUOp <= ALUOp_ADD;
            ALUSrcA <= ALUSrcA_PC;
            ALUSrcB <= ALUSrcB_SIMM;
            ALUOutSrc <= ALUOutSrc_ALU;
            Req <= 0;
        end
        MEMADR: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            ExtFunct <= ExtFunct_SIGN;
            ALUOp <= ALUOp_ADD;
            ALUSrcA <= ALUSrcA_REG;
            ALUSrcB <= ALUSrcB_IMM;
            ALUOutSrc <= ALUOutSrc_ALU;
            Req <= 0;
        end
        MEMREAD: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            IorD <= IorD_ALUOUT;
            Req <= 1;
            RW <= RW_R;
            case(Opcode)
                Op_LW: begin
                    BE <= 4'b1111;
                    DExtFunct <= DExtFunct_W;
                end
                Op_LB: begin
                    BE <= (A == 2'b11)? 4'b1000:
                         (A == 2'b10)? 4'b0100:
                         (A == 2'b01)? 4'b0010:
                         (A == 2'b00)? 4'b0001: 4'b1111;
                    DExtFunct <= DExtFunct_B;
                end
                Op_LH: begin
                    BE <= (A == 2'b10)? 4'b1100:
                         (A == 2'b00)? 4'b0011: 4'b1111;
                    DExtFunct <= DExtFunct_H;
                end
                Op_LBU: begin
                    BE <= (A == 2'b11)? 4'b1000:
                         (A == 2'b10)? 4'b0100:
                         (A == 2'b01)? 4'b0010:
                         (A == 2'b00)? 4'b0001: 4'b1111;
                    DExtFunct <= DExtFunct_BU;
                end
                Op_LHU: begin
                    BE <= (A == 2'b10)? 4'b1100:
                         (A == 2'b00)? 4'b0011: 4'b1111;
                    DExtFunct <= DExtFunct_HU;
                end
        endcase
        end
        MEMWB: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 1;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            RegDst <= RegDst_RT;
            RFSource <= RFSource_MDR;
            Req <= 0;
        end
        MEMW: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            IorD <= IorD_ALUOUT;
            Req <= 1;
            RW <= RW_W;
            case(Opcode)
                Op_SW: begin
                    BE <= 4'b1111;
                end
                Op_SB: begin
                    BE <= (A == 2'b11)? 4'b1000:
                         (A == 2'b10)? 4'b0100:
                         (A == 2'b01)? 4'b0010:
                         (A == 2'b00)? 4'b0001: 4'b1111;
                end
                Op_SH: begin
                    BE <= (A == 2'b10)? 4'b1100:
                         (A == 2'b00)? 4'b0011: 4'b1111;
                end
            endcase
        end
        EXECUTE: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            PrExcEnter <= 0;
            ALUSrcA <= ALUSrcA_REG;
            ALUSrcB <= ALUSrcB_REG;
            if(Opcode == Op_R) begin
                CP0Write <= 0;
                case(Funct)
                    Funct_ADD: begin
                        ALUOp <= ALUOp_ADD;
                        ALUOutSrc <= ALUOutSrc_ALU;
                        MulWrite <= 0;
                    end
                    Funct_ADDU: begin
                        ALUOp <= ALUOp_ADDU;
                        ALUOutSrc <= ALUOutSrc_ALU;
                        MulWrite <= 0;
                    end
                    Funct_SUB: begin
                        ALUOp <= ALUOp_SUB;
                        ALUOutSrc <= ALUOutSrc_ALU;
                        MulWrite <= 0;
                    end
                    Funct_SUBU:begin
                        ALUOp <= ALUOp_SUBU;
                        ALUOutSrc <= ALUOutSrc_ALU;
                        MulWrite <= 0;
                    end
                    Funct_MULT: begin
                        MorD <= MorD_M;
                        SorU <= SorU_S;
                        MulWrite <= 0;
                        if(MulReady)
                            MulStart <= 0;
                        else
                            MulStart <= 1;
                    end
                    Funct_MULTU: begin
                        MorD <= MorD_M;
                        SorU <= SorU_U;
                        MulWrite <= 0;
                        if(MulReady)
                            MulStart <= 0;
                        else
                            MulStart <= 1;
                    end
                    Funct_DIV: begin
                        MorD <= MorD_D;
                        SorU <= SorU_S;
                        MulWrite <= 0;
                        if(MulReady)
                            MulStart <= 0;
                        else
                            MulStart <= 1;
                    end
                    Funct_DIVU: begin
                        MorD <= MorD_D;
                        SorU <= SorU_U;
                        MulWrite <= 0;
                        if(MulReady)
                            MulStart <= 0;
                        else
                            MulStart <= 1;
                    end
                    Funct_MFHI: begin
                        HorL <= HorL_H;
                        MulWrite <= 0;
                        ALUOutSrc <= ALUOutSrc_MUL;
                    end
                    Funct_MFLO: begin
                        HorL <= HorL_L;
                        MulWrite <= 0;
                        ALUOutSrc <= ALUOutSrc_MUL;
                    end
                    Funct_MTHI: begin
                        HorL <= HorL_H;
                        MulWrite <= 1;
                    end
                    Funct_MTLO: begin
                        HorL <= HorL_L;
                        MulWrite <= 1;
                    end
                    Funct_AND: begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_AND;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_OR:begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_OR;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_NOR: begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_NOR;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_XOR: begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_XOR;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_SLT: begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_SLT;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_SLTU: begin
                        MulWrite <= 0;
                        ALUOp <= ALUOp_SLTU;
                        ALUOutSrc <= ALUOutSrc_ALU;
                    end
                    Funct_SLL: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SLL;
                        SHTNumSrc <= SHTNumSrc_IR;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                    Funct_SRL: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SRL;
                        SHTNumSrc <= SHTNumSrc_IR;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                    Funct_SRA: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SRA;
                        SHTNumSrc <= SHTNumSrc_IR;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                    Funct_SLLV: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SLL;
                        SHTNumSrc <= SHTNumSrc_REG;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                    Funct_SRL: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SRL;
                        SHTNumSrc <= SHTNumSrc_REG;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                    Funct_SRA: begin
                        MulWrite <= 0;
                        SHTOp <= SHTOp_SRA;
                        SHTNumSrc <= SHTNumSrc_REG;
                        ALUOutSrc <= ALUOutSrc_SHT;
                    end
                endcase
            end
            else
                if(Opcode == Op_MFC0 || RS == 5'b00000) begin
                    CP0Write <= 0;
                    MulWrite <= 0;
                    CP0ASrc <= CP0ASrc_RD;
                    ALUOutSrc <= ALUOutSrc_CP0;
                end
                else if(Opcode == Op_MTC0 || RS == 5'b00100) begin
                    CP0Write <= 1;
                    MulWrite <= 0;
                    CP0ASrc <= CP0ASrc_RD;
                    CP0DSrc <= CP0DSrc_ALU;
                    ALUOp <= ALUOp_NOP;
                end
        end
        ALUWB: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 1;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            RegDst <= RegDst_RD;
            RFSource <= RFSource_ALUOUT;
        end
        BRANCH: begin
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            case(Opcode)
                Op_BEQ : ALUOp <= ALUOp_SEQ;
                Op_BNE : ALUOp <= ALUOp_SNE;
                Op_BGEZ : if(RT == 5'b00001)
                              ALUOp <= ALUOp_GEZ;
                          else if(RT == 5'b00000)
                              ALUOp <= ALUOp_LTZ;
                Op_BGTZ : ALUOp <= ALUOp_GTZ;
                Op_BLEZ : ALUOp <= ALUOp_LEZ;
            endcase
            ALUSrcA <= ALUSrcA_REG;
            ALUSrcB <= ALUSrcB_REG;
            ALUOutSrc <= ALUOutSrc_ALU;
            PCSource <= PCSource_ALUOUT;
            if(Compare)
                PCWrite <= 1;
            else
                PCWrite <= 0;
        end
        IEXECUTE:begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            ALUSrcA <= ALUSrcA_REG;
            ALUSrcB <= ALUSrcB_IMM;
            case(Opcode)
              Op_ADDI: begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_ADD;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_ADDIU: begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_ADDU;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_ANDI:  begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_AND;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_ORI:  begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_OR;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_XORI: begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_XOR;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_LUI: begin
                  ExtFunct <= ExtFunct_LUI;
                  ALUOutSrc <= ALUOutSrc_IMM;
              end
              Op_SLTI: begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_SLT;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
              Op_SLTIU: begin
                  ExtFunct <= ExtFunct_SIGN;
                  ALUOp <= ALUOp_SLTU;
                  ALUOutSrc <= ALUOutSrc_ALU;
              end
            endcase
        end
        IWB:begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 1;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            RegDst <= RegDst_RT;
            RFSource <= RFSource_ALUOUT;
        end
        JUMP:begin
            PCWrite <= 1;
            IRWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 0;
            PrExcEnter <= 0;
            if(Opcode == Op_J) begin
                PCSource <= PCSource_J;
                RegWrite <= 0;
            end
            else if(Opcode == Op_JAL) begin
                PCSource <= PCSource_J;
                RegWrite <= 1;
                RegDst <= RegDst_1F;
                RFSource <= RFSource_PC;
            end
            else if(Opcode == Op_R || Funct == Funct_JR) begin
                PCSource <= PCSource_REG;
                RegWrite <= 0;
            end
            else if(Opcode == Op_R || Funct == Funct_JALR) begin
                PCSource <= PCSource_REG;
                RegWrite <= 1;
                RegDst <= RegDst_1F;
                RFSource <= RFSource_PC;
            end
        end
        INTERRUPT: begin
            PCWrite <= 1;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 1;
            CP0ASrc <= CP0ASrc_0E;
            CP0DSrc <= CP0DSrc_PC;
            PrExcEnter <= 1;
            PrExcCode <= ExcCode_Interrupt;
            PCSource <= PCSource_VECTOR;
        end
        SCEXCEPTION: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 1;
            CP0ASrc <= CP0ASrc_0E;
            CP0DSrc <= CP0DSrc_PC;
            PrExcEnter <= 1;
            PrExcCode <= ExcCode_Syscall;
            PCSource <= PCSource_VECTOR;
        end
        BPEXCEPTION: begin
            PCWrite <= 0;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 1;
            CP0ASrc <= CP0ASrc_0E;
            CP0DSrc <= CP0DSrc_PC;
            PrExcEnter <= 1;
            PrExcCode <= ExcCode_BP;
            PCSource <= PCSource_VECTOR;
        end
        ERET: begin
            PCWrite <= 1;
            IRWrite <= 0;
            RegWrite <= 0;
            MulWrite <= 0;
            CP0Write <= 1;
            PrExcEnter <= 0;
            eret <= 1;
            PCSource <= PCSource_EPC;
        end
    endcase
endmodule