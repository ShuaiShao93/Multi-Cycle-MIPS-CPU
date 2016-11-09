module PC(input Clk, Reset,
          input [31:0] NextPC,
          input PCW,
          output reg [31:0] PC);
    always @(posedge Clk)
        if(Reset)
           PC <= 32'hBFC00000;
        else
           if(PCW)
              PC <= NextPC;
endmodule
