/*
   ******  Parity Check Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module PAR_Chk # (
    parameter BUS_WIDTH =  8
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        par_chk_en,
    input  wire  [BUS_WIDTH-1:0]       P_DATA,
    input  wire                        sampled_bit,
    input  wire                        PAR_TYP,
    output reg                         par_err,
    output reg                         PAR_ERR
);

//internal signal

  
// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        par_err   <= 0;
        PAR_ERR   <= 0;
        end   
   else if (par_chk_en)
        begin
        if (((PAR_TYP && (^P_DATA)) || ( !PAR_TYP && (~^P_DATA))) && (!sampled_bit) )        //   cheack odd parity bit
        begin
        par_err <= 1'b0 ;
        PAR_ERR <= 1'b0 ;
        end
        else if ( ((!PAR_TYP && (^P_DATA)) || ( PAR_TYP && (~^P_DATA))) && (sampled_bit) )        //  cheack even parity bit
        begin
        par_err <= 1'b0 ;
        PAR_ERR <= 1'b0 ;
        end
        else
        begin
        par_err <= 1'b1 ;
        PAR_ERR <= 1'b1 ;
        end
        end
    else if (!par_chk_en)
    begin 
        par_err <= 1'b0 ;
        PAR_ERR <= 1'b0 ;
    end           
  end    

endmodule

