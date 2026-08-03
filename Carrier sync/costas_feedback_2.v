module costas_feedback_2( 
	input signed [11:0] ip_data, 
	input ip_clock,
	input ip_reset, 
	output signed [11:0] op_data
); 

	// ------------------------------------  
	// 			Gain block approx				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_gain_approx;
	gain_block_approx gain_block_approx_inst( 
		.ip_data(ip_data), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_gain_approx)
	);  
	
	// ------------------------------------  
	// 			Loop gain				 	   
	// ------------------------------------ 
	wire signed [11:0] get_op_loop_gain; 
	loop_gain loop_gain_inst( 
		.ip_data(ip_data), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_loop_gain)
	);   
	
	
	// ------------------------------------  
	// 			Phase accumulator				 	   
	// ------------------------------------ 
	wire signed [11:0] get_op_phase_acc; 
	phase_accumulator phase_accumulator_inst( 
		.ip_data(get_op_loop_gain), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_phase_acc)
	);   

	// ----------------------------------  
	// 			Add block				 	   
	// ----------------------------------  
	wire signed [11:0] get_op_add; 
	add_block add_block_inst(
		 .ip_data(get_op_loop_gain), 
		 .ip_data_2(get_op_phase_acc), 
		 .ip_clock(ip_clock), 
		 .ip_reset(ip_reset), 
		 .op_data(get_op_add)
    );  	
	
	assign op_data = get_op_add; 
	/*
	always @(posedge ip_clock or negedge ip_reset) begin
		$display("Feedback: input=%0d loop_gain=%0d op_acc=%0d",
				 ip_data,
				 get_op_loop_gain,
				 get_op_phase_acc);
	end 
	*/

endmodule 