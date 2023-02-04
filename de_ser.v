/*
   ******  deserializer Check Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module DE_SER # (
    parameter BUS_WIDTH =  8
    )
(
    input  wire                            CLK,
    input  wire                            RST,
    input  wire                            deser_en,
    input  wire           [3:0]            edge_cnt,
    input  wire                            sampled_bit,
    output reg         [BUS_WIDTH-1:0]     P_DATA

);

//internal signal
 reg   [BUS_WIDTH-1:0]  count;
// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        P_DATA  <= 'b0;
        count   <= 'b0;
        end   
   else if ((deser_en) && (edge_cnt == 'b101) && (count != 'b111))
        begin
        P_DATA[count] <= sampled_bit;
        count         <= count + 1'b1;
        end
   else if ( deser_en &&  count == 'b111 ) 
        begin 
        P_DATA[count] <= sampled_bit;
        end           
   else if ( !deser_en ) 
        begin 
        count  <= 'b0;
        P_DATA <=P_DATA;
        end 
      end 
      
  

endmodule

