    initial begin
        foreach(drvr[i])
            drvr[i].start();
        foreach(rcvr[i])
            rcvr[i].start();
    end