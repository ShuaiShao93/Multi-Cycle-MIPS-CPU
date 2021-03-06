module CP0(
    input Clk, Reset,
    input [4:0] CP0Idx,
    input [31:0] DIn,
    input We,
    input ExcEnter,
    input [6:2] ExcCode,
    input [6:2] HWInt,
    output [31:0] DOut,
    output [7:2] SR_IM,
    output SR_exl,
    output SR_ie,
    output  [31:0] epc,
    input eret);
    `include "parameter.v"
    reg [31:0] SR,  //status reg。
    //15-10 : (IM7-2)硬件中断7-2中断屏蔽掩码。控制是否允许相应硬件中断。 0 : 不允许中断1 : 允许中断
    // 1 :  (EXL)异常级。任何异常发生时置位，并且禁止中断。目的是把EXL位维持足够长时间以便软件决定新的CPU特权级和中断屏蔽应设成什么。0 : 无异常发生1 : 有异常发生
    // 0 : (IE) 全局中断使能。  0 : 不允许中断     1 : 允许中断
               Cause,
    //15-10 : (IP7-2)指示发生的硬件中断7-2处于pending状态
    //6 - 2 : （ExcCode）异常编码。 0 : 中断 8 : 执行syscall指令导致异常 9 : 执行break指令导致异常 (调试器使用)  10 : 保留指令异常
               EPC,
    //EPC寄存器用于存储异常返回地址。导致(或遭受)异常的指令地址保存在EPC中。
               PRId;
    //23-16 : (Company ID)Company ID被定义为36h。该值是字符'6'的ASCII值，代表计算机学院(计算机学院的前身是6系)
    //   12 : (CC) 0：不支持Cache一致性  1：支持Cache一致性
    //   11 : (MP) 0：不支持多处理器   1：支持多处理器
    //   10 : (MMU) 0：不支持MMU  1：支持MMU
    //   9  : (Pipeline)  0：不支持流水线1：支持流水线
    //   8  : (Cache)  0：不支持Cache   1：支持Cache
    //7 - 0 : (Revision) 版本  7-4：大版本  3-0：小版本
    assign DOut = (CP0Idx == CP0Idx_SR)? SR :
                  (CP0Idx == CP0Idx_Cause)? Cause :
                  (CP0Idx == CP0Idx_EPC)? EPC :
                  (CP0Idx == CP0Idx_PRId)? PRId : 32'b0;
    assign epc = EPC[31:0];
    assign SR_IM = SR[15:0];
    assign SR_ie = SR[SR_IE];
    assign SR_exl = SR[SR_EXL];
    assign epc = EPC;
    always @(posedge Clk) begin
        if(Reset) begin
            SR[15:10] <= 6'b111111;
            SR[SR_EXL] <= 1'b0;
            SR[SR_IE] <= 1'b1;
            PRId <= {16'h4736, 3'b0, CC_N, MP_N, MMU_N, Pipeline_N, Cache_N, Revision};
        end
        else begin
            if(We) begin
                case(CP0Idx)
                    CP0Idx_SR: SR <= DIn;
                    CP0Idx_Cause: Cause <= DIn;
                    CP0Idx_EPC: EPC <= DIn;
                    CP0Idx_PRId: PRId <= DIn;
                endcase
                if(eret) begin
                    SR[SR_EXL] <= 1'b0;
                    SR[SR_IE] <= 1'b1;
                end
            end
            if(ExcEnter) begin
                Cause[6:2] <= ExcCode;
                SR[SR_EXL] <= 1;
                Cause[14:10] <= HWInt[6:2];
            end
        end
    end
endmodule