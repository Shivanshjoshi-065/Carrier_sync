
module phase_accumulator( 
	input signed [11:0] ip_data, 
	input ip_clock, 
	input ip_reset, 
	output signed [11:0] op_data
);  
	
	parameter signed [15:0] constant = 16'd8192;
	reg signed [15:0] reg_sum; 
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'd0) begin 
			reg_sum <= 16'd0; 
		end else begin 
			reg_sum <= reg_sum + ip_data + constant; 
		end 
	end 

	assign op_data = reg_sum[15:4]; 
	/*
	always @(negedge ip_clock or negedge ip_reset) begin
		$display("Phase_ACC: in=%0d count=%0d sum=%0d",
				 ip_data,
				 reg_counter,
				 op_data);
	end 
	*/
	
	
endmodule 