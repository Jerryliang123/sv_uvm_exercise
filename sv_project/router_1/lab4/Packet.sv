`ifndef INC_PACKET_SV
`define INC_PACKET_SV
class Packet;
    rand bit [3:0] ra,da;
    rand logic [7:0] payload[$];
        string name; // unique identifier

    constraint Limit {
        sa inside {[0:15]};
        da inside {[0:15]};
        payload.size() inside {[2:4]};
    }

    extern function new(string name = "Packet");
    extern function bit compare(Packet pkt2cmp, ref string message);
    extern function void display(string prefix = "NOTE");
endclass //Packet

function Packet::new(string name);
    this.name = name;
endfunction

function bit Packet::compare(Packet pkt2cmp, ref string message);
    if (payload.size() != pkt2cmp.payload.size()) begin
        message = "payload size mismatch: \n";
        message = {message, $sformatf("payload.size() = %0d, pkt2cmp.payload.size() = %0d\n",payload.size(),pkt2cmp.payload.size())};
        return (0);
    end

    if (payload == pkt2cmp.payload);
    else begin
        message = "Payload Content Mismatch:\n";
        message = {message, $sformatf("Packet Sent: %p\nPkt Received: %p", payload, pkt2cmp.payload)};
        return (0);
    end
    message = "successfully Compared";
    return(1);     
endfunction

function void Packet::display(string prefix);
    $display("[%s]%t %s sa = %0d, da = %0d", prefix, $realtime, name, sa, da);
    foreach(payload[i])
        $display("[%s]%t %s payload[%0d] = %0d", prefix, $realtime, name, i, payload[i]);
endfunction



`endif