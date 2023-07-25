
module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output [2 -1:0] PCSrc    ,
	output Branch            ,
	output RegWrite          ,
	output [2 -1:0] RegDst   ,
	output MemRead           ,
	output MemWrite          ,
	output [2 -1:0] MemtoReg ,
	output ALUSrc1           ,
	output ALUSrc2           ,
	output ExtOp             ,
	output LuOp              ,
	//output WorngOP		     ,
	output [4 -1:0] ALUOp	 ,
	output [2 : 0] BranchType	
);
	
	// Add your code below (for question 2)

	// Your code below (for question 1)
	assign PCSrc = (OpCode==6'h04||OpCode==6'h05||OpCode==6'h06||OpCode==6'h07)? 3'b01: (OpCode==6'h02&&Funct==6'h03)? 3'b10:(OpCode==6'h00&&Funct==6'h08&&OpCode==6'h01)? 3'b11:3'b00;
	assign Branch = (OpCode == 6'h04||OpCode==6'h05||OpCode==6'h06||OpCode==6'h07)? 1'b1: 1'b0;
	assign RegWrite = (OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h00 || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c ||  OpCode == 6'h0b||OpCode==6'h03||OpCode==6'h01)? 1'b1: 1'b0;
	assign RegDst = (OpCode == 6'h23 || OpCode == 6'h0f||OpCode==6'h08 || OpCode == 6'h09 || OpCode == 6'h0c  || OpCode == 6'h0b)? 2'b01: (OpCode == 6'h00||OpCode==6'h01 )? 2'b00: 2'b10;
	assign MemRead = (OpCode == 6'h23)? 1'b1: 1'b0;
	assign MemWrite = (OpCode == 6'h2b)? 1'b1: 1'b0;
	assign MemtoReg = (OpCode == 6'h03 || OpCode == 6'h01)? 2'b10: (OpCode == 6'h23)? 2'b01: 2'b00;
	assign ALUSrc1 = ((OpCode==6'h00&&Funct==6'h00)||(OpCode==6'h00&&Funct==6'h02)||(OpCode==6'h00&&Funct==6'h03))? 1'b1: 1'b0;
	assign ALUSrc2 = (OpCode == 6'h00 || OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h0b)? 1'b0: 1'b1;
	assign ExtOp = (OpCode == 6'h0c)? 1'b0: 1'b1;
	assign LuOp = (OpCode == 6'h0f)? 1'b1: 1'b0;
	
	// Your code above (for question 1)

	// set ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101:
		(OpCode == 6'h1c)? 3'b110:
		3'b000;
		
	assign ALUOp[3] = OpCode[0];

	assign BranchType=(OpCode==6'h04)? 3'b000:(OpCode==6'h05)? 3'b001:(OpCode==6'h06)? 3'b010:(OpCode==6'h07)? 3'b011:3'b100;
	//assign WorngOP=
	// Add your code above (for question 2)
	
endmodule