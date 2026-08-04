module carrier_synchronizer_tb(); 
	reg sys_clock; 
	reg sys_reset; 
	reg sys_enable; 
	
	wire signed [11:0] op_carrier_real;
	wire signed [11:0] op_carrier_imag;

	
	// ------------------------------------  
	// 			Reset signal 				 	   
	// ------------------------------------   
	initial begin
		sys_reset = 1'b0;
		# 100;
		sys_reset = 1'b1;
	end  
	
	// ------------------------------------  
	// 			Enable signal 				 	   
	// ------------------------------------ 
	initial begin 
		sys_enable = 1'b1;
	end 
	
	// ---------------------------------------  
	// 			Clock generation 				 	   
	// ---------------------------------------   
	parameter real clock_period = 15.625; // 64 MHz 
	
	always begin 
		sys_clock = 1'b0; 
		# (clock_period / 2); 
		sys_clock = 1'b1; 
		# (clock_period / 2); 
	end 
	

	// -------------------------------------------------------  
	// 			Instantiate module : Modulator 				 	   
	// ------------------------------------------------------  
	
	wire signed [11:0] get_op_if; 
	
	modulator modulator_uut_a( 
		.ip_clock(sys_clock), 
		.ip_reset(sys_reset),
		.ip_enable(sys_enable),
		.op_if(get_op_if)
	); 
	
	// -------------------------------------------------------  
	// 			Instantiate module : AGC ref correction 				 	   
	// ------------------------------------------------------ 
	
	wire signed [11:0] get_op_agc; 
	
	agc_ref_correction agc_ref_correction_uut_b (
		 .ip_data(get_op_if), 
		 .ip_clock(sys_clock), 
		 .ip_reset(sys_reset), 
		 .op_data(get_op_agc)
    );
	

	// ---------------------------------------------------------  
	// 			Instantiate module : carrier synchronizer 				 	   
	// ---------------------------------------------------------  
	wire signed [11:0] get_op_carrier_real;
	wire signed [11:0] get_op_carrier_imag;

	carrier_synchronizer carrier_synchronizer_uut_c( 
		.ip_data(get_op_agc), 
		.ip_clock(sys_clock), 
		.ip_reset(sys_reset), 
		.op_real(get_op_carrier_real), 
		.op_imag(get_op_carrier_imag)
	);

	assign op_carrier_real = get_op_carrier_real; 
	assign op_carrier_imag = get_op_carrier_imag;
	
endmodule
