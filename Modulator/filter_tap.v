
module filter_tap( 
	input signed [11:0] ip_data,  
	input signed [27:0] ip_data_2, 
	input signed [11:0] ip_coeff,
	input ip_clock, 
	input ip_reset, 
	output signed [27:0] op_data
);  
	
	
	reg signed [23:0] reg_op_product_3; 
	wire signed [23:0] wire_op_product_3; 
	assign wire_op_product_3 = ip_coeff * ip_data;
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'b0) begin 
			reg_op_product_3 <= 12'sd0; 
		end else begin 
			reg_op_product_3 <= wire_op_product_3;
		end 
	end  

	
	reg signed [27:0] reg_op_sum_3; 
	wire signed [27:0] wire_op_sum_3; 
	assign wire_op_sum_3 = reg_op_product_3 + ip_data_2;
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'b0) begin 
			reg_op_sum_3 <= 12'sd0; 
		end else begin 
			reg_op_sum_3 <= wire_op_sum_3;
		end 
	end  
	
	assign op_data = reg_op_sum_3; 
	
endmodule 
