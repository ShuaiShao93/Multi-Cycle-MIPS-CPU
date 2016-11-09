parameter Op_R = 6'b000000;
parameter Op_LW = 6'b100011;
parameter Op_SW = 6'b101011;
parameter Op_LBU = 6'b100100;
parameter Op_LHU = 6'b100101;
parameter Op_LB = 6'b100000;
parameter Op_LH = 6'b100001;
parameter Op_SB = 6'b101000;
parameter Op_SH = 6'b101001;
parameter Op_BEQ = 6'b000100;
parameter Op_BNE = 6'b000101;
parameter Op_BGEZ = 6'b000001;
parameter Op_BGTZ = 6'b000111;
parameter Op_BLEZ = 6'b000110;
parameter Op_BLTZ = 6'b000001;
parameter Op_ADDI = 6'b001000;
parameter Op_ADDIU = 6'b001001;
parameter Op_ANDI = 6'b001100;
parameter Op_ORI = 6'b001101;
parameter Op_XORI = 6'b001110;
parameter Op_LUI = 6'b001111;
parameter Op_SLTI = 6'b001010;
parameter Op_SLTIU = 6'b001011;
parameter Op_J = 6'b000010;
parameter Op_JAL = 6'b000011;
parameter Op_MFC0 = 6'b010000;
parameter Op_MTC0 = 6'b010000;

parameter Funct_ADD = 6'b100000;
parameter Funct_ADDU = 6'b100001;
parameter Funct_SUB = 6'b100010;
parameter Funct_SUBU = 6'b100011;
parameter Funct_MULT = 6'b011000;
parameter Funct_MULTU = 6'b011001;
parameter Funct_DIV = 6'b011010;
parameter Funct_DIVU = 6'b011011;
parameter Funct_AND = 6'b100100;
parameter Funct_OR = 6'b100101;
parameter Funct_NOR = 6'b100111;
parameter Funct_XOR = 6'b100110;
parameter Funct_SLL = 6'b000000;
parameter Funct_SRL = 6'b000010;
parameter Funct_SRA = 6'b000011;
parameter Funct_SLLV = 6'b000100;
parameter Funct_SRLV = 6'b000110;
parameter Funct_SRAV = 6'b000111;
parameter Funct_SLT = 6'b101010;
parameter Funct_SLTU = 6'b101011;
parameter Funct_MFHI = 6'b010000;
parameter Funct_MFLO = 6'b010010;
parameter Funct_MTHI = 6'b010001;
parameter Funct_MTLO = 6'b010011;
parameter Funct_JR = 6'b001000;
parameter Funct_JALR = 6'b001001;
parameter Funct_BREAK = 6'b001101;
parameter Funct_SYSCALL = 6'b001100;

parameter C_ERET = 32'h42000018; 

parameter ALUOp_NOP = 5'b00000;
parameter ALUOp_ADDU = 5'b00001;
parameter ALUOp_ADD = 5'b00010;
parameter ALUOp_SUBU = 5'b00011;
parameter ALUOp_SUB = 5'b00100;
parameter ALUOp_AND = 5'b00101;
parameter ALUOp_OR = 5'b00110;
parameter ALUOp_NOR = 5'b00111;
parameter ALUOp_XOR = 5'b01000;
parameter ALUOp_SLTU = 5'b01001;
parameter ALUOp_SLT = 5'b01010;
parameter ALUOp_LTZ = 5'b01011;
parameter ALUOp_LEZ = 5'b01100;
parameter ALUOp_GTZ = 5'b01101;
parameter ALUOp_GEZ = 5'b01110;
parameter ALUOp_SEQ = 5'b01111;
parameter ALUOp_SNE = 5'b10000;

parameter SHTOp_NOP = 2'b00;
parameter SHTOp_SLL = 2'b01;
parameter SHTOp_SRL = 2'b10;
parameter SHTOp_SRA = 2'b11;

parameter MorD_M = 1'b0;
parameter MorD_D = 1'b1;

parameter SorU_S = 1'b0;
parameter SorU_U = 1'b1;

parameter HorL_H = 1'b0;
parameter HorL_L = 1'b1;

parameter IorD_PC = 1'b0;
parameter IorD_ALUOUT = 1'b1;

parameter RegDst_RT = 2'b00;
parameter RegDst_RD = 2'b01;
parameter RegDst_1F = 2'b10;

parameter RFSource_ALUOUT = 2'b00;
parameter RFSource_MDR = 2'b01;
parameter RFSource_PC = 2'b10;

parameter ALUSrcA_PC = 1'b0;
parameter ALUSrcA_REG = 1'b1;

