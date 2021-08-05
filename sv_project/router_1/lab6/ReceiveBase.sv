class ReceiverBase;
    virtual router_io.TB rtr_io;
    string name;
    bit[3:0] da;
    logic [7:0] pkt2cmp_payload[$];
    Packet pkt2cmp;

    extern function new();
    extern virtual task recv();
    extern virtual task get_payload();

endclass //ReceiverBase

function ReceiverBase::new();
    ;
    
endfunction

task ReceiverBase::recv();
    
endtask