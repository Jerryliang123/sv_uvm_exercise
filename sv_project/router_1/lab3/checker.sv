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