module DExt(input [31:0] Din, 
            input [2:0] ExtFunct, 
            input [1:0] A, 
            output [31:0] DExtout);
            `include "parameter.v"
    assign DExtout = (ExtFunct == DExtFunct_BU)?(
                         (A == 2'b00)? {24'b0, Din[7:0]}:
                         (A == 2'b01)? {24'b0, Din[15:8]}:
                         (A == 2'b10)? {24'b0, Din[23:16]}:
                         (A == 2'b11)? {24'b0, Din[31:24]}: Din):
                     (ExtFunct == DExtFunct_HU)?(
                         (A == 2'b00)? {16'b0, Din[15:0]}:
                         (A == 2'b10)? {16'b0, Din[31:16]}: Din):
                     (ExtFunct == DExtFunct_B)?(
                         (A == 2'b00)? {{24{Din[7]}}, Din[7:0]}:
                         (A == 2'b01)? {{24{Din[15]}}, Din[15:8]}:
                         (A == 2'b10)? {{24{Din[23]}}, Din[23:16]}:
                         (A == 2'b11)? {{24{Din[31]}}, Din[31:24]}: Din):
                     (ExtFunct == DExtFunct_H)?(
                         (A == 2'b00)? {{16{Din[15]}}, Din[15:0]}:
                         (A == 2'b10)? {{16{Din[31]}}, Din[31:16]}: Din ): Din;
endmodule
