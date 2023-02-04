/*
   ****** Testbench SYSTEM_TOP Block ******
   by:
       Mohamed Hazem Mamdouh
       7-9-2022
       12:54 PM   
*/

/****** Time Scale ******/

`timescale 1us/1ns

module SYS_TOP_tb ();

/****** parameters ******/

parameter  CLK_PERIOD = 5; 
parameter  BUS_WIDTH  = 8;
parameter  REF_CLK_PER = 50;
parameter  UART_CLK_PER = 100;
parameter  WR_NUM_OF_FRAMES = 3;
parameter  RD_NUM_OF_FRAMES = 2;
parameter  ALU_WP_NUM_OF_FRAMES = 4;
parameter  ALU_NP_NUM_OF_FRAMES = 2;

/****** Testbench Signals ******/
reg                        REF_CLK_TB;
reg                        RST_TB;
reg                        UART_CLK_TB;
reg                        RX_IN_TB;
wire                       TX_OUT_TB;
wire                       PAR_ERR,STP_ERR;



reg   [WR_NUM_OF_FRAMES*11-1:0]       WR_CMD     = 'b10_01111110_0_10_00000101_0_10_10101010_0;
reg   [RD_NUM_OF_FRAMES*11-1:0]       RD_CMD     = 'b10_00000011_0_10_10111011_0;
reg   [ALU_WP_NUM_OF_FRAMES*11-1:0]   ALU_WP_CMD = 'b11_00000001_0_10_00001111_0_10_11111111_0_10_11001100_0;
reg   [ALU_WP_NUM_OF_FRAMES*11-1:0]   ALU_NP_CMD = 'b11_00000010_0_10_11011101_0;

reg   [5:0]         count = 6'b0;
reg                 Data_Stimulus_En1,Data_Stimulus_En2,Data_Stimulus_En3,Data_Stimulus_En4;
/****** initial block ******/

initial
 begin
/****** System Functions ******/

 $dumpfile("SYS_TOP.vcd") ;       
 $dumpvars; 
 
/******  initial values ******/

REF_CLK_TB  = 1'b0;
UART_CLK_TB = 1'b0;
RX_IN_TB    = 1'b1;
RST_TB      = 1'b1;

#5
RST_TB = 1'b0 ;
#5
RST_TB = 1'b1 ;

#20
Data_Stimulus_En2 = 1'b1;


#400000



$stop ;
end

/**********   write  cmd   ***********
always @ (posedge DUT.U0_CLK_DIV.DIV_CLK)
begin
if (Data_Stimulus_En1 && count < 6'd44 )

begin
RX_IN_TB <= WR_CMD[count];
count    <= count + 6'b1;
end

else

RX_IN_TB <= 1'b1 ;

end
*/
///**********   read  cmd   ***********
always @ (posedge DUT.U0_CLK_DIV.DIV_CLK)
begin
if (Data_Stimulus_En2 && count < 6'd22 )

begin
RX_IN_TB <= RD_CMD[count];
count    <= count + 6'b1;
end

else

RX_IN_TB <= 1'b1 ;

end

/**********   ALU with op  cmd   ***********

always @ (posedge DUT.U0_CLK_DIV.DIV_CLK)
begin
if (Data_Stimulus_En3 && count < 6'd44 )

begin
RX_IN_TB <= ALU_WP_CMD[count];
count    <= count + 6'b1;
end

else

RX_IN_TB <= 1'b1 ;

end

**********   ALU without op  cmd   ***********


always @ (posedge DUT.U0_CLK_DIV.DIV_CLK)
begin
if (Data_Stimulus_En4 && count < 6'd44 )

begin
RX_IN_TB <= ALU_NP_CMD[count];
count    <= count + 6'b1;
end

else

RX_IN_TB <= 1'b1 ;

end
*/

/****** Clock Generator ******/

always #(REF_CLK_PER/2)  REF_CLK_TB  = !REF_CLK_TB ;

always #(UART_CLK_PER/2) UART_CLK_TB = !UART_CLK_TB ;

/****** Design Instaniation and Port Mapping ******/
SYS_TOP DUT ( 

.REF_CLK(REF_CLK_TB),

.UART_CLK(UART_CLK_TB),

.RST(RST_TB),

.RX_IN(RX_IN_TB),

.TX_OUT(TX_OUT_TB),

.PAR_ERR(PAR_ERR_TB),

.STP_ERR(STP_ERR_TB)

);

endmodule

