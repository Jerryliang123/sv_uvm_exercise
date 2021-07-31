parameter data_width = 8;
parameter addr_withd = 32;
parameter seq = 2'b00;
parameter non_seq = 2'b01;
parameter hsize = 4;

interface ahb_inter;
				bit hclk = 0;
				bit hreset = 0;
				bit [1:0] htrans;
endinterface

class ahb_trns;
				rand bit[data_width-1:0] hwdata[8];
				rand bit[addr_width-1:0] hwaddr;
				rand bit 								 hwrite;
				rand tr_type_t tr_type;
endclass

class ahb_driver;

endclass

module ahb_write;
				ahb_inter ahb_if();
				always #5 ahb_if.hclk = ~ahb_if.hclk;
				initial begin
					begin
								ahb_if.hreset = 0;
								#5 ahb_if.hreset =1;
								#5 ahb_if.reset = 0;
				end

				initial begin
					ahb_driver ahb_drv = new();
					ahb_drv.ahb_inf = ahb_if;
					fork
									ahb_drv.run();
									$monitor($realtime, "_hclk=%d",)
				end
	

endmodule
