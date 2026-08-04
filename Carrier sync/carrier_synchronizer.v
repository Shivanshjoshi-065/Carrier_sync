module carrier_synchronizer( 
	input signed [11:0] ip_data, 
	input ip_clock, 
	input ip_reset, 
	output signed [11:0] op_real, 
	output signed [11:0] op_imag
); 

	// ------------------------------------ // 
	// 			feedback regisers 				 	   
	// ------------------------------------ // 
	wire signed [11:0] get_op_cosine_wave; 
	wire signed [11:0] get_op_sine_wave;
	
	
	// ------------------------------------ // 
	// 			Costas loop				 	   
	// ------------------------------------ // 
	wire signed [11:0] get_op_costas_err; 
	wire signed [11:0] get_op_data_i; 
	wire signed [11:0] get_op_data_q;  
	 
	costas_loop costas_loop_inst( 
		.ip_unsync(ip_data), 
		.ip_cosine(get_op_cosine_wave), 
		.ip_sine(get_op_sine_wave), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_costas_err(get_op_costas_err), 
		.op_data_i(get_op_data_i), 
		.op_data_q(get_op_data_q)
	); 

	// ------------------------------------  
	// 			Costas feedback 2				 	   
	// ------------------------------------ 
	wire signed [11:0] get_op_feedback; 
	costas_feedback_2 costas_feedback_2_inst( 
		.ip_data(get_op_costas_err), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_feedback)
	);   
	
	// ------------------------------------ 
	// 			Nco block				 	   
	// ------------------------------------ 
	
	nco_block_2 nco_block_2_inst( 
		.ip_data(get_op_feedback), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_cosine_wave(get_op_cosine_wave), 
		.op_sine_wave(get_op_sine_wave)
	);
	
	
	assign op_real = get_op_data_i; 
	assign op_imag = get_op_data_q;

endmodule 
