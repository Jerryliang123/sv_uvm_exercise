class ahb_trns;
  rand bit[data_width-1:0] hwdata[8];
  rand bit[addr_width-1:0] hwaddr;
  rand bit                 hwrite;
  rand tr_type_t tr_type;   
 
endclass