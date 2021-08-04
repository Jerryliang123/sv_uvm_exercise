program automatic test(router_io.TB rtr_io);

    int run_for_n_packets; //number of packets to test
    int TRACE_ON = 0;

    `include "router_test.h"
    `include "Packet.sv"
    `include "Driver.sv"
    `include "Receiver.sv"
    `include "Generator.sv"
    `include "Scoreboard.sv"

    semaphore sem[]; // prevent output port collision
    Driver drvr[];
    Receiver rcvr[];
    Generator gen;
    Scoreboard sb;

    initial begin
        $vcdpluson;
        run_for_n_packets = 2000;
        sem = new[16];
        drvr = new[16];
        rcvr = new[16];
        gen = new();
        sb = new();
        foreach (sem[i])
            sem[i] = new(1);
        for (int i=0;i<drvr.size();i++)
            drvr[i] = new($sformatf("rcvr[%0d]",i,sb.receiver_mbox,rtr_io));
        reset();
        gen.start();
        sb.start();
        foreach(drvr[i])
            drvr[i].start();
        foreach(rcvr[i])
            rcvr[i].start();
        wait(sb.DONE.triggered);
    end

    task reset();
        if(TRACE_ON) $display("[TRACE]%t %m", $realtime);
        rtr_io.reset_n <= 1'b0;
        rtr_io.cb.frame_n <= '1;
        rtr_io.cb.valid_n <= '1;
        ##2 rtr_io.cb.reset_n <= 1'b1;
        repeat (15) @(rtr_io.cb);
    endtask //reset

endprogram