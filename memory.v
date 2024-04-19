module memory(clk,rst,read_write_en,valid,write,address,ready,read);
//4KB
parameter DEPTH = 1024;
parameter WIDTH = 32;
parameter ADDR_WIDTH = $clog2(DEPTH);
input clk,rst,read_write_en,valid;
input [WIDTH-1:0]write;
input [ADDR_WIDTH-1:0]address;
output reg ready;
output reg [WIDTH-1:0]read;
reg [WIDTH-1:0] memory [DEPTH-1:0];
integer i;
always@(posedge clk) begin
if(rst)
 begin
   ready <= 0;
   read <= 0;
   for(i = 0; i < DEPTH ; i=i+1) begin
        memory[i] = 0;
	end
  end
  else
  begin
     if(valid) begin
         ready = 1;
            if(read_write_en)
                 memory[address] = write;
             else
                read = memory[address];
     end
     else
         ready = 0;
  end
end
endmodule


