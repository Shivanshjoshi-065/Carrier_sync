
module loop_gain( 
	input signed [11:0] ip_data, 
	input ip_clock, 
	input ip_reset, 
	output signed [11:0] op_data
); 
	
	reg signed [11:0] reg_gain;
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'd0) begin 
			reg_gain <= 12'd0;
		end else begin 
			reg_gain <= ip_data >>> 5; 
		end 
	end 
	
	assign op_data = reg_gain; 

endmodule 