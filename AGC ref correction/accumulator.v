
module accumulator( 
	input signed [11:0] ip_data, 
	input ip_clock, 
	input ip_reset, 
	output signed [11:0] op_data
);  
	
	reg signed [15:0] reg_sum; 
	reg [4:0] reg_counter; 
	// wire signed [15:0] wire_sum; 
	
	always@(posedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'b0) begin 
			reg_sum <= 16'sd0; 
			reg_counter <= 5'd0;
		end else begin 
			if(reg_counter == 5'd31) begin 
				  if(reg_sum > 16'sd32767) begin 
					reg_sum <= 16'sd32767;
				  end else if (reg_sum < -16'sd32767) begin 
					reg_sum <= -16'sd32767;
				  end else begin 
					reg_sum <= 16'sd0; 
				  end 
			end else begin 
				reg_sum <= reg_sum + ip_data; 
			end 
			reg_counter <= reg_counter + 5'd1;
		end 
	end 

	assign op_data = reg_sum[15:4]; 
	
	
endmodule 
