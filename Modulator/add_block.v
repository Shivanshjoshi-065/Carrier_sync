
module add_block(
	input signed [11:0] ip_data, 
	input signed [11:0] ip_data_2,
	input ip_clock, 
	input ip_reset,
	output signed [11:0] op_data
); 


	reg signed [11:0] reg_add; 
	wire signed [12:0] wire_add; 
	assign wire_add = ip_data + ip_data_2;
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'd0) begin 
			reg_add <= 12'sd0;
		end else begin 
			reg_add <= wire_add[12:1]; 
		end 
	end

	assign op_data = reg_add;
	
endmodule 
