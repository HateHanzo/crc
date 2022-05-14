
module crc5_parallel(
  data_in      , 
  rst          , 
  clk          , 
  crc5_init    ,

  crc5    
);

parameter DLY = 1 ;

input  [3:0] data_in    ;
input  [4:0] crc5_init  ;
input        rst        ;
input        clk        ;

output [4:0] crc5       ;

reg [4:0] crc5    ;

//LFSR for USB CRC5
function [4:0] crc5_serial ;
  input [4:0] crc ;
	input       data;
	begin
		crc5_serial[0] = crc[4] ^ data          ;
		crc5_serial[1] = crc[0]                 ;
		crc5_serial[2] = crc[1] ^ crc[4] ^ data ;
		crc5_serial[3] = crc[2]                 ;
		crc5_serial[4] = crc[3]                 ;
	end
endfunction

//4 iterations of USB CRC5 LFSR
function [4:0] crc_iteration;
	input [4:0] crc ;
	input [3:0] data ;
	integer i;
  begin
		crc_iteration = crc ;
		for(i=0;i<4;i=i+1)
			crc_iteration = crc5_serial(crc_iteration,data[3-i]);
	end
endfunction

always@(posedge clk or posedge rst)
begin
	if(rst) begin
		crc5 <= #DLY crc5_init;
	end
	else begin
		crc5 <= #DLY crc_iteration(crc5,data_in) ;
	end
end


endmodule



