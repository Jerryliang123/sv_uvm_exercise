class Packet;
    string name;
    
    bit [3:0] sa,da;
    logic [7:0] payload;

    //methods
    //new TODO
    function new(string name = "Packet");
        this.name = name;
    endfunction
    //compare TODO
    extern function void compare(Packet pkt2cmp, ref string message);
    //display TODO
    extern function void display();
endclass

// compare pkt2cmp and pkt2send;
function Packet::compare(Packet pkt2cmp, ref string message);
    if (this.payload != pkt2cmp.payload)
        message = "payload content not match";
    $display("Successful compared");
endfunction

// display payload, sa, da
function Packet::display();
    foreach(this.payload) $display("Payload is %d",this.payload);
endfunction

// v0.1