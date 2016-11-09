module RegFile(input Clk, Reset, 
               input [4:0] RS1, RS2, RD, 
               input RegWrite, 
               input [31:0] WData,
               output [31:0] RData1,RData2);
    reg [31:0] Register [31:0];
    always @(posedge Clk)
    begin
        if(Reset)
        begin : reset
            integer i;
            for(i=0;i<=31;i=i+1)
                Register[i]<=32'hffffffff;
        end
        else
            if(RegWrite)
                Register[RD]<=WData;
    end
    assign RData1=(RS1==0)?0:Register[RS1];
    assign RData2=(RS2==0)?0:Register[RS2];        
endmodule