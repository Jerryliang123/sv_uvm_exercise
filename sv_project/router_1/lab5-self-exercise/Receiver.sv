class receiver;
    string name;

    pkt_mbox out_box;
    virtual router_io.TB rtr_io;

    Packet pkt2cmp;

    function new(string name="receiver", virtual router_io.TB rtr_io, pkt_mbox out_box);
        this.name = name;
        this.rtr_io = rtr_io;
        this.out_box = out_box;
    endfunction //new()

    task start();
        recv();
        this.out_box.put(out_box);
    endfunction

    task recv();
        //receive all payload data;

    endfunction

endclass //receiver