module test_cpu();
	
	reg reset   ;
	reg clk     ;
	wire [6:0] leds;
	wire [3:0] ano;
	CPU cpu1(  
		.reset(reset), 
		.sysclk(clk), 
		.ano(ano),
		.leds(leds)
	);
	
	initial begin
		reset   = 1;
		clk     = 1;
		#100 reset = 0;
	end
	
	always #50 clk = ~clk;
		
endmodule
