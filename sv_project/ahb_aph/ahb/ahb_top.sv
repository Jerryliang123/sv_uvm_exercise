// Code your testbench here
// or browse Example
parameter data_width	=8;
parameter addr_width	=32;
parameter seq			=2'b00;
parameter non_seq		=2'b01;
parameter hsize         =4;

typedef enum {READ,WRITE}tr_type_t;




module ahb_write;
  ahb_inter ahb_if();  
  always #5 ahb_if.hclk= ~ahb_if.hclk;
  initial
    begin
      ahb_if.hreset = 0;
      #5  ahb_if.hreset = 1;
      #5  ahb_if.hreset = 0;
    end
  initial
    begin
      ahb_driver ahb_drv=new();
      ahb_drv.ahb_inf = ahb_if;// interface is copied to virtual interface of driver
      fork
        ahb_drv.run();
        $monitor($realtime,"__hclk=%d",ahb_if.hclk);
      join
      #100 $finish;
    end
endmodule