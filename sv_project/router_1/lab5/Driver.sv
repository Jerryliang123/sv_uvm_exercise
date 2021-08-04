`ifndef INC_DRIVER_SV
`define INC_DRIVER_SV
`include "DriverBase.sv"
class Driver extends DriverBase;
    pkt_mbox in_box;
    pkt_mbox out_box;
    semaphore sem[];

    extern function new(string name="Driver", int port_id,semaphore sem[],pkt_mbox in_box,out_box,virtual router_io.TB router_io);
    extern virtual task start();
endclass //Driver

function Driver::new(string name, int port_id,semaphore sem[],pkt_mbox in_box,out_box,virtual router_io.TB router_io);
    super.new(name,rtr_io);
    if(TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    this.sa = port_id;
    this.sem = sem;
    this.in_box = in_box;
    this.out_box = out_box;
endfunction

task Driver::start();
    if(TRACE_ON) $display("[TRACE]%t %s:%m",$realtime,this.name);
    fork
        forever begin
            this.in_box.get(this.pkt2send);
            if(this.pkt2send.sa != this.sa) continue;
            this.da = this.pkt2send.da;
            this.payload = this.pkt2send.payload;
            this.sem[this.da].get(1);
            this.send();
            this.out_box.put(this.pkt2send);
            this.ssem[this.da].put(1);
        end
    join_none
endtask
`endif