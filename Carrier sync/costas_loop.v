module costas_loop( 
	input signed [11:0] ip_unsync, 
	input signed [11:0] ip_cosine, 
	input signed [11:0] ip_sine, 
	input ip_clock, 
	input ip_reset, 
	output signed [11:0] op_costas_err,
	output signed [11:0] op_data_i, 
	output signed [11:0] op_data_q
); 

	// ------------------------------------  
	// 			Product block i 				 	   
	// ------------------------------------ 
	wire signed [11:0] get_op_product_i; 
	product_block product_block_i_inst( 
		.ip_data(ip_cosine), 
		.ip_data_2(ip_unsync),
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_product_i)
	);   
	
	// ------------------------------------  
	// 			Product block q 				 	   
	// ------------------------------------ 
	wire signed [11:0] get_op_product_q; 
	product_block product_block_q_inst( 
		.ip_data(ip_sine), 
		.ip_data_2(ip_unsync),
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_product_q)
	);  
	
	// ------------------------------------  
	// 			lowpass filter i  				 	   
	// ------------------------------------  
	
	wire signed [27:0] get_op_lowpass_i; 
	reg signed [11:0] reg_op_lowpass_i;
	always@(posedge ip_clock or negedge ip_reset) begin  
		if(ip_reset == 1'd0) begin  
			reg_op_lowpass_i <= 12'sd0;
		end else begin 
			reg_op_lowpass_i <= get_op_lowpass_i[22:11];
		end 
	end 
	lowpass_filter lowpass_filter_i_inst (
		 .ip_data(get_op_product_i), 
		 .ip_clock(ip_clock), 
		 .ip_reset(ip_reset), 
		 .op_data(get_op_lowpass_i)
    );  
	 
	// ------------------------------------  
	// 			lowpass filter q  				 	   
	// ------------------------------------ 
	
	wire signed [27:0] get_op_lowpass_q;
	reg signed [11:0] reg_op_lowpass_q;
	always@(posedge ip_clock or negedge ip_reset) begin  
		if(ip_reset == 1'd0) begin  
			reg_op_lowpass_q <= 12'sd0;
		end else begin 
			reg_op_lowpass_q <= get_op_lowpass_q[22:11];
		end 
	end 
	lowpass_filter lowpass_filter_q_inst (
		 .ip_data(get_op_product_q), 
		 .ip_clock(ip_clock), 
		 .ip_reset(ip_reset), 
		 .op_data(get_op_lowpass_q)
    ); 
	 
	
	// ------------------------------------  
	// 			Product block 2				 	   
	// ------------------------------------  
	wire signed [11:0] get_op_product_2; 
	product_block product_block_2_inst( 
		.ip_data(reg_op_lowpass_i), 
		.ip_data_2(reg_op_lowpass_q),
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_product_2)
	);   
	
	// ------------------------------------  
	// 			Loop gain				 	   
	// ------------------------------------
	wire signed [11:0] get_op_loop_gain; 
	loop_gain_a loop_gain_a_inst( 
		.ip_data(get_op_product_2), 
		.ip_clock(ip_clock), 
		.ip_reset(ip_reset), 
		.op_data(get_op_loop_gain)
	);  
	// ------------------------------------  
	// 			lowpass filter lf  				 	   
	// ------------------------------------  
	wire signed [27:0] get_op_lowpass_lf; 
	reg signed [11:0] reg_op_lowpass_lf;
	always@(posedge ip_clock or negedge ip_reset) begin  
		if(ip_reset == 1'd0) begin  
			reg_op_lowpass_lf <= 12'sd0;
		end else begin 
			reg_op_lowpass_lf <= get_op_lowpass_lf[22:11];
		end 
	end 
	lowpass_filter lowpass_filter_lf_inst (
		 .ip_data(get_op_loop_gain), 
		 .ip_clock(ip_clock), 
		 .ip_reset(ip_reset), 
		 .op_data(get_op_lowpass_lf)
    ); 
	
	
	assign op_data_i = reg_op_lowpass_i; 
	assign op_data_q = reg_op_lowpass_q; 
	assign op_costas_err = reg_op_lowpass_lf; 

endmodule 
