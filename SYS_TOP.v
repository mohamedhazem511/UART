

module SYS_TOP #(parameter WIDTH = 8, parameter add = 4 ) (



input    wire                     REF_CLK,

input    wire                     UART_CLK,

input    wire                     RST,

input    wire                     RX_IN, 

output   wire                     TX_OUT,

output   wire                     PAR_ERR,STP_ERR

);



wire    [WIDTH-1:0]      Wr_D,
                         Rd_D,
                         TX_P_DATA,
                         TX_P_DATA_ASYNC,
                         RX_P_Data,
                         RX_P_DATA_ASYNC,
                         Op_A,
                         Op_B,
                         UART_Config;

wire    [add-1:0]        Addr,FUN;			            

wire    [15:0]           ALU_OUT;
wire    [4:0]            Div_Ratio;

wire                     WrEn,
                         RdEn,
                         EN,
                         Rd_D_Vld,
                         CLKDIV_EN,
                         OUT_Valid,
                         TX_Valid,
                         TX_Valid_ASYNC,
                         RX_Valid,
                         RX_Valid_ASYNC,
                         Busy_ASYNC,
                         Busy_SYNC;							 												 

wire                     enable_alu,enable_reg;

wire 	                 TX_CLK,
                         ALU_CLK,
                         SYNC_RST1,
                         SYNC_RST2,
                         Gate_EN;

						 



CTRL_RX U0_CTRL_RX (

.CLK(REF_CLK),

.RST(RST),

.RX_P_Data(RX_P_Data),

.RX_D_VLD(RX_Valid),  

.ALU_EN(EN),

.CLK_EN(Gate_EN),

.WrEn(WrEn),

.RdEn(RdEn),

.clk_div_en(CLKDIV_EN),

.WrData(Wr_D),

.Address(Addr),

.ALU_FUN(FUN),

.enable_alu(enable_alu),

.enable_reg(enable_reg)

);


CTRL_TX U0_CTRL_TX (

.CLK(REF_CLK),

.RST(RST),

.ALU_OUT(ALU_OUT),

.OUT_Valid(OUT_Valid),

.Busy(Busy_SYNC),
              
.RdData_Valid(Rd_D_Vld),

.RdData(Rd_D),

.TX_P_DATA(TX_P_DATA_ASYNC), 

.TX_D_VLD(TX_Valid_ASYNC),

.enable_alu(enable_alu),

.enable_reg(enable_reg)

);
					 



RegFile U0_RegFile (

.CLK(REF_CLK),

.RST(SYNC_RST1),

.WrEn(WrEn),

.RdEn(RdEn),

.Address(Addr),

.WrData(Wr_D),

.RdData(Rd_D),

.RdData_VLD(Rd_D_Vld),

.REG0(Op_A),

.REG1(Op_B),

.REG2(UART_Config),

.REG3(Div_Ratio)

);





ALU U0_ALU (

.CLK(ALU_CLK),

.RST(RST),

.A(Op_A), 

.B(Op_B),

.EN(EN),

.ALU_FUN(FUN),

.ALU_OUT(ALU_OUT),

.OUT_VALID(OUT_Valid)

);	



CLK_DIV U0_CLK_DIV (

.CLK(UART_CLK),             

.RST(RST),               

.CLK_EN(CLKDIV_EN),             

.DIV_RATIO(Div_Ratio),            

.DIV_CLK(TX_CLK)             

);





CLK_GATE U0_CLK_GATE (

.CLK_EN(Gate_EN),

.CLK(REF_CLK),

.GATED_CLK(ALU_CLK)

);



RST_SYNC U1_RST_SYNC (

.CLK(REF_CLK),

.RST(RST),

.SYNC_RST(SYNC_RST1)    

);

RST_SYNC U2_RST_SYNC (

.CLK(UART_CLK),

.RST(RST),

.SYNC_RST(SYNC_RST2)    

);

BIT_SYNC U0_BIT_SYNC (

.CLK(REF_CLK),

.RST(RST),

.ASYNC(Busy_ASYNC),

.SYNC(Busy_SYNC)

);

DATA_SYNC U0_RX_DATA_SYNC (

.CLK(REF_CLK),

.RST(RST),

.bus_enable(RX_Valid_ASYNC),  

.unsync_bus(RX_P_DATA_ASYNC),

.enable_pulse(RX_Valid),

.sync_bus(RX_P_Data)

);

DATA_SYNC U0_TX_DATA_SYNC (

.CLK(TX_CLK),

.RST(SYNC_RST2),

.bus_enable(TX_Valid_ASYNC),  

.unsync_bus(TX_P_DATA_ASYNC), 

.enable_pulse(TX_Valid),  

.sync_bus(TX_P_DATA)         

);

UART_TX U0_UART_TX (
.CLK(TX_CLK),

.RST(RST),

.Data_Valid(TX_Valid),  

.P_DATA(TX_P_DATA), 

.PAR_TYP(UART_Config[1]),

.PAR_EN(UART_Config[0]),

.TX_OUT(TX_OUT),

.busy(Busy_ASYNC)


);

UART_RX U0_UART_RX (
.CLK(UART_CLK),

.RST(RST),

.PAR_TYP(UART_Config[1]),

.PAR_EN(UART_Config[0]),

.Prescale(UART_Config[6:2]),

.RX_IN(RX_IN),

.Data_Valid(RX_Valid_ASYNC),

.P_DATA(RX_P_DATA_ASYNC),

.PAR_ERR(PAR_ERR),

.STP_ERR(STP_ERR)

);

endmodule
