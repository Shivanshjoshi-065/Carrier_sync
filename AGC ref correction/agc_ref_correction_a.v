
module agc_ref_correction(
	input signed [11:0] ip_data, 
	input ip_clock,
	input ip_reset, 
	output signed [11:0] op_data
); 
	
	// ------------------------------------ // 
	// 			feedback regisers 				 	   
	// ------------------------------------ // 
	wire signed [11:0] get_op_acc;  
	
	
	// ------------------------------------  
	// 			Product block 				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_product; 
	product_block product_block_inst( 
		.ip_data(ip_data), 
		.ip_data_2(get_op_acc),
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_product)
	);
	
	
	// ------------------------------------  
	// 			Abs block 				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_abs; 
	abs_block abs_block_inst(
		.ip_data(get_op_product), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_abs)
	); 
	
	// ------------------------------------  
	// 			Power estimation 				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_power_est; 
	power_estimation power_estimation_inst( 
		.ip_data(get_op_abs), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_power_est)
	); 
	
	// ------------------------------------  
	// 			Gain error  				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_error; 
	gain_error gain_error_inst( 
		.ip_data(get_op_power_est), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_error)
	);
	
	// ------------------------------------  
	// 			Loop gain  				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_loop_gain; 
	loop_gain_a loop_gain_a_inst( 
		.ip_data(get_op_error), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_loop_gain)
	);  
	
	// ------------------------------------  
	// 			Accumulator 				 	   
	// ------------------------------------  
	// wire signed [11:0] get_op_acc;  
	accumulator accumulator_inst(
		.ip_data(get_op_loop_gain), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_acc)
	);
	
	 
	assign op_data = get_op_product; 
	
	always @(posedge ip_clock or negedge ip_reset) begin
		$display("AGC: in1=%0d abs=%0d power_est=%0d error=%0d acc=%0d product=%0d",
				 ip_data,
				 get_op_abs, 
				 get_op_power_est, 
				 get_op_error,
				 get_op_acc, 
				 get_op_product);
	end 
	
	
endmodule 
