module MUX2 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1,
            input sel,
            output [WIDTH-1:0] Out);
    assign Out = sel ? In1 : In0;
endmodule

module MUX3 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1, In2, 
            input [1:0] sel, 
            output [WIDTH-1:0] Out);
    assign Out = (sel == 2'b00)? In0 :
                 (sel == 2'b01)? In1 :
                 (sel == 2'b10)? In2 : 0;
endmodule
module MUX4 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1, In2, In3, 
            input [1:0] sel, 
            output [WIDTH-1:0] Out);
    assign Out = (sel == 2'b00)? In0 :
                 (sel == 2'b01)? In1 :
                 (sel == 2'b10)? In2 :
                 (sel == 2'b11)? In3 : 0;
endmodule
module MUX5 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1, In2, In3, In4, 
            input [2:0] sel, 
            output [WIDTH-1:0] Out);
    assign Out = (sel == 3'b000)? In0 :
                 (sel == 3'b001)? In1 :
                 (sel == 3'b010)? In2 :
                 (sel == 3'b011)? In3 : 
                 (sel == 3'b100)? In4 : 0;
endmodule
module MUX6 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1, In2, In3, In4, In5, 
            input [2:0] sel, 
            output [WIDTH-1:0] Out);
    assign Out = (sel == 3'b000)? In0 :
                 (sel == 3'b001)? In1 :
                 (sel == 3'b010)? In2 :
                 (sel == 3'b011)? In3 :
                 (sel == 3'b100)? In4 : 
                 (sel == 3'b101)? In5 : 0;
endmodule
module MUX7 # (parameter WIDTH = 8)
           (input [WIDTH-1:0] In0, In1, In2, In3, In4, In5, In6, 
            input [2:0] sel, 
            output [WIDTH-1:0]Out);
    assign Out = (sel == 3'b000)? In0 :
                 (sel == 3'b001)? In1 :
                 (sel == 3'b010)? In2 :
                 (sel == 3'b011)? In3 : 
                 (sel == 3'b100)? In4 : 
                 (sel == 3'b101)? In5 : 
                 (sel == 3'b110)? In6 : 0;
endmodule