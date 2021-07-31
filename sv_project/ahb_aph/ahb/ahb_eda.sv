// Code your testbench here
// or browse Example
parameter data_width	=8;
parameter addr_width	=32;
parameter seq			=2'b00;
parameter non_seq		=2'b01;
parameter hsize         =4;

interface ahb_inter;
  bit hclk=0;
  bit hreset=0;  
  bit[1:0] htrans;
endinterface  

typedef enum {READ,WRITE}tr_type_t;

class ahb_trns;
  rand bit[data_width-1:0] hwdata[8];
  rand bit[addr_width-1:0] hwaddr;
  rand bit                 hwrite;
  rand tr_type_t tr_type;   
 
endclass
     

class ahb_driver; 
  ahb_trns m_trns;
  virtual interface ahb_inter ahb_inf;

function new();
   	m_trns=new();  
  	this.m_trns=m_trns;
  //this.ahb_inf = ahb_inf;
endfunction
   
  task run();
 for(int i=0;i<8;i=i+1)
  begin
    m_trns=new();
	   m_trns.randomize();
   if(!ahb_inf.hreset)
    begin
     foreach(m_trns.hwdata[i])
      begin
        $display($realtime,"__[DRIVER] before  @(posedge ahb_inf.hclk) in driver: hclk=%d,hreset=%d",ahb_inf.hclk,ahb_inf.hreset);
       @(posedge ahb_inf.hclk)
          begin
            $display($realtime,"__[DRIVER] after  @(posedge ahb_inf.hclk) in driver: hclk=%d,hreset=%d, i = %d",ahb_inf.hclk,ahb_inf.hreset, i);
  			m_trns.hwrite=(m_trns.tr_type ==WRITE)? 1:0;
            m_trns.hwaddr=(m_trns.hwrite)?m_trns.hwdata[i]:1'bx;
     	  end
   	   end 
    end
    $display($realtime,"__[DRIVER] hclk=%d,hreset=%d,htrans=%d,hwrite=%d,hwaddr=%d",ahb_inf.hclk,ahb_inf.hreset,ahb_inf.htrans,m_trns.hwrite,m_trns.hwaddr);
  end    
endtask

endclass 
  
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
