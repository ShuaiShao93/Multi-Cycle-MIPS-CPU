module IR(input Clk, Reset, 
          input [31:0] IMData, 
          input IRWr,
          output reg [31:0] IR);
    always @(posedge Clk)
       if(Reset)
          IR <= 32'b0;
       else
          if(IRWr)
             IR <= IMData;
endmodule