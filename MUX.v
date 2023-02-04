/*
   ****** MUX Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module MUX # (
    parameter BUS_WIDTH =  8
   // parameter NUM_STAGES = 2
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire       [1:0]            mux_sel,
    input  wire                        SER_DATA,PAR_BITS,busy_in,
    output reg                         TX_OUT,busy
);

// internal signal
wire       START_BIT,STOP_BIT;
reg        TX_OUT_c ;


always@(posedge CLK or negedge RST)
    begin
    if (!RST)
    begin
    TX_OUT <= STOP_BIT;
    busy   <= START_BIT;
    end
    else
    begin
    TX_OUT <= TX_OUT_c;
    busy   <= busy_in;
    
    end
    end


always@(*)
    begin
    case (mux_sel)
    2'b00 : TX_OUT_c = START_BIT;
    2'b01 : TX_OUT_c = STOP_BIT;
    2'b11 : TX_OUT_c = PAR_BITS;
    2'b10 : TX_OUT_c = SER_DATA;
    endcase
    end
assign START_BIT = 1'b0;
assign STOP_BIT  = 1'b1;
endmodule