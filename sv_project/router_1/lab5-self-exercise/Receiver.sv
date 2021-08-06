class Receiver;
    string name;

    pkt_mbox out_box;
    virtual router_io.TB rtr_io;


    Packet pkt2cmp;

    function new(string name="receiver", int port_id, virtual router_io.TB rtr_io, pkt_mbox out_box);
        this.name = name;
        this.rtr_io = rtr_io;
        this.out_box = out_box;
        this.da = port_id;
    endfunction //new()

    extern task start();

endclass //receiver

task Receiver::start();
    fork
        forever begin

        end
    join_none
endtask

task Receiver::recv();
    //receive specific payload from specific ports
    // wait for frame_n to go down and start to collect payload
    // one bit a clk
    if (rtr_io.frame_n[this.da] == '0)
        for (i=0;i<8;i++)
            this.out_box.payload = rtr_io.payload[this.da]; 
            @(rtr_io.cb);

endtask