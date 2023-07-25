module PC(
    clk,reset,PC_i,PC_o
);
    input clk,reset;
    input [31:0] PC_i;
    output reg [31:0] PC_o=0;
    always @(posedge clk or posedge reset) begin
        if(reset) PC_o<=32'b0;
        else PC_o<=PC_i;
    end
endmodule