parameter ALUSrcB_REG = 2'b00;
parameter ALUSrcB_4 = 2'b01;
parameter ALUSrcB_IMM = 2'b10;
parameter ALUSrcB_SIMM = 2'b11;

parameter ExtFunct_SIGN = 2'b01;
parameter ExtFunct_ZERO = 2'b00;
parameter ExtFunct_LUI =  2'b10;

parameter SHTNumSrc_REG = 1'b0;
parameter SHTNumSrc_IR = 1'b1;

parameter CP0ASrc_0E = 1'b0;
parameter CP0ASrc_RD = 1'b1;

parameter CP0DSrc_ALUOUT = 2'b00;
parameter CP0DSrc_ALU = 2'b01;
parameter CP0DSrc_PC = 2'b10;

parameter ALUOutSrc_ALU = 3'b000;
parameter ALUOutSrc_SHT = 3'b001;
parameter ALUOutSrc_MUL = 3'b010;
parameter ALUOutSrc_IMM = 3'b011;
parameter ALUOutSrc_CP0 = 3'b100;

parameter PCSource_ALU = 3'b000;
parameter PCSource_ALUOUT = 3'b001;
parameter PCSource_J = 3'b010;
parameter PCSource_REG = 3'b011;
parameter PCSource_VECTOR = 3'b100;
parameter PCSource_EPC = 3'b101;

parameter RW_R = 1'b1;
parameter RW_W = 1'b0;

parameter DExtFunct_W = 3'b000;
parameter DExtFunct_H = 3'b100;
parameter DExtFunct_B = 3'b011;
parameter DExtFunct_HU = 3'b010;
parameter DExtFunct_BU = 3'b001;

parameter CP0Idx_SR = 5'b01100;
parameter CP0Idx_Cause = 5'b01101;
parameter CP0Idx_EPC = 5'b01110;
parameter CP0Idx_PRId = 5'b01111;

parameter SR_IM7 = 5'b01111;
parameter SR_IM6 = 5'b01110;
parameter SR_IM5 = 5'b01101;
parameter SR_IM4 = 5'b01100;
parameter SR_IM3 = 5'b01011;
parameter SR_IM2 = 5'b01010;
parameter SR_EXL = 5'b00001;
parameter SR_IE  = 5'b00000;

parameter Cause_IP7 = 5'b01111;
parameter Cause_IP6 = 5'b01110;
parameter Cause_IP5 = 5'b01101;
parameter Cause_IP4 = 5'b01100;
parameter Cause_IP3 = 5'b01011;
parameter Cause_IP2 = 5'b01010;

parameter ExcCode_Interrupt = 5'b00000;
parameter ExcCode_Syscall = 5'b01000;
parameter ExcCode_BP = 5'b01001;
parameter ExcCode_RI = 5'b01010;

parameter CC_N = 1'b0;
parameter CC_Y = 1'b1;
parameter MP_N = 1'b0;
parameter MP_Y = 1'b1;
parameter MMU_N = 1'b0;
parameter MMU_Y = 1'b1;
parameter Pipeline_N = 1'b0;
parameter Pipeline_Y = 1'b1;
parameter Cache_N = 1'b0;
parameter Cache_Y = 1'b1;
parameter Revision = 8'h10;

parameter FETCH = 5'b00000;
parameter DECODE = 5'b00001;
parameter MEMADR = 5'b00010;
parameter MEMREAD = 5'b00011;
parameter MEMWB = 5'b00100;
parameter MEMW = 5'b00101;
parameter EXECUTE = 5'b00110;
parameter ALUWB = 5'b00111;
parameter BRANCH = 5'b01000;
parameter IEXECUTE = 5'b01001;
parameter IWB = 5'b01010;
parameter JUMP = 5'b01011;
parameter INTERRUPT = 5'b01100;
parameter SCEXCEPTION = 5'b01101;
parameter BPEXCEPTION = 5'b01110;
parameter RIEXCEPTION = 5'b01111;
parameter ERET = 5'b10000;

parameter TC0_CTRL = 4'b0000;
parameter TC0_PRESET= 4'b0001;
parameter TC0_COUNT = 4'b0010;
parameter TC1_CTRL = 4'b0011;
parameter TC1_PRESET= 4'b0100;
parameter TC1_COUNT = 4'b0101;
parameter TC2_CTRL = 4'b0110;
parameter TC2_PRESET= 4'b0111;
parameter TC2_COUNT = 4'b1000;

parameter AIM_IM = 2'b00;
parameter AIM_DM = 2'b01;
parameter AIM_WB = 2'b10;