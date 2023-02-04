/*
   Mohamed Hazem Mamdouh
   20-8-2022
   1:38 AM


 */
 
 
//  ***************UART_TX_BLOCK**************



// port list with parameterized and non-parameterized Width

module UART_RX #(
    parameter DATA_WIDTH = 8
    )
(
  
  input  wire                            CLK,RST,
  input  wire           [4:0]            Prescale,
  input  wire                            PAR_TYP,PAR_EN,
  input  wire                            RX_IN,
  output wire                            Data_Valid,
  output wire   [DATA_WIDTH-1:0]         P_DATA,
  output wire                            PAR_ERR,STP_ERR
  
  );
  // internal signal
  
  wire           par_chk_en,par_err;
  wire           strt_chk_en,strt_glitch;
  wire           stp_chk_en,stp_err;
  wire           dat_samp_en,enable;
  wire  [3:0]    edge_cnt,bit_cnt;
  wire           deser_en,sampled_bit;
  
  
  
  // port mapping for FSM unit
  
  FSM_RX U0_FSM_RX_UNIT (
  .CLK(CLK),
  .RST(RST),
  .Data_Valid(Data_Valid),
  .PAR_EN(PAR_EN),
  .RX_IN(RX_IN),
  .bit_cnt(bit_cnt),
  .edge_cnt(edge_cnt),
  .enable(enable),
  .deser_en(deser_en),
  .dat_samp_en(dat_samp_en),
  .par_chk_en(par_chk_en),
  .par_err(par_err),
  .strt_chk_en(strt_chk_en),
  .strt_glitch(strt_glitch),
  .stp_chk_en(stp_chk_en),
  .stp_err(stp_err)
  
  );
  
  // port mapping for DE_SER unit
  
  DE_SER  U0_DE_SER_UNIT (
  .CLK(CLK),
  .RST(RST),
  .deser_en(deser_en),
  .P_DATA(P_DATA),
  .edge_cnt(edge_cnt),
  .sampled_bit(sampled_bit)
  );
  
  // port mapping for edge_bit_count unit
  
  edge_bit_count U0_edge_bit_count_UNIT (
  .CLK(CLK),
  .RST(RST),
  .enable(enable),
  .bit_cnt(bit_cnt),
  .edge_cnt(edge_cnt)
 
  );
    // port mapping for data_sampling unit
  data_sampling U0_data_sampling_UNIT (
  .CLK(CLK),
  .RST(RST),
  .dat_samp_en(dat_samp_en),
  .edge_cnt(edge_cnt),
  .RX_IN(RX_IN),
  .Prescale(Prescale),
  .sampled_bit(sampled_bit)
    

  );
// port mapping for PAR_bit_Chk unit
  PAR_Chk U0_PAR_Chk_UINT (
  .CLK(CLK),
  .RST(RST),
  .par_chk_en(par_chk_en),
  .P_DATA(P_DATA),
  .sampled_bit(sampled_bit),
  .PAR_TYP(PAR_TYP),
  .par_err(par_err),
  .PAR_ERR(PAR_ERR)

  );
// port mapping for start_bit_Chk unit
  start_chk U0_start_chk_UINT (
  .CLK(CLK),
  .RST(RST),
  .strt_chk_en(strt_chk_en),
  .strt_glitch(strt_glitch),
  .sampled_bit(sampled_bit)
  
  );
// port mapping for stop_bit_Chk unit
  stop_chk U0_stop_chk_UINT (
  .CLK(CLK),
  .RST(RST),
  .stp_chk_en(stp_chk_en),
  .stp_err(stp_err),
  .sampled_bit(sampled_bit),
  .STP_ERR(STP_ERR)
  
  );

  
  
  
endmodule