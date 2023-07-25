module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
	reg [31:0] BCD7;
	// read data from RAM_data as Read_data
	assign Read_data = {~MemRead}? 32'h00000000:
	                   {Address==32'h40000010}? BCD7:RAM_data[Address[RAM_SIZE_BIT + 1:2]];
	// write Write_data to RAM_data at clock posedge
	integer i;
	initial RAM_data[0]=32'h756e696c;
	initial RAM_data[1]=32'h73692078;
	initial RAM_data[2]=32'h746f6e20;
	initial RAM_data[3]=32'h696e7520;
	initial RAM_data[4]=32'h73692078;
	initial RAM_data[5]=32'h746f6e20;
	initial RAM_data[6]=32'h696e7520;
	initial RAM_data[7]=32'h73692078;
	initial RAM_data[8]=32'h746f6e20;
	initial RAM_data[9]=32'h696e7520;
	initial RAM_data[10]=32'h00000a78;
	initial RAM_data[32]=32'h78696e75;
	initial RAM_data[33]=32'h0000000a;
	initial BCD7={20'h00000,12'hFFF};
	always @(posedge reset or posedge clk)
	if (reset)begin
			RAM_data[0]<=32'h756e696c;
	        RAM_data[1]<=32'h73692078;
	        RAM_data[2]<=32'h746f6e20;
	        RAM_data[3]<=32'h696e7520;
	        RAM_data[4]<=32'h73692078;
	        RAM_data[5]<=32'h746f6e20;
	        RAM_data[6]<=32'h696e7520;
	        RAM_data[7]<=32'h73692078;
	        RAM_data[8]<=32'h746f6e20;
	        RAM_data[9]<=32'h696e7520;
	        RAM_data[10]<=32'h00000a78;
	        BCD7<=32'h00000FFF;
			for (i = 11; i < RAM_SIZE; i = i + 1) begin
				if(i==32) RAM_data[i]<=32'h78696e75;
				else if(i==33) RAM_data[i]<=32'h0000000a;
				else RAM_data[i] <= 32'h00000000;
			end
		end
		else if (MemWrite)begin
			if(Address==32'h40000010) BCD7<= Write_data;
			else RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
			
endmodule
