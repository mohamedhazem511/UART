/*
   ******  FSM Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/


//********** inputs and outputs ports decleration *************//


module FSM_RX  (

input   wire            CLK,
input   wire            RST,
input   wire            PAR_EN,
input   wire            RX_IN,
input   wire    [3:0]   bit_cnt,edge_cnt,
input   wire            par_err,strt_glitch,stp_err,
output  reg             dat_samp_en,enable,deser_en,
output  reg             par_chk_en,strt_chk_en,stp_chk_en,
output  reg             Data_Valid
);


// gray state encoding
parameter   [2:0]      START_BIT    = 3'b000,
                       STOP_BIT     = 3'b001,
                       SER_DATA     = 3'b011,
                       PAR_BITS     = 3'b010,
                       IDLE         = 3'b100;

reg                    data_valid_c;
reg  [2:0]             Current_State, Next_State;
			

reg                    par_chk_en_c,strt_chk_en_c,stp_chk_en_c,dat_samp_en_c,enable_c,deser_en_c;
			
//state transiton 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    Current_State <= IDLE ;
   end
  else
   begin
    Current_State <= Next_State ;
   end
 end
 

// next state logic
always @ (*)
 begin
  case(Current_State)
  IDLE      : begin
              if(!RX_IN)
			        Next_State = START_BIT ;
			        else
			        Next_State= IDLE ; 			
              end
  START_BIT : begin
              Next_State = START_BIT;
			        if(!strt_glitch && (bit_cnt == 'b1) && (edge_cnt == 'b111))
			        Next_State = SER_DATA;
			        else if(strt_glitch && (bit_cnt == 'b1) && (edge_cnt == 'b111))
			        Next_State = IDLE ; 			
              end
  SER_DATA  : begin
              Next_State = SER_DATA;
              if((bit_cnt == 'b1001)  && (edge_cnt == 'b111)&& (PAR_EN))
              begin
              Next_State  = PAR_BITS;
              end
              else if((bit_cnt == 'b1001)  && (edge_cnt == 'b111) && (!PAR_EN))
              begin
              Next_State  = STOP_BIT;
              end
              end
  PAR_BITS  : begin
              Next_State = PAR_BITS;
			        if( !par_err && (bit_cnt == 'b1010) && (edge_cnt == 'b111))
              begin
              Next_State  = STOP_BIT;
              end
              else if ( par_err && (bit_cnt == 'b1010) && (edge_cnt == 'b111))
              Next_State  = IDLE;
              end
  STOP_BIT  : begin
              Next_State = STOP_BIT;
              if((bit_cnt == 'b1011) && (edge_cnt == 'b1000))
              begin
			        Next_State = IDLE ;
              end
              end	
  default   : begin
			        Next_State = IDLE ; 
              end	
  endcase                 	   
 end 

 
// output logic
always @ (*)
 begin
              enable_c       = enable;
              dat_samp_en_c  = 1'b0;
              strt_chk_en_c  = 1'b0;
              par_chk_en_c   = 1'b0;
              stp_chk_en_c   = 1'b0;
              deser_en_c     = 1'b0;
              data_valid_c   = 1'b0;	
  case(Current_State)
  IDLE      : begin
              if(RX_IN)
              begin
              enable_c       = 1'b0;
              dat_samp_en_c  = 1'b0;
              strt_chk_en_c  = 1'b0;
              par_chk_en_c   = 1'b0;
              stp_chk_en_c   = 1'b0;
              deser_en_c     = 1'b0;
              data_valid_c   = 1'b0;								
              end
              end
  START_BIT : begin
              enable_c      = 1'b1;
              dat_samp_en_c = 1'b1;
              deser_en_c    = 1'b0;
              if(edge_cnt == 'b101)
              begin 
              strt_chk_en_c = 1'b1;	
              end
              else if (edge_cnt == 'b110)
              begin
              strt_chk_en_c = 1'b0;
              end
              end
  SER_DATA  : begin
              enable_c      = 1'b1;
              dat_samp_en_c = 1'b1;
              deser_en_c    = 1'b1; 
             /* if( (bit_cnt == 'b10) && (edge_cnt == 'b101))
              begin
              deser_en_c    = 1'b1;
              end
              if( (bit_cnt == 'b1001) && (edge_cnt == 'b110))
              begin
              deser_en_c    = 1'b0;
              end*/
              end
  PAR_BITS  : begin
              enable_c      = 1'b1;
              dat_samp_en_c = 1'b1;
              deser_en_c    = 1'b0;
              if(edge_cnt == 'b101)
              begin 
              par_chk_en_c = 1'b1;	
              end
              else if (edge_cnt == 'b110)
              begin
              par_chk_en_c = 1'b0;
              end
              end
  STOP_BIT  : begin
              enable_c      = 1'b1;
              dat_samp_en_c = 1'b1;
              deser_en_c    = 1'b0;
              if((bit_cnt == 'b1011) && (edge_cnt == 'b101))
              begin 
              stp_chk_en_c = 1'b1;
              end
              else if(!stp_err && (bit_cnt == 'b1011) && (edge_cnt == 'b111) )
              begin
              data_valid_c = 1'b1;
              end
              else if(stp_err && (bit_cnt == 'b1011) && (edge_cnt == 'b111))
              begin
              data_valid_c = 1'b0;
              end
              end
  default:    begin
              enable_c       = 1'b0;
              dat_samp_en_c  = 1'b0;
              strt_chk_en_c  = 1'b0;
              par_chk_en_c   = 1'b0;
              stp_chk_en_c   = 1'b0;
              deser_en_c     = 1'b0;
              data_valid_c   = 1'b0;		
              end	
  endcase         	              
 end 
 
 

//register output 
always @ (posedge CLK or negedge RST)

  begin
  if(!RST)
   begin
    Data_Valid  <= 1'b0;
    dat_samp_en <= 1'b0;
    enable      <= 1'b0;
    deser_en    <= 1'b0;
    par_chk_en  <= 1'b0;
    strt_chk_en <= 1'b0;
    stp_chk_en  <= 1'b0;
   end
  else
   begin
    Data_Valid  <= data_valid_c;
    dat_samp_en <= dat_samp_en_c;
    enable      <= enable_c;
    deser_en    <= deser_en_c;
    par_chk_en  <= par_chk_en_c;
    strt_chk_en <= strt_chk_en_c;
    stp_chk_en  <= stp_chk_en_c;
    
   end
 end
  

endmodule   
