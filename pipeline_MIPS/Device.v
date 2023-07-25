module Device(
	input  reset    , 
	input  clk      , 
	input  MemRead  , 
	input  MemWrite ,
	input  [32 -1:0] MemBus_Address     , 
	input  [32 -1:0] MemBus_Write_Data  , 
	output [32 -1:0] Device_Read_Data
);

	// device registers
	reg [31:0] reg_op;
	reg [31:0] reg_start;
	reg [31:0] reg_ans;

	// -------- Your code below (for question 3) --------
    parameter Op_Add = 32'h40000000;
    parameter St_Add = 32'h40000008;
    parameter Ans_Add = 32'h40000004;
	assign Device_Read_Data = (MemRead && MemBus_Address == Ans_Add)? reg_ans: 32'h00000000;



	reg [2:0]state=3'b000;
	reg [31:0] t;
	//integer i;
	//FSM
	parameter s0=3'b000;
	parameter s1=3'b001;
	parameter s2=3'b010;
	parameter s3=3'b011;
	parameter s4=3'b100;


	 always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            reg_start <= 32'h00000000;
            state     <= s0;
        end

        else if (MemWrite)
		begin
			if(MemBus_Address == Op_Add) reg_op <= MemBus_Write_Data;
			else if(MemBus_Address == St_Add) reg_start <= MemBus_Write_Data;
		end
    end

	always@(posedge clk )
	begin
			case(state)
				s0:begin
				if(reg_start)
				    begin
					  // reg_op<=MemBus_Write_Data;
					   t<=reg_op;
					   reg_ans<=32'h00000001;
					   state<=s1;
					end
				end
				s1:begin
					if(reg_start)
						begin
							reg_ans<=reg_ans+t;
							t<=t*reg_op;
							state<=s2;					
						end
					else
						state<=s0;
				end
				s2:begin
					if(reg_start)
						begin
							reg_ans<=reg_ans+t;
							t<=t*reg_op;
							state<=s3;
						end
					else
						state<=s0;
				end
				s3:begin
					if(reg_start)
						begin
							reg_ans<=reg_ans+t;
							t<=t*reg_op;
							state<=s4;
						end
					else
						state<=s0;
				end
				s4:begin
					if(reg_start)
						begin
							reg_ans<=reg_ans+t;
							reg_start<=32'h00000000;
							state<=s0;
						end
					else
						state<=s0;
				end
				default:state<=s0;
			endcase
	end
	// -------- Your code above (for question 3) --------

endmodule
