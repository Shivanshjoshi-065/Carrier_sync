
module filter_tap_1( 
	input signed [11:0] ip_data, 
	input signed [11:0] ip_coeff,
	input ip_clock, 
	input ip_reset, 
	output signed [23:0] op_data
);  
	
	
	reg signed [23:0] reg_op_product; 
	wire signed [23:0] wire_op_product; 
	assign wire_op_product = ip_coeff * ip_data;
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'b0) begin 
			reg_op_product <= 12'sd0; 
		end else begin 
			reg_op_product <= wire_op_product;
		end 
	end  
	
	assign op_data = reg_op_product;
	
endmodule 
