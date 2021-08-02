program automatic test(router_io.TB rtr_io);

    logic [7:0] pkt2cmp_payload;

    bit [3:0] sa;
    bit [3:0] da;
    logic [7:0] payload[$]; // payload queue every payload is a byte

    initial begin
        $vcdpluson;
        run_for_n_packets = 21;
        reset();
        repeat (run_for_n_packets) begin
            gen();
            fork
                send();
                recv();
            join
            check();
        end
    end
// for recv
    task recv();
        get_payload();
    endtask

    task get_payload();
        pkt2cmp_payload.delete();
        fork
            begin: wd_timer_fork
                fork:frameo_wd_timer // if frameo_n negedge arrived then jump out fork
                    @(negedge rtr_io.cb.frame_n[da]);
                    begin
                        repeat(1000) @(rtr_io.cb);
                        $display("\n%m\n[ERROR]%t Frame signal timed out!\n", $realtime);
                        $finish;
                    end
                join_any:frameo_wd_timer
                disable fork;
            end:wd_timer_fork
        join

        forever begin
            logic [7:0] datum;
            for (int i=0; i<8;) begin
                if(!rtr_io.cb.valido_n[da])
                    datum[i++] = rtr_io.cb.dout[da];
                if (rtr_io.cb.frameo_n[da]) begin
                    if(i==8) begin
                        pkt2cmp_payload.push_back(datum);
                        return;
                    end
                    else begin
                        $display("\n%m\n[ERROR]%t Packet payload not byte aligned!\n", $realtime);
                        $finish;
                    end
                end
                @(rtr_io.cb);               
            end
            pkt2cmp_payload.push_back(datum);
        end

    endtask: get_payload

// for checker and compare
    function bit compare(ref string message);
        if (payload.size() != pkt2cmp_payload.size()) begin
            message = "payload size mismatch: \n";
            message = {message, $sformatf("payload.size() = %0d, pkt2cmp_payload.size() = %0d\n",payload.size(),pkt2cmp_payload.size())};
            return (0);
        end

        if (payload == pkt2cmp_payload);
        else begin
            message = "Payload Content Mismatch:\n";
            message = {message, $sformatf("Packet Sent: %p\nPkt Received: %p", payload, pkt2cmp_payload)};
            return (0);
        end
        message = "successfully Compared";
        return(1); 
    endfunction

    task check();
        string message;
        static int pkts_checked = 0;
        if(!compare(message)) begin
            $display("\n%m\n[ERROR]%t Packet #%0d %s\n", $realtime, pkts_checked,message)
            $finish;
        end
        $display("[NOTE]%t Packet #%0d %s", $realtime, pkts_checked++, message);
    endtask    


//reset
    task reset();
        rtr_io.reset_n = 1'b0;
        rtr_io.cb.frame_n <= '1;
        rtr_io.cb.valid_n <= '1;
        ##2 rtr_io.cb.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask 

//driver
// generate stimulus
    task gen();
        sa = 3;
        da = 7;
        payload.delete();
        repeat($urandom_range(2,4))
            payload.push_back($urandom);
    endtask

    task send();
        send_addrs();
        send_pad();
        send_payload();
    endtask

    // send address to out port  rtr_io.cb.din[sa] = da[i]; assign every bit to addr
    // generate sa and da;
    task send_addrs();
        // pull down frame_n
        rtr_io.cb.frame_n[sa] <= 1'b0;
        for (i = 0;i<4;i++) begin
            rtr_io.cb.din[sa] <= da[i];
            @(rtr_io.cb);
        end
    endtask

    // send pad, 
    task send_pad();
        rtr_io.cb.frame_n <= '0;
        rtr_io.cb.din[sa] <= '1;
        rtr_io.cb.valid_n <= '1;
        repeat(5) @(rtr_io.cb);
    endtask

    //send payload
    // for valid_n: set valid_n to 0 to sample;
    // after all complete: set frame_n to 1, set valid_n to 1;
    // data[sa] = payload[index][i]
    task send_payload();
        foreach(payload[index]) begin
           for (i=0;i<8;i++) begin
                rtr_io.cb.valid_n[sa] <= 0;
                rtr_io.cb.din[sa] <= payload[index][i];
                rtr_io.cb.frame_n[sa] <= (index == (payload.size()-1)) && (i == 7);
                @(rtr_io.cb)
            end
        end
        rtr_io.cb.valid_n[sa] <= 'b1;
    endtask
endprogram