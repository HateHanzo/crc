

`timescale 1ns/10ps
module sim_tb();

parameter DLY      = 1    ;
parameter CLK_HP_A = 62.5  ;

reg rst_n ;
reg clka  ;
reg en    ;
reg [3:0] data_in   ;
reg [4:0] crc5_init ;
reg [4:0] cnt ;
reg       cnt_en ;
wire      H1 ;
wire      H2 ;

crc5_parallel crc5_parallel(
  .rst_n    (rst_n    ),
  .clk      (clka     ),  
  .data_in  (data_in   ),
  .crc5_init(crc5_init ),
  .crc5     (),  
)

always # CLK_HP_A clka = ~clka ;

task HMatrix(input [3:0] data,input [4:0] init)
begin
crc5_init = init ;
@(posedge clka)
     rst_n = 0 ;
#40  rst_n = 1 ;
#40  rst_n = 0 ;
     data_in = data ;
end
endtask

assign H1 = (cnt >= 5'd1 ) && (cnt <= 5'd5 ) ;
assign H2 = (cnt >= 5'd10) && (cnt <= 5'd14) ;

//test pat
always@(posedge clka)
begin
  cnt = cnt_en ? cnt + 5'd1 : cnt ;
end

initial begin
  clka  = 0 ;
  rst_n = 0 ;
  cnt   = 0 ;
  cnt_en = 0 ;
  #1000
  cnt_en = 1 ;
  
  //H1
  HMatrix(4'h01,5'h00);
  HMatrix(4'h02,5'h00);
  HMatrix(4'h04,5'h00);
  HMatrix(4'h08,5'h00);
  
  #500
  
  //H2
  HMatrix(4'h00,5'h01);
  HMatrix(4'h00,5'h02);
  HMatrix(4'h00,5'h04);
  HMatrix(4'h00,5'h08);
  HMatrix(4'h00,5'h10);
  
  #20000;
  $finish ;
end

initial begin
  $fsdbDumpfile("wave.fsdb");
  $fsdbDumpvars ;
end

endmodule





