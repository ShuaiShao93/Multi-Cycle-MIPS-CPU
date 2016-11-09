module TC(
    input CLK, RST,
    input [5:2] ADD,
    input STB, WE,
    input [31:0] DAT_I,
    output [31:0] DAT_O,
    output [2:0] OUT);
    `include "parameter.v"
    reg [31:0] REG [15:0];
    assign DAT_O = REG[ADD];
    assign OUT[0] = (REG[TC0_CTRL][2:1] == 2'b00)? (REG[TC0_COUNT] == 32'b0) && STB:
                    (REG[TC0_CTRL][2:1] == 2'b01)? (REG[TC0_COUNT] == 32'b0) && STB:
                    (REG[TC0_CTRL][2:1] == 2'b10)? (REG[TC0_COUNT] >= {1'b0, REG[TC0_PRESET][31:1]}) && STB : 0;
    assign OUT[1] = (REG[TC1_CTRL][2:1] == 2'b00)? (REG[TC1_COUNT] == 32'b0) && STB: 
                    (REG[TC1_CTRL][2:1] == 2'b01)? (REG[TC1_COUNT] == 32'b0) && STB:
                    (REG[TC1_CTRL][2:1] == 2'b10)? (REG[TC1_COUNT] >= {1'b0, REG[TC1_PRESET][31:1]}) && STB: 0;
    assign OUT[2] = (REG[TC2_CTRL][2:1] == 2'b00)? (REG[TC2_COUNT] == 32'b0) && STB : 
                    (REG[TC2_CTRL][2:1] == 2'b01)? (REG[TC2_COUNT] == 32'b0) && STB :
                    (REG[TC2_CTRL][2:1] == 2'b10)? (REG[TC2_COUNT] >= {1'b0, REG[TC2_PRESET][31:1]}) && STB : 0;
    always @ (posedge CLK) begin
        if(RST) begin
            REG[TC0_CTRL] <= 32'b0;
            REG[TC1_CTRL] <= 32'b0;
            REG[TC2_CTRL] <= 32'b0;
            REG[TC0_COUNT] <= 32'h11111111;
            REG[TC1_COUNT] <= 32'h11111111;
            REG[TC2_COUNT] <= 32'h11111111;
        end
        else begin
            case(REG[TC0_CTRL][2:1])
                2'b00: begin
                    if(REG[TC0_CTRL][0])
                        REG[TC0_COUNT] <= (REG[TC0_COUNT] == 0)? 0 : REG[TC0_COUNT] - 1;
                    if(REG[TC0_COUNT] == 0)
                        REG[TC0_CTRL][0] <= 0;
                end
                2'b01: begin
                    if(REG[TC0_CTRL][0]) 
                        REG[TC0_COUNT] <= (REG[TC0_COUNT] == 0)? REG[TC0_PRESET] : REG[TC0_COUNT] - 1;
                end
                2'b10: begin
                    if(REG[TC0_CTRL][0]) 
                        REG[TC0_COUNT] <= (REG[TC0_COUNT] == 0)? {REG[TC0_PRESET][31:1], 1'b0} : REG[TC0_COUNT] - 1;
                end
            endcase
            case(REG[TC1_CTRL][2:1])
                2'b00: begin
                    if(REG[TC1_CTRL][0])
                        REG[TC1_COUNT] <= (REG[TC1_COUNT] == 0)? 0 : REG[TC1_COUNT] - 1;
                    if(REG[TC1_COUNT] == 0)
                        REG[TC1_CTRL][0] <= 0;
                end
                2'b01: begin
                    if(REG[TC1_CTRL][0]) 
                        REG[TC1_COUNT] <= (REG[TC1_COUNT] == 0)? REG[TC1_PRESET] : REG[TC1_COUNT] - 1;
                end
                2'b10: begin
                    if(REG[TC1_CTRL][0]) 
                        REG[TC1_COUNT] <= (REG[TC1_COUNT] == 0)? {REG[TC1_PRESET][31:1], 1'b0} : REG[TC1_COUNT] - 1;
                end
            endcase
            case(REG[TC2_CTRL][2:1])
                2'b00: begin
                    if(REG[TC2_CTRL][0])
                        REG[TC2_COUNT] <= (REG[TC2_COUNT] == 0)? 0 : REG[TC2_COUNT] - 1;
                    if(REG[TC2_COUNT] == 0)
                        REG[TC2_CTRL][0] <= 0;    
                end
                2'b01: begin
                    if(REG[TC2_CTRL][0]) 
                        REG[TC2_COUNT] <= (REG[TC2_COUNT] == 0)? REG[TC2_PRESET] : REG[TC2_COUNT] - 1;
                end
                2'b10: begin
                    if(REG[TC2_CTRL][0]) 
                        REG[TC2_COUNT] <= (REG[TC2_COUNT] == 0)? {REG[TC2_PRESET][31:1], 1'b0} : REG[TC2_COUNT] - 1;
                end
            endcase
            if(WE) begin
                REG[ADD] <= DAT_I;   
                if(REG[TC0_CTRL][0] == 0 && ADD == TC0_CTRL && DAT_I[0] == 1)
                    REG[TC0_COUNT] <= (REG[TC0_CTRL][2:1] == 2'b10)? {REG[TC0_PRESET][31:1], 1'b0} : REG[TC0_PRESET]; 
                if(REG[TC1_CTRL][0] == 0 && ADD == TC1_CTRL && DAT_I[0] == 1)
                    REG[TC1_COUNT] <= (REG[TC1_CTRL][2:1] == 2'b10)? {REG[TC1_PRESET][31:1], 1'b0} : REG[TC1_PRESET]; 
                if(REG[TC2_CTRL][0] == 0 && ADD == TC2_CTRL && DAT_I[0] == 1)
                    REG[TC1_COUNT] <= (REG[TC2_CTRL][2:1] == 2'b10)? {REG[TC2_PRESET][31:1], 1'b0} : REG[TC2_PRESET]; 

            end
        end
    end
endmodule