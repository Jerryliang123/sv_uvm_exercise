module apb_master (pclk,prst,paddr,pwdata,prdata,pwrite,pread,psel,penable,pready);

parameter S_IDLE = 3'b000;
parameter S_SETUP = 3'b001;
parameter S_ACCESS = 3'b010;
input pclk;
input prst;
output reg  [3:0] paddr;
output reg  [7:0] pwdata;
input  [7:0] prdata;
output reg  pwrite;
output reg psel;
output penable;
output reg pread;
input  pready;
//input  wire pslverr;
reg [2:0] state, next_state;
reg Tr;
reg [7:0] yahoo;

reg [3:0] addr_bus;
reg [7:0] data_bus;

initial begin
if(prst)begin
    paddr = 0;
    pwdata = 0;
    pwrite = 0;
    psel = 0;
    pready = 0;
        //pslverr = 0;
end
end

always@(posedge pclk) begin
    if(penable)begin
        if(pready)begin
            if(pwrite)begin
            addr_bus = paddr;
            data_bus = pwdata;       
            end            
            if(pread) begin
            prdata = pwdata;
            end
        end
    end
end

always @(next_state) begin
    state = next_state;
end


always @(posedge pclk) begin
case(state)
    S_IDLE:begin
    psel = 0;
    penable=0;
        if (Tr == 1)  begin
            next_state = S_SETUP;
        end
    end

    S_SETUP:begin
    psel = 1;
    penable = 0;
    next_state = S_ACCESS;   
    end

    S_ACCESS:begin
    psel = 1;
    penable = 1;
        if (pready == 0)  begin
            next_state = S_ACCESS;   
        end
        if((pready == 1) && (Tr == 1)) begin
            next_state = S_SETUP;
        end       
    end
endcase