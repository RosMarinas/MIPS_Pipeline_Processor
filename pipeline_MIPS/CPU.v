module CPU(reset,sysclk,ano,leds);
	input reset,sysclk;
	output [3:0] ano;
	output [6:0] leds;
	wire [31:0] IF_instruction;
	wire [31:0] ID_instruction;
	wire [31:0] PC_i;
	wire [31:0] PC_o;
	wire [31:0] IF_PC;
	wire [31:0] ID_PC;

	wire [1:0] ID_PC_Src;
	wire ID_Branch;
	wire ID_Reg_Write;
	wire [1:0] ID_Reg_Dst;
	wire ID_Mem_Read;
	wire ID_Mem_Write;
	wire [1:0] ID_Mem_To_Reg;
	wire ID_ALU_Src1;
	wire ID_ALU_Src2;
	wire ID_Ext_Op;
	wire ID_Lu_Op;

	wire [31:0] PCjump;
	wire [31:0] EX_PC;
	wire [31:0] ID_PC_Address;
	wire [31:0] EX_PC_Address;
	wire [1:0] EX_PC_Src;
	wire [31:0] ID_Imm;
	wire [31:0] ID_Read_Data1;
	wire [31:0] ID_Read_Data2;
	wire [4:0] ID_ALU_Ctl;
	wire [3:0] ID_ALU_Op;
	wire [2:0] ID_Branch_Type;
	wire ID_Sign;

	wire [4:0] EX_Rs;
	wire [4:0] EX_Rt;
	wire [4:0] EX_Rd;
	wire [4:0] EX_Shamt;
	wire [31:0] EX_Imm;
	wire [31:0] EX_Read_Data1;
	wire [31:0] EX_Read_Data2;
	wire [5:0] EX_OP_Code;
	wire EX_ALU_Src1;
	wire EX_ALU_Src2;
	wire [1:0] EX_Reg_Dst;
	wire EX_Mem_Write;//
	wire EX_Branch;//
	wire EX_Mem_Read;//
	wire [1:0] EX_Mem_To_Reg;//
	wire EX_Reg_Write;//
	wire EX_Sign;//
	wire [4:0] EX_ALU_Op;//这里实际上是EX_ALU_Ctl
	wire EX_Lu_Op;//

	wire [31:0] MEM_PC;//
	wire [31:0] MEM_ALUOut;
	wire [4:0] EX_Write_Address;//
	wire [31:0] ALU_Out;//
	wire [31:0] EX_ALU_Out;//
	wire EX_zero;//
	wire [4:0] MEM_Rs;//
	wire [4:0] MEM_Rt;//
	//wire [4:0] MEM_Rd;
	wire MEM_Mem_Write;//
	wire [1:0] MEM_Mem_To_Reg;//
	wire MEM_Reg_Write;//
	wire [4:0] MEM_Write_Address;//
	wire MEM_Mem_Read;//
	wire [31:0] MEM_ALU_Out;//
	wire [31:0] MEM_Read_Data_2;//

	wire [31:0] WB_PC;
	wire [1:0]WB_Mem_To_Reg;
	wire WB_Reg_Write;
	wire [4:0] WB_Write_Address;
	wire [31:0] WB_ALU_Out;
	wire [31:0] WB_Read_Data;

	wire [31:0] Reg_Write_Data;
	wire [1:0] Forwarding1;
	wire [1:0] Forwarding2;
	wire Forwarding3;

	wire [31:0] PC_Reg;//

	wire [31:0] in1;//
	wire [31:0] in2;//
	wire [31:0] EX_in1;//
	wire [31:0] EX_in2;//

	wire [31:0] mem_Read_Data;//
	wire [31:0] MEM_mem_Read_Data;

	wire Load_Use_Hazard_Stall;
	wire Branch_Hazard_Flush;
	wire Jump_Flush;

	wire [31:0] Refresh_ID_Read_Data1;
	wire [31:0] Refresh_ID_Read_Data2;
	wire [31:0] Refresh_EX_Read_Data;

	wire clk;//
	wire [15:0] ans;//
	wire [6:0] bcd_out1;
	wire [6:0] bcd_out2;
	wire [6:0] bcd_out3;
	wire [6:0] bcd_out4;
	clk_gen clk_gen1(
		.clk(sysclk),
		.reset(reset),
		.clk_50M(clk)
	);
	assign ans=RegisterFile_test.RF_data[2][15:0];
	assign leds=DataMemory_test.BCD7[6:0];
	assign ano=DataMemory_test.BCD7[11:8];
	BCD7 BCD71(
		.in(ans[15:12]),
		.out(bcd_out1)
	);
	BCD7 BCD72(
		.in(ans[11:8]),
		.out(bcd_out2)
	);
	BCD7 BCD73(
		.in(ans[7:4]),
		.out(bcd_out3)
	);
	BCD7 BCD74(
		.in(ans[3:0]),
		.out(bcd_out4)
	);
	assign IF_PC=PC_o+32'h4;
	assign PC_i=(EX_PC_Src==2'b01&& EX_zero==1'b1&&EX_Branch==1'b1)?EX_PC_Address:
	(ID_PC_Src==2'b10)?PCjump:
	(ID_PC_Src==2'b11)?PC_Reg:
	(Load_Use_Hazard_Stall==1'b1)?PC_o:IF_PC;
	//assign IF_PC=PC_o+32'h4;
	PC PC_Counter(
		.clk(clk),
		.reset(reset),
		.PC_i(PC_i),
		.PC_o(PC_o)
	);
	InstructionMemory InstructionMemory_test(
		.Address(PC_o),
		.Instruction(IF_instruction)
	);
	IF_ID IF_ID_test(
		.clk(clk),
		.rst(reset),
		.Stall(Load_Use_Hazard_Stall),
		.IF_Flush(Jump_Flush||Branch_Hazard_Flush),
		.IF_PC(IF_PC),
		.IF_Instruction(IF_instruction),
		.ID_PC(ID_PC),
		.ID_Instruction(ID_instruction)
	);
	
	
	Control Control_test(
		.OpCode(ID_instruction[31:26]),
		.Funct(ID_instruction[5:0]),
		.PCSrc(ID_PC_Src),
		.Branch(ID_Branch),
		.RegWrite(ID_Reg_Write),
		.RegDst(ID_Reg_Dst),
		.MemRead(ID_Mem_Read),
		.MemWrite(ID_Mem_Write),
		.MemtoReg(ID_Mem_To_Reg),
		.ALUSrc1(ID_ALU_Src1),
		.ALUSrc2(ID_ALU_Src2),
		.ExtOp(ID_Ext_Op),
		.LuOp(ID_Lu_Op),
		.ALUOp(ID_ALU_Op),
		.BranchType(ID_Branch_Type)
	);
	ID_EX ID_EX_test(
		.clk(clk),
		.rst(reset),
		.ID_Flush(Load_Use_Hazard_Stall||Branch_Hazard_Flush),
		.ID_ReadData_1(Refresh_ID_Read_Data1),
		.ID_ReadData_2(Refresh_ID_Read_Data2),
		.ID_Sign(ID_Sign),
		.ID_PC(ID_PC),
		.ID_PC_address(ID_PC_Address),
		.ID_PCSrc(ID_PC_Src),
		.ID_Rs(ID_instruction[25:21]),
		.ID_Rt(ID_instruction[20:16]),
		.ID_Rd(ID_instruction[15:11]),
		.ID_Shamt(ID_instruction[10:6]),
		.ID_Imm(ID_Imm),
		.ID_OPCode(ID_instruction[31:26]),
		.ID_ALUSrc_1(ID_ALU_Src1),
		.ID_ALUSrc_2(ID_ALU_Src2),
		.ID_RegDst(ID_Reg_Dst),
		.ID_MemWrite(ID_Mem_Write),
		.ID_Branch(ID_Branch),
		.ID_MemRead(ID_Mem_Read),
		.ID_MemtoReg(ID_Mem_To_Reg),
		.ID_RegWrite(ID_Reg_Write),
		.ID_ALUCtl(ID_ALU_Ctl),
		.ID_LuOp(ID_Lu_Op),

		.EX_PC(EX_PC),
		.EX_PC_address(EX_PC_Address),
		.EX_Imm(EX_Imm),
		.EX_ReadData_1(EX_Read_Data1),
		.EX_ReadData_2(EX_Read_Data2),
		.EX_PCSrc(EX_PC_Src),
		.EX_OPCode(EX_OP_Code),
		.EX_Rs(EX_Rs),
		.EX_Rt(EX_Rt),
		.EX_Rd(EX_Rd),
		.EX_Shamt(EX_Shamt),
		.EX_ALUSrc_1(EX_ALU_Src1),
		.EX_ALUSrc_2(EX_ALU_Src2),
		.EX_MemWrite(EX_Mem_Write),
		.EX_MemRead(EX_Mem_Read),
		.EX_Branch(EX_Branch),
		.EX_Sign(EX_Sign),
		.EX_RegWrite(EX_Reg_Write),
		.EX_LuOp(EX_Lu_Op),
		.EX_RegDst(EX_Reg_Dst),
		.EX_MemtoReg(EX_Mem_To_Reg),
		.EX_ALUCtl(EX_ALU_Op)
	);
	ImmProcess ImmProcess_test(
		.ExtOp(ID_Ext_Op),
		.LuiOp(ID_Lu_Op),
		.Immediate(ID_instruction[15:0]),
		.ImmExtOut(ID_Imm)
	);
	RegisterFile RegisterFile_test(
		.clk(clk),
		.reset(reset),
		.RegWrite(ID_Reg_Write),
		.Read_register1(ID_instruction[25:21]),
		.Read_register2(ID_instruction[20:16]),
		.Write_register(WB_Write_Address),
		.Write_data(Reg_Write_Data),
		.Read_data1(ID_Read_Data1),
		.Read_data2(ID_Read_Data2)
	);
	ALUControl ALUControl_test(
		.ALUOp(ID_ALU_Op),
		.Funct(ID_instruction[5:0]),
		.ALUCtl(ID_ALU_Ctl),
		.Sign(ID_Sign)
	);
	assign PCjump={ID_PC[31:28],ID_instruction[25:0],2'b00};
	assign ID_PC_Address=ID_PC+(ID_instruction[15:0]<<2);
	assign PC_Reg={Forwarding3==1'b1}?EX_PC:Refresh_ID_Read_Data1;
	assign Refresh_ID_Read_Data1=(WB_Reg_Write&&WB_Write_Address!=0&&WB_Write_Address==ID_instruction[25:21])?Reg_Write_Data:ID_Read_Data1;
	assign Refresh_ID_Read_Data2=(WB_Reg_Write&&WB_Write_Address!=0&&WB_Write_Address==ID_instruction[20:16])?Reg_Write_Data:ID_Read_Data2;

	ALU ALU_test(
		.in1(EX_in1),
		.in2(EX_in2),
		.ALUCtl(EX_ALU_Op),
		.Sign(EX_Sign),
		.out(ALU_Out),
		.zero(EX_zero)
	);

	EX_MEM EX_MEM_test(
		.clk(clk),
		.rst(reset),
		.EX_PC(EX_PC),
		.EX_ALUOut(EX_ALU_Out),
		.EX_ReadData_2(Refresh_EX_Read_Data),
		.EX_Rs(EX_Rs),
		.EX_Rt(EX_Rt),
		//.EX_Rd(EX_Rd),
		.EX_Write_Address(EX_Write_Address),
		.EX_MemtoReg(EX_Mem_To_Reg),
		.EX_MemWrite(EX_Mem_Write),
		.EX_MemRead(EX_Mem_Read),
		.EX_RegWrite(EX_Reg_Write),
	
		.MEM_PC(MEM_PC),
		.MEM_ALUOut(MEM_ALU_Out),
		.MEM_ReadData_2(MEM_Read_Data_2),
		.MEM_Rs(MEM_Rs),
		.MEM_Rt(MEM_Rt),
		//.MEM_Rd(MEM_Rd),
		.MEM_Write_Address(MEM_Write_Address),
		.MEM_MemtoReg(MEM_Mem_To_Reg),
		.MEM_MemWrite(MEM_Mem_Write),
		.MEM_MemRead(MEM_Mem_Read),
		.MEM_RegWrite(MEM_Reg_Write)
	);
	assign EX_Write_Address={EX_Reg_Dst==2'b00}?EX_Rd:{EX_Reg_Dst==2'b01}?EX_Rt:5'b11111;
	assign in1={EX_ALU_Src1==1'b0}?EX_Read_Data1:EX_Shamt;
	assign in2={EX_ALU_Src2==1'b0}?EX_Read_Data2:EX_Imm;
	assign EX_in1={Forwarding1==2'b10}?MEM_ALU_Out:{Forwarding1==2'b01}?Reg_Write_Data:in1;
	assign EX_in2={Forwarding2==2'b10}?MEM_ALU_Out:{Forwarding2==2'b01}?Reg_Write_Data:in2;
	assign EX_ALU_Out={EX_Lu_Op==1'b0}?ALU_Out:EX_Imm;
	assign Refresh_EX_Read_Data=(MEM_Reg_Write&&MEM_Write_Address!=0&&MEM_Write_Address==EX_Rt&&EX_OP_Code==6'h2b)?MEM_ALU_Out:(MEM_Reg_Write&&MEM_Write_Address!=0&&MEM_Write_Address==EX_Rt&&EX_OP_Code==6'h2b)?Reg_Write_Data:EX_Read_Data2;


	
DataMemory DataMemory_test(
	.clk(clk),
	.reset(reset),
	.MemWrite(MEM_Mem_Write),
	.MemRead(MEM_Mem_Read),
	.Address(MEM_ALU_Out),
	.Write_data(MEM_Read_Data_2),
	.Read_data(mem_Read_Data)
);

	MEM_WB MEM_WB_test(
		.clk(clk),
		.rst(reset),
		.MEM_PC(MEM_PC),
		.MEM_ALU_Out(MEM_ALU_Out),
		.MEM_Read_Data(MEM_mem_Read_Data),
		.MEM_MemtoReg(MEM_Mem_To_Reg),
		.MEM_Write_Address(MEM_Write_Address),
		.MEM_RegWrite(MEM_Reg_Write),

		.WB_PC(WB_PC),
		.WB_ALU_Out(WB_ALU_Out),
		.WB_Read_Data(WB_Read_Data),
		.WB_MemtoReg(WB_Mem_To_Reg),
		.WB_Write_Address(WB_Write_Address),
		.WB_RegWrite(WB_Reg_Write)
	);
	
	assign MEM_mem_Read_Data={MEM_ALU_Out[1:0]==2'b00}?{24'b0,mem_Read_Data[7:0]}:
	{MEM_ALU_Out[1:0]==2'b01}?{24'b0,mem_Read_Data[15:8]}:
	{MEM_ALU_Out[1:0]==2'b10}?{24'b0,mem_Read_Data[23:16]}:
	{24'b0,mem_Read_Data[31:24]};
	assign Reg_Write_Data={WB_Mem_To_Reg==2'b00}?WB_Read_Data:WB_PC;

	Forwarding Forwarding_test(
		.EX_MEM_RegWrite(MEM_Reg_Write),
		.MEM_WB_RegWrite(						),
		.EX_MEM_Write_Address(MEM_Write_Address),
		.MEM_WB_Write_Address(WB_Write_Address),
		.ID_EX_Rs(EX_Rs),
		.ID_EX_Rt(EX_Rt),
		.IF_ID_Rs(ID_instruction[25:21]),
		.IF_ID_Opcode(ID_instruction[31:26]),
		.IF_ID_Function(ID_instruction[5:0]),
		.ID_EX_Opcode(EX_OP_Code),
		.Forward_EXMEM_EX(Forwarding1),
		.Forward_MEMWB_EX(Forwarding2),
		.Forward_EXMEM_ID(Forwarding3)
	);
	Hazard_Detect Hazard_Detect_test(
		.ID_EX_MemRead(EX_Mem_Read),
		.IF_ID_Rs(ID_instruction[25:21]),
		.IF_ID_Rt(ID_instruction[20:16]),
		.ID_EX_Rt(EX_Rt),
		.EX_zero(EX_zero),
		.EX_Branch(EX_Branch),
		.OPCode(EX_OP_Code),
		.ID_Function(ID_instruction[5:0]),
		.load_use_hazard_stall(Load_Use_Hazard_Stall),
		.branch_hazard_flush(Branch_Hazard_Flush),
		.jump_flush(Jump_Flush)
	);
endmodule
