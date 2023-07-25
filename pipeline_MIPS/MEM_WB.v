module MEM_WB(
    input clk,
    input rst,
    input [31:0] MEM_PC,//
    input [31:0] MEM_ALU_Out,//
    input [31:0] MEM_Read_Data,//
    input [1:0] MEM_MemtoReg,//
    input [4:0] MEM_Write_Address,//
    input MEM_RegWrite,//
    output reg [31:0] WB_PC,//
    output reg [31:0] WB_ALU_Out,//
    output reg [31:0] WB_Read_Data,//
    output reg [1:0] WB_MemtoReg,//
    output reg [4:0] WB_Write_Address,//
    output reg WB_RegWrite//
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        WB_PC <= 0;//
        WB_ALU_Out <= 0;//
        WB_Read_Data <= 0;//
        WB_MemtoReg <= 0;//
        WB_Write_Address <= 0;//
        WB_RegWrite <= 0;//
    end
    else begin
        WB_PC <= MEM_PC;//
        WB_ALU_Out <= MEM_ALU_Out;//
        WB_Read_Data <= MEM_Read_Data;//
        WB_MemtoReg <= MEM_MemtoReg;//
        WB_Write_Address <= MEM_Write_Address;//
        WB_RegWrite <= MEM_RegWrite;//
    end
end
endmodule
