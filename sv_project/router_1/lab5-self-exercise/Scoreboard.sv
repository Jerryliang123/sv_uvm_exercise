class scoreboard;
    string name;
    pkt_mbox cmp_box;
    pkt_mbox send_box;

    Packet driver_pkt;
    Packet cmp_pkt;

    function new(
        string name;
        pkt_mbox cmp_box;
        pkt_mbox send_box;
    );
        this.name = name;
        this.cmp_box = cmp_box;
        this.send_box = send_box;
    endfunction

    function start();
        this.driver_pkt = this.send_box.get();
        this.cmp_pkt = this.cmp_box.get();
        check();
    endfunction

    function check();
        
    endfunction


endclass