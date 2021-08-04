class generator;

    string name;
    pkt_mbox pkt_out;
    Packet pkt;

    function new(string name="generator",Packet pkt,pkt_mbox pkt_out);
        this.name = name;
        this.pkt = pkt;
        this.pkt_out = pkt_out;
    endfunction //new()

    task start;
        gen();
        this.pkt_out.put(pkt);
    endfunction

    task gen;

        this.pkt.randomize();

    endfunction

endclass //generator