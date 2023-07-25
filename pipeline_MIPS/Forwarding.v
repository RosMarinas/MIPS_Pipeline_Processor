module Forwarding(
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input [4:0] EX_MEM_Write_Address,
    input [4:0] MEM_WB_Write_Address,
    input [4:0] ID_EX_Rs,
    input [4:0] ID_EX_Rt,
    input [4:0] IF_ID_Rs,
    input [5:0] IF_ID_Opcode,
    input [5:0] IF_ID_Function,
    input [5:0] ID_EX_Opcode,
    output [1:0] Forward_EXMEM_EX,
    output [1:0] Forward_MEMWB_EX,
    output  Forward_EXMEM_ID
);
    assign Forward_EXMEM_EX = (EX_MEM_RegWrite && (EX_MEM_Write_Address != 0) && (EX_MEM_Write_Address == ID_EX_Rs))?2'b10:
                               (MEM_WB_RegWrite && (MEM_WB_Write_Address != 0) && (MEM_WB_Write_Address == ID_EX_Rs))?2'b01:
                               2'b00;
    assign Forward_MEMWB_EX = (EX_MEM_RegWrite && (EX_MEM_Write_Address != 0) && (EX_MEM_Write_Address == ID_EX_Rt)&&((EX_MEM_Write_Address!=ID_EX_Rs)||ID_EX_Opcode==0)&&ID_EX_Opcode!=6'h2b)?2'b10:
                                 (MEM_WB_RegWrite && (MEM_WB_Write_Address != 0) && (MEM_WB_Write_Address == ID_EX_Rt)&&((MEM_WB_Write_Address!=ID_EX_Rs)||ID_EX_Opcode==0)&&ID_EX_Opcode!=6'h2b)
                                 ?2'b01:
                                 2'b00;
    assign Forward_EXMEM_ID = (EX_MEM_RegWrite && (EX_MEM_Write_Address != 0) && (EX_MEM_Write_Address == IF_ID_Rs)&&(IF_ID_Opcode==0)&&(IF_ID_Function==6'h8||IF_ID_Function==6'h09))?1'b1:1'b0;
endmodule
