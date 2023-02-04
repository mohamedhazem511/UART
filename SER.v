/*
   ******  serializer Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module SER # (
    parameter BUS_WIDTH =  8
    
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        ser_en,
    input  wire  [BUS_WIDTH-1:0]       P_DATA,
    output reg                         ser_done,
    output reg                         ser_data

);

// memory with width of bus_width 

reg   [BUS_WIDTH-1:0]    Count,REG; 
wire   Counter ;


// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        ser_data  <= 0;
        ser_done  <= 0;
        REG       <= 0;
        Count     <= 'b0;
        end   
   else if (ser_en)
        begin
        REG  <= P_DATA;
        if(!Counter)
        begin
        ser_data  <= REG[Count];
        Count     <= Count + 'b1;
        end
        else if (Counter)
        begin
        ser_data  <= REG[Count];
        ser_done  <= Counter;
        end
        end
   else if (!ser_en)
        begin
        ser_data  <= 0;
        ser_done  <= 0;
        REG       <= 'b0;
        Count     <= 'b0;
        end         
        end
assign Counter =(Count == BUS_WIDTH-1) ? 1'b1 : 1'b0;
endmodule