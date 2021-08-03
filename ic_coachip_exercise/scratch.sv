class Rising;
    byte low;
    rand byte med, hi;
    constraint c_up {low<med;med<hi;}
endclass //Rising

program test;
    Rising r;
    initial begin
        r = new();
        r.randomize();
        $display("r::low is %d,r::med is %d, r::hi is %d", r.low, r.med, r.hi);
        r.randomize(med);
        $display("r::low is %d,r::med is %d, r::hi is %d", r.low, r.med, r.hi);
        r.randomize(low);
        $display("r::low is %d,r::med is %d, r::hi is %d", r.low, r.med, r.hi);                
    end
endprogram