module IF_ID(
    input clk,
    input rst,
    input Stall,
    input IF_Flush,
    //input IRQ,
    input [31:0] IF_PC,
    input [31:0] IF_Instruction,
    output reg [31:0] ID_Instruction,
    output reg [31:0] ID_PC
);
  //  ID_PC=0;
   // ID_Instruction=0;
    always@(posedge clk or posedge rst)
        if(rst)
        begin
            ID_Instruction <= 32'h00000000;
            ID_PC <= 32'h00000000;
        end
        else if(IF_Flush)
        begin
            ID_Instruction <= 32'h00000000;
            ID_PC <= 32'h00000000;
        end
        else if(Stall)
        begin
            ID_Instruction <= ID_Instruction;
            ID_PC <= ID_PC;
        end
        else 
        begin
            ID_Instruction <= IF_Instruction;
            ID_PC <= IF_PC;
        end
endmodule