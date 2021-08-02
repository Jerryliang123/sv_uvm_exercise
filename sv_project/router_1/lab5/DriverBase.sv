`ifndef INC_DRIVERBASE_SV
`define INC_DRIVERBASE_SV

class DriverBase;
    virtual router_io.TB rtr_io;
    string name;
    bit [3:0] sa, da;
    logic [7:0] payload[$];
    Packet pkt2send;

    extern function new(string name = "DriverBase", virtual router_io.TB rtr_io);
    extern virtual task send();
    extern virtual task send_addrs();
    extern virtual task send_pad();
    extern virtual task send_payload();

endclass //DriverBase    

function DriverBase::new(string name, virtual router_io.TB rtr_io);
    if(TRACE_ON)
endfunction