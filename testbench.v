module testbench();
    reg PClk, Reset;
    initial begin
        PClk = 1;
        Reset = 1; #80 Reset = 0;
    end
    always
        #30 PClk = ~PClk;
    top top(PClk, Reset);
endmodule