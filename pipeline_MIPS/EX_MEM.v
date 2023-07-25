module EX_MEM(
    input clk,
    input rst,
    input [31:0] EX_PC,//
    input [31:0] EX_ALUOut,//
    input [31:0] EX_ReadData_2,//
    input [4:0] EX_Rs,//
    input [4:0] EX_Rt,//
    //input [4:0] EX_Rd,
    input [4:0] EX_Write_Address,//
    input [1:0] EX_MemtoReg,//
    input EX_MemWrite,//
    input EX_RegWrite,//
    input EX_MemRead,//
    output reg [31:0] MEM_PC,//
    output reg [31:0] MEM_ALUOut,//
    output reg [31:0] MEM_ReadData_2,//
    output reg [4:0] MEM_Rs,//
    output reg [4:0] MEM_Rt,//
    //output reg [4:0] MEM_Rd,
    output reg [4:0] MEM_Write_Address,//
    output reg [1:0] MEM_MemtoReg,//
    output reg MEM_MemWrite,//
    output reg MEM_RegWrite,//
    output reg MEM_MemRead//
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        MEM_PC <= 0;//
        MEM_ALUOut <= 0;//
        MEM_ReadData_2 <= 0;//
        MEM_Rs <= 0;//
        MEM_Rt <= 0;//
        //MEM_Rd <= 0;
        MEM_Write_Address <= 0;//
        MEM_MemtoReg <= 0;//
        MEM_MemWrite <= 0;//
        MEM_RegWrite <= 0;//
        MEM_MemRead <= 0;//
    end
    else begin
        MEM_PC <= EX_PC;//
        MEM_ALUOut <= EX_ALUOut;//
        MEM_ReadData_2 <= EX_ReadData_2;//
        MEM_Rs <= EX_Rs;//
        MEM_Rt <= EX_Rt;//
        //MEM_Rd <= EX_Rd;
        MEM_Write_Address <= EX_Write_Address;//
        MEM_MemtoReg <= EX_MemtoReg;//
        MEM_MemWrite <= EX_MemWrite;//
        MEM_RegWrite <= EX_RegWrite;//
        MEM_MemRead <= EX_MemRead;//
    end
end
endmodule