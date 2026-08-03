
module gain_block_approx( 
	input [11:0] ip_data, 
	input ip_clock, 
	input ip_reset, 
	output [11:0] op_data
); 

	parameter signed [15:0] gain = 16'sd65535;
	
	reg signed [11:0] reg_gain;
	wire signed [26:0] wire_gain; 
	assign wire_gain = ip_data * gain;
	always@(negedge ip_clock or negedge ip_reset) begin 
		if(ip_reset == 1'd0) begin 
			reg_gain <= 12'd0;
		end else begin 
			reg_gain <= wire_gain[24:12]; 
		end 
	end 
	
	assign op_data = reg_gain; 
	
endmodule 