/*
   Mohamed Hazem Mamdouh
   20-8-2022
   1:38 AM


 */
 
 
//  ***************UART_TX_BLOCK**************



// port list with parameterized and non-parameterized Width

module UART_TX #(
    parameter DATA_WIDTH = 8
    )
(
  
  input  wire                           CLK,RST,
  input  wire  [DATA_WIDTH-1:0]         P_DATA,
  input  wire                           Data_Valid,
  input  wire                           PAR_TYP,PAR_EN,
  output wire                           TX_OUT,
  output wire                           busy
  
  
  );
  // internal signal
  
  wire           ser_done,ser_enable,ser_data,par_bit;
  wire  [1:0]    mux_sel;
  wire           busy_c; 
  
  
  
  // port mapping for FSM unit
  
  FSM_TX U0_FSM_TX_UNIT (
  .CLK(CLK),
  .RST(RST),
  .Data_Valid(Data_Valid),
  .PAR_EN(PAR_EN),
  .busy_c(busy_c),
  .ser_done(ser_done),
  .ser_en(ser_enable),
  .mux_sel(mux_sel)
  );
  
  // port mapping for SER unit
  
  SER  U0_SER_UNIT (
  .CLK(CLK),
  .RST(RST),
  .P_DATA(P_DATA),
  .ser_done(ser_done),
  .ser_en(ser_enable),
  .ser_data(ser_data)
  );
  
  // port mapping for PAR unit
  
  PAR U0_PAR_UNIT (
  .CLK(CLK),
  .RST(RST),
  .P_DATA(P_DATA),
  .Data_Valid(Data_Valid),
  .PAR_TYP(PAR_TYP),
  .PAR_BIT(par_bit)
  
  );
  // port mapping for MUX unit
  
  MUX U0_MUX_UNIT (
  .CLK(CLK),
  .RST(RST),
  .TX_OUT(TX_OUT),
  .SER_DATA(ser_data),
  .PAR_BITS(par_bit),
  .busy(busy),
  .busy_in(busy_c),
  .mux_sel(mux_sel)
 
  );
  

  
  
  
endmodule