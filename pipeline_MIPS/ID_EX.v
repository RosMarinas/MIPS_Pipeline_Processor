module ID_EX(
    //时钟及复�?
    input clk,
    input rst,
    input ID_Flush,
    //指令及数�?
    input [4:0] ID_Rs,
    input [4:0] ID_Rt,
    input [4:0] ID_Rd,
    input [4:0] ID_Shamt,
    input [31:0] ID_Imm,
    input [31:0] ID_ReadData_1,
    input [31:0] ID_ReadData_2,
    input [31:0] ID_PC,
    input [31:0] ID_PC_address,
    input [1:0] ID_PCSrc,
    input [5:0] ID_OPCode,
    //ID控制信号输入
    input ID_ALUSrc_1,
    input ID_ALUSrc_2,
    input ID_MemWrite,
    input ID_MemRead,
    input ID_RegWrite,
    input ID_Branch,
    input ID_Sign,
    input ID_LuOp,
    input [1:0] ID_RegDst,
    input [1:0] ID_MemtoReg,
    input [4:0] ID_ALUCtl,
    //EX指令
    output reg [31:0] EX_PC,
    output reg [31:0] EX_PC_address,//0
    output reg [31:0] EX_Imm,
    output reg [31:0] EX_ReadData_1,
    output reg [31:0] EX_ReadData_2,
    output reg [1:0] EX_PCSrc,
    output reg [5:0] EX_OPCode,
    //EX数据
    output reg [4:0] EX_Rs,
    output reg [4:0] EX_Rt,
    output reg [4:0] EX_Rd,
    output reg [4:0] EX_Shamt,//这里已经使用，为0
    //EX控制信号输出
    output reg EX_ALUSrc_1,//
    output reg EX_ALUSrc_2,//
    output reg EX_MemWrite,//
    output reg EX_MemRead,//这也�?0//
    output reg EX_Branch,//
    output reg EX_Sign,//
    output reg EX_RegWrite,//
    output reg EX_LuOp,//
    output reg [1:0] EX_RegDst,//
    output reg [1:0] EX_MemtoReg,//
    output reg [4:0] EX_ALUCtl//这也�?0
);
always @ (posedge clk or posedge rst) begin
    if (rst||ID_Flush) begin
        EX_PC <= 0;//
        EX_PC_address <= 0;//
        EX_Imm <= 0;//
        EX_ReadData_1 <= 0;//
        EX_ReadData_2 <= 0;//
        EX_PCSrc <= 0;//
        EX_OPCode <= 0;//
        EX_Rs <= 0;//
        EX_Rt <= 0;//
        EX_Rd <= 0;//
        EX_Shamt <= 0;//
        EX_ALUSrc_1 <= 0;//
        EX_ALUSrc_2 <= 0;//
        EX_MemWrite <= 0;//
        EX_MemRead <= 0;
        EX_Branch <= 0;//
        EX_Sign <= 0;//
        EX_RegWrite <= 0;//
        EX_LuOp <= 0;//
        EX_RegDst <= 0;//
        EX_MemtoReg <= 0;//
        EX_ALUCtl <= 0;//
    end
    else begin
        EX_PC <= ID_PC;//
        EX_PC_address <= ID_PC_address;//
        EX_Imm <= ID_Imm;//
        EX_ReadData_1 <= ID_ReadData_1;//
        EX_ReadData_2 <= ID_ReadData_2;//
        EX_PCSrc <= ID_PCSrc;//
        EX_OPCode <= ID_OPCode;//
        EX_Rs <= ID_Rs;//
        EX_Rt <= ID_Rt;//
        EX_Rd <= ID_Rd;//
        EX_Shamt <= ID_Shamt;//
        EX_ALUSrc_1 <= ID_ALUSrc_1;//
        EX_ALUSrc_2 <= ID_ALUSrc_2;//
        EX_MemWrite <= ID_MemWrite;//
        EX_MemRead <= ID_MemRead;//
        EX_Branch <= ID_Branch;//
        EX_Sign <= ID_Sign;//
        EX_RegWrite <= ID_RegWrite;//
        EX_LuOp <= ID_LuOp;
        EX_RegDst <= ID_RegDst;//
        EX_MemtoReg <= ID_MemtoReg;//
        EX_ALUCtl <= ID_ALUCtl;//
        end
end
endmodule