module clk_gen(
    clk, 
    reset, 
    clk_50M
);

input           clk;
input           reset;
output          clk_50M;

reg             clk_50M;

parameter   CNT = 16'd50000;

reg     [15:0]  count;

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        clk_50M <= 1'b0;
        count <= 16'd0;
    end
    else begin
        count <= (count==CNT-16'd1) ? 16'd0 : count + 16'd1;
        clk_50M <= (count==16'd0) ? ~clk_50M : clk_50M;
    end
end

endmodule
