module Ext(input [15:0] Imm16,
           input [1:0] ExtFunct,
           output [31:0] ExtImm32);
           `include "parameter.v"
    assign ExtImm32 = (ExtFunct == ExtFunct_SIGN) ? {{16{Imm16[15]}},Imm16}:
                      (ExtFunct == ExtFunct_LUI) ? {Imm16, 16'b0} : 
                      (ExtFunct == ExtFunct_ZERO) ? {16'b0,Imm16} : 32'b0;
endmodule
