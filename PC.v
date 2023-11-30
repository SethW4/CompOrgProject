// 4-bit up/down counter
module PC(input clk, input enable, input[31:0] value, output reg [31:0] totalCount);
   

	
	always @ (posedge clk) begin

	if(enable == 1)
		
		// Reset once it hits 2^32, give or take
		if(totalCount == 4294967000) totalCount = 0;
		else totalCount = totalCount + value;
		
	end
	

endmodule  