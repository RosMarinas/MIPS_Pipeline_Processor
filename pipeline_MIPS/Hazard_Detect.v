module Hazard_Detect(
    input ID_EX_MemRead,
    input [4:0] IF_ID_Rs,
    input [4:0] IF_ID_Rt,
    input [4:0] ID_EX_Rt,
    input EX_zero,
    input EX_Branch,
    input [5:0]OPCode,
    input [5:0]ID_Function,
    output load_use_hazard_stall,
    output branch_hazard_flush,
    output jump_flush
);
    assign load_use_hazard_stall = (ID_EX_MemRead && ((IF_ID_Rs == ID_EX_Rt) || (IF_ID_Rt == ID_EX_Rt)))?1'b1:1'b0;
    assign branch_hazard_flush = (EX_zero==1&&EX_Branch==1)?1'b1:1'b0;
    assign jump_flush = {((OPCode==6'h00) && (ID_Function==6'h08 || ID_Function==6'h09)) || OPCode==6'h02 || OPCode==6'h03}? 1'b1:1'b0;
endmodule
