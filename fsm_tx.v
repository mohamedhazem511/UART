/*
   ******  FSM Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/


//********** inputs and outputs ports decleration *************//

module FSM_TX (
  
input   wire            CLK,
input   wire            RST,
input   wire            PAR_EN,
input   wire            Data_Valid,
input   wire            ser_done,
output  reg             busy_c,
output  reg             ser_en,
output  reg  [1:0]      mux_sel

);


//********** FSM Encoding ************//

localparam      START_BIT    = 2'b00,
                STOP_BIT     = 2'b01,
                SER_DATA     = 2'b10,
                PAR_BITS     = 2'b11;
                
//********** internal signal ************//

reg  [1:0]      Current_State, Next_State,mux_sel_c;
reg             busy_in,ser_en_c;


//********** Active Low Asynchronous Rest and State transition ************//

always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
     Current_State <= STOP_BIT;
     busy_c        <= 1'b0;
     ser_en        <= 1'b0;
     mux_sel       <= STOP_BIT;
   end
  else
   begin
     Current_State <= Next_State;
     busy_c        <= busy_in;
     ser_en        <= ser_en_c;
     mux_sel       <= mux_sel_c;
   end
end

 
 //********** Next State Logic ************//
 
 
always @ (*)
  begin 
                ser_en_c = ser_en;
                busy_in  = busy_c;
                mux_sel_c = mux_sel;
                
               
    case(Current_State)
    START_BIT : begin
                mux_sel_c  = START_BIT;
                ser_en_c   = 1'b1;
                Next_State = SER_DATA;
                busy_in    = 1'b1;
                end
    SER_DATA  : begin
                if( !ser_done)
                begin
                mux_sel_c  = SER_DATA;
                Next_State = SER_DATA;
                busy_in    = 1'b1;
                ser_en_c   = ser_en;
                end
                else if(ser_done)
                begin
                Next_State = PAR_BITS;
                busy_in    = 1'b1;
                mux_sel_c  = SER_DATA;
                ser_en_c   = ser_en;
                end
                else
                begin
                busy_in    = busy_c;
                Next_State = SER_DATA;
                mux_sel_c  = SER_DATA;
                ser_en_c   = 1'b1;
                end
                end
    PAR_BITS  : begin
                if(PAR_EN)
                begin
                mux_sel_c    = PAR_BITS;
                Next_State   = STOP_BIT;
                busy_in      = 1'b1;
                ser_en_c       = 1'b0;
                end
                else if (!PAR_EN)
                begin
                mux_sel_c  = PAR_BITS;
                Next_State = STOP_BIT;
                busy_in     = 1'b1;
                ser_en_c   = 1'b0;
                end
                else
                begin
                busy_in      = busy_c;
                Next_State   = PAR_BITS;
                mux_sel_c    = PAR_BITS;
                ser_en_c     = 1'b0;
                end
                end
    STOP_BIT  : begin 
                if(Data_Valid)
                begin
                busy_in    = 1'b0;  
                Next_State = START_BIT;
                mux_sel_c  = STOP_BIT;
                ser_en_c   = 1'b0;
                end
                else
                begin
                busy_in      = 1'b0;
                ser_en_c     = 1'b0;
                mux_sel_c    = STOP_BIT;
                Next_State   = STOP_BIT;
                end
              end
     default : 
               begin
               busy_in      = 1'b0;
               ser_en_c     = 1'b0;
               mux_sel_c    = STOP_BIT;
               Next_State   = STOP_BIT;
               end         

  endcase
end
   
 endmodule              
