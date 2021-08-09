module router(
    reset_n,clock,frame_n,valid_n,din,dout,busy_n,valido_n,frameo_n
);

input reset_n,clock;

input [15:0] din, frame_n, valid_n;
output [15:0] dout, valido_n, busy_n, frameo_n;

wire reset;
wire [15:0] arb0, arb1, arb2, arb3, arb4, arb5, arb6, arb7;
wire [15:0] di;
wire [15:0] arb8, arb9, arb10, arb11, arb12, arb13, arb14, arb15;
wire [15:0] arb_head, okstep;

tri0 [15:0] doint;
tri1 [15:0] valdoint_n, frameoint_n;

reg [15:0] dout, valido_n, frameo_n;
reg [3:0] arb_head_num;

assign di = din;

assign reset = ~reset_n;
assign arb_head = 1 << arb_head_num;

rtslice rts0(reset, clock, frame_n[0], valid_n[0],di[0],
            arb0, arb1, arb_head[0],okstep[0],
            doint, busy_n[0],valdoint_n,frameoint_n);
rtslice rts1(reset, clock, frame_n[1], valid_n[1],di[1],
            arb1, arb2, arb_head[1],okstep[1],
            doint, busy_n[1],valdoint_n,frameoint_n);
rtslice rts2(reset, clock, frame_n[2], valid_n[2],di[2],
            arb2, arb3, arb_head[2],okstep[2],
            doint, busy_n[2],valdoint_n,frameoint_n);
rtslice rts3(reset, clock, frame_n[3], valid_n[3],di[3],
            arb3, arb4, arb_head[3],okstep[3],
            doint, busy_n[3],valdoint_n,frameoint_n);
rtslice rts4(reset, clock, frame_n[4], valid_n[4],di[4],
            arb4, arb5, arb_head[4],okstep[4],
            doint, busy_n[4],valdoint_n,frameoint_n);
rtslice rts5(reset, clock, frame_n[5], valid_n[5],di[5],
            arb5, arb6, arb_head[5],okstep[5],
            doint, busy_n[5],valdoint_n,frameoint_n);
rtslice rts6(reset, clock, frame_n[6], valid_n[6],di[6],
            arb6, arb7, arb_head[6],okstep[6],
            doint, busy_n[6],valdoint_n,frameoint_n);
rtslice rts7(reset, clock, frame_n[7], valid_n[7],di[7],
            arb7, arb8, arb_head[7],okstep[7],
            doint, busy_n[7],valdoint_n,frameoint_n);
rtslice rts8(reset, clock, frame_n[8], valid_n[8],di[8],
            arb8, arb9, arb_head[8],okstep[8],
            doint, busy_n[8],valdoint_n,frameoint_n);
rtslice rts9(reset, clock, frame_n[9], valid_n[9],di[9],
            arb9, arb10, arb_head[9],okstep[9],
            doint, busy_n[9],valdoint_n,frameoint_n);
rtslice rts10(reset, clock, frame_n[10], valid_n[10],di[10],
            arb10, arb11, arb_head[10],okstep[10],
            doint, busy_n[10],valdoint_n,frameoint_n);
rtslice rts11(reset, clock, frame_n[11], valid_n[11],di[11],
            arb11, arb12, arb_head[11],okstep[11],
            doint, busy_n[11],valdoint_n,frameoint_n);
rtslice rts12(reset, clock, frame_n[12], valid_n[12],di[12],
            arb12, arb13, arb_head[12],okstep[12],
            doint, busy_n[12],valdoint_n,frameoint_n);
rtslice rts13(reset, clock, frame_n[13], valid_n[13],di[13],
            arb13, arb14, arb_head[13],okstep[13],
            doint, busy_n[13],valdoint_n,frameoint_n);
rtslice rts14(reset, clock, frame_n[14], valid_n[14],di[14],
            arb14, arb15, arb_head[14],okstep[14],
            doint, busy_n[14],valdoint_n,frameoint_n);
rtslice rts15(reset, clock, frame_n[15], valid_n[15],di[15],
            arb15, arb0, arb_head[15],okstep[15],
            doint, busy_n[15],valdoint_n,frameoint_n);


always @(posedge reset) 
begin
    arb_head_num<=4'b0;
end

always @(posedge clock) 
begin
    dout <= doint;
    valido_n <= valdoint_n;
    frameo_n <= frameoint_n;
    if(reset == 1'b0)
    begin
        if(okstep[arb_head_num] == 1'b1 )
            arb_head_num <= arb_head_num + 1;
    end
end
endmodule

module rtslice(reset,clock,frame_n,valid_n,din,
            iarbin, arbout, arbhead,okstep,
            dout,busy_n,valido_n,frameo_n);

input reset, clock, frame_n,valid_n,din,arbhead;
output busy_n,okstep;
input [15:0] iarbin;
output [15:0] arbout,dout,valido_n;
inout [15:0] frameo_n;

reg [4:0] addrsf, addrsel;
reg [5:0] addrfsr;
reg din1, busy_n, frame1_n, frame2_n, vald1_n, arbena;

wire [15:0] dout;
wire [15:0] arbin;
wire busy1_n;
wire [4:0] addrsel_g;

reg [3:0] i;

    assign arbin = (arbhead == 1'b1) ? 16'hffff:iarbin;
    assign addrsel_g = (arbena == 1'b1) ? addrsel : 5'h0;

    assign dout[0] = (addrsel_g == 5'h10 && arbin[0] == 1'b1) ? din1:1'bZ;
    assign dout[1] = (addrsel_g == 5'h11 && arbin[1] == 1'b1) ? din1:1'bZ;
    assign dout[2] = (addrsel_g == 5'h12 && arbin[2] == 1'b1) ? din1:1'bZ;
    assign dout[3] = (addrsel_g == 5'h13 && arbin[3] == 1'b1) ? din1:1'bZ;
    assign dout[4] = (addrsel_g == 5'h14 && arbin[4] == 1'b1) ? din1:1'bZ;
    assign dout[5] = (addrsel_g == 5'h15 && arbin[5] == 1'b1) ? din1:1'bZ;
    assign dout[6] = (addrsel_g == 5'h16 && arbin[6] == 1'b1) ? din1:1'bZ;
    assign dout[7] = (addrsel_g == 5'h17 && arbin[7] == 1'b1) ? din1:1'bZ;
    assign dout[8] = (addrsel_g == 5'h18 && arbin[8] == 1'b1) ? din1:1'bZ;
    assign dout[9] = (addrsel_g == 5'h19 && arbin[9] == 1'b1) ? din1:1'bZ;
    assign dout[0] = (addrsel_g == 5'h10 && arbin[1] == 1'b1) ? din1:1'bZ;



endmodule