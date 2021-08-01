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