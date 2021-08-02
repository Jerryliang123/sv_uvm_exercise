program automatic test(router_io.TB rtr_io);

    bit [3:0] sa;
    bit [3:0] da;
    logic [7:0] payload[$]; // payload queue every payload is a byte

    initial begin
        $vcdpluson;
        run_for_n_packets = 21;
        reset();
        repeat (run_for_n_packets) begin
            gen();
            send();
        end
    end

    task reset();
        rtr_io.reset_n = 1'b0;
        rtr_io.cb.frame_n <= '1;
        rtr_io.cb.valid_n <= '1;
        ##2 rtr_io.cb.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask 

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