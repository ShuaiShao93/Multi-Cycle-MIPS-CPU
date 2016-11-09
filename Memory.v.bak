module IM(
    input PClk, Reset,
    input [12:2] A,
    output[31:0] RData);
    `include "parameter.v"
    reg [31:0] ROM [2048:0];
    assign RData = ROM[A];
    initial
    begin
    	 $readmemh("IM.dat",ROM);
	 end
endmodule

module DM(
    input PClk, Reset,
    input [14:2] A,
    input [3:0] BE,
    output[31:0] RData,
    input [31:0] WData,
    input We);
    `include "parameter.v"
    reg [31:0] RAM [8191:0];
    reg [31:0] gd;
    always @ (posedge PClk) begin
        if(Reset)
          ;
        else  begin
            if(We)
                begin
                    gd = BE[3]? WData[31:24] : RAM[A][31:24];
                    gd = BE[2]? WData[23:16] : RAM[A][23:16];
                    gd = BE[1]? WData[15:8] : RAM[A][15:8];
                    gd = BE[0]? WData[7:0] : RAM[A][7:0];
                    RAM[A] <= gd;
                end
        end
    end
    assign RData = RAM[A];
endmodule