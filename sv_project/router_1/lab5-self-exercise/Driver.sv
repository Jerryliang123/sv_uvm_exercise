class Driver;
    string name;

    pkt_mbox pkt_in;
    pkt_mbox pkt_out;
    virtual router_io.TB rtr_io;

    Packet pkt2send;
    logic [7:0] payload[$];
    logic [3:0] sa,da;

    semaphore sem[];

// put information into database
    function new(pkt_mbox pkt_in,pkt_out, virtual router_io.TB rtr_io, semaphore sem[], int port_id, string name="Driver");
        this.pkt_in = pkt_in;
        this.pkt_out = pkt_out;
        this.rtr_io = rtr_io;

        this.sem = sem;

        this.sa = port_id;
        this.name = name;
    endfunction //new()

// others

    function start;
        this.pkt2send = this.pkt_in.get();

        this.da = this.pkt2send.da;
        this.payload = this.pkt2send.payload;
        this.sem[this.da].get(1);

        this.send();

        this.pkt_out.put(pkt2send);
        this.sem[this.da].put(1);
        
    endfunction


// interface to DUT
    function send();
        
    endfunction

    function send_addrs;
        
    endfunction

    function send_pad;

    endfunction

    function send_payload;
        
    endfunction

endclass

// v0.1