`ifndef INC_SCOREBOARD_SV
`define INC_SCOREBOARD_SV

class Scoreboard;
    string name;
    event DONE;
    Packet refPkt[$];
    Packet pkt2send;
    Packet pkt2cmp;
    pkt_mbox driver_mbox;
    pkt_mbox receiver_mbox;

    extern function new(string name = "Scoreboard", pkt_mbox driver_mbox = null, receiver_mbox = null );
    extern virtual task start();
    extern virtual task check();

endclass //Scoreboard

function Scoreboard::new(string name, pkt_mbox driver_mbox, receiver_mbox);
    if(TRACE_ON) $display("[TRACE] %t %s:%m",$realtime,name);
    this.name = name;
    if(driver_mbox == null) driver_mbox = new();
    this.driver_mbox = driver_mbox;
    if(receiver_mbox == null) receiver_mbox = new();
    this.receiver_mbox = receiver_mbox;
endfunction

task Scoreboard::start();
    if(TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, this.name);
    fork
        forever begin
            this.receiver_mbox.get(this.pkt2cmp);
            while(this.driver_mbox.num()) begin
                Packet pkt;
                this.driver_mbox.get(pkt);
                this.refPkt.push_back(pkt);
            end
            this.check();
        end
    join_none
endtask
`endif