`include "memory.v"
module memory_tb();
parameter DEPTH = 1024;
parameter WIDTH = 32; 
parameter ADDR_WIDTH = $clog2(DEPTH); 
reg clk,rst,valid,read_write_en;
reg [WIDTH-1:0]write;
reg [ADDR_WIDTH-1:0]address;
wire ready;
wire [WIDTH-1:0]read;
integer i;
reg [8*30:0] test_cases;
memory mem(clk,rst,read_write_en,valid,write,address,ready,read);
initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
rst = 1;
reset_inputs();
#10;
rst = 0;
$value$plusargs("Test_case=%s",test_cases);
case(test_cases)

"test_fd_read_fd_write":
begin
write_loc(0,DEPTH);
read_loc(0,DEPTH);
end
"test_fd_read_bd_write":
begin
write_loc_bd(0,DEPTH);
read_loc(0,DEPTH);
end
"test_bd_read_fd_write":
begin
read_loc_bd(0,DEPTH);
write_loc(0,DEPTH);
end
"test_bd_read_bd_write":
begin
write_loc_bd(0,DEPTH);
read_loc_bd(0,DEPTH);
end
endcase
$finish;
end

task read_loc_bd(input integer start_loc,input integer no_of_loc);
begin
//take memory contents and write those contents to the image file
$writememh("Read.txt",mem.memory,start_loc,start_loc+no_of_loc-1);
end
endtask

task write_loc_bd(input integer start_loc,input integer no_of_loc);
begin
//read the image file and load image content to the memory
$readmemh("Write.txt",mem.memory,start_loc,start_loc+no_of_loc-1);
end
endtask

task write_loc(input integer start_loc,input integer no_of_loc);
begin
for(i = start_loc; i < (start_loc + no_of_loc) ; i = i+1)
begin
      @(posedge clk)
      read_write_en = 1;
      address = i;
      write = $random();
      valid = 1;
      wait(ready == 1);
end
reset_inputs();
end
endtask

task read_loc(input integer start_loc,input integer no_of_loc);
begin
for(i = start_loc; i< start_loc + no_of_loc ; i = i+1)
begin
     @(posedge clk);
     read_write_en = 0;
	 address = i;
     valid = 1;
     wait(ready == 1);
end
reset_inputs();
end
endtask

task reset_inputs();
begin
valid = 0;
read_write_en = 0;
write = 0;
address = 0;
end
endtask

endmodule
