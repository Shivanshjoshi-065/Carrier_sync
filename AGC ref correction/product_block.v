
module product_block(
	input signed [11:0] ip_data, 
	input signed [11:0] ip_data_2,
	input ip_clock, 
	input ip_reset,
	output signed [11:0] op_data
); 

	
	reg signed [11:0] reg_product; 
	wire signed [23:0] wire_product; 
	assign wire_product = ip_data * ip_data_2; 
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'b0) begin 
			reg_product <= 12'sd0;
		end else begin 
			reg_product <= wire_product[22:11]; 
		end 
	end

	assign op_data = reg_product;
	
endmodule 
