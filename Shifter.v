module Shifter (
   input [31:0] B,
   input [4:0] Len,
   input [1:0] SHTOp,
   output reg [31:0] SHTOut
   );
   `include "parameter.v"
    always @(*) begin
        case(SHTOp)
            SHTOp_NOP:
                SHTOut = B;
            SHTOp_SLL: begin
                SHTOut = Len[0]? {B[30:0], 1'b0} : B;
                SHTOut = Len[1]? {SHTOut[29:0], 2'b0} : SHTOut;
                SHTOut = Len[2]? {SHTOut[27:0], 4'b0} : SHTOut;
                SHTOut = Len[3]? {SHTOut[23:0], 8'b0} : SHTOut;
                SHTOut = Len[4]? {SHTOut[15:0], 16'b0} : SHTOut;
            end
            SHTOp_SRL: begin
                SHTOut = Len[0]? {1'b0, B[31:1]} : B;
                SHTOut = Len[1]? {2'b0, SHTOut[31:2]} : SHTOut;
                SHTOut = Len[2]? {4'b0, SHTOut[31:4]} : SHTOut;
                SHTOut = Len[3]? {8'b0, SHTOut[31:8]} : SHTOut;
                SHTOut = Len[4]? {16'b0, SHTOut[31:16]} : SHTOut;
            end
            SHTOp_SRA: begin
                SHTOut = Len[0]? {B[31], B[31:1]} : B;
                SHTOut = Len[1]? {{2{B[31]}}, SHTOut[31:2]} : SHTOut;
                SHTOut = Len[2]? {{4{B[31]}}, SHTOut[31:4]} : SHTOut;
                SHTOut = Len[3]? {{8{B[31]}}, SHTOut[31:8]} : SHTOut;
                SHTOut = Len[4]? {{16{B[31]}}, SHTOut[31:16]} : SHTOut;
            end
        endcase
    end
endmodule