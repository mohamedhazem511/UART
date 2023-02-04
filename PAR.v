/*
   ******  PAR CALC Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module PAR # (
    parameter BUS_WIDTH =  8
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        Data_Valid,
    input  wire                        PAR_TYP,
    input  wire  [BUS_WIDTH-1:0]       P_DATA,
    output reg                         PAR_BIT

);


// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        PAR_BIT   <= 0;
        end   
   else if ( Data_Valid )
        begin            
        if (PAR_TYP)                    //    odd parity
        begin
        PAR_BIT <=  ~^P_DATA ;
        end
        else                 //   even parity
        begin
        PAR_BIT <= (^P_DATA);
        end
        end
              
      end    

endmodule