module Vector(
    input [6:2] ExcCode,
    output [31:0] Vector);
    `include "parameter.v"
    assign Vector = (ExcCode == ExcCode_Interrupt)? 32'hBFC00400 :
                    (ExcCode == ExcCode_Syscall)? 32'hBFC00380 :
                    (ExcCode == ExcCode_BP)? 32'hBFC00380 :
                    (ExcCode == ExcCode_RI)? 32'hBFC00380 : 32'b0;
endmodule