/*
   ******  edge_bit_counter Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module edge_bit_count
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        enable,
    output reg      [3:0]              bit_cnt,
    output reg      [3:0]              edge_cnt

);
//internal signal

wire       bit_count,edge_count;     

// seq always block for count number of bits

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        bit_cnt      <= 1'b1;
        end
   else if (enable)
        begin
        if(!bit_count && edge_count)
        begin
        bit_cnt <= bit_cnt + 1'b1;
        end
        else if (bit_count && edge_count)
        begin
        bit_cnt <= 'b1 ;
        end
        end 
     else if (!enable) 
        bit_cnt <= 1'b1;       
  end

// seq always block for count number of edges

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        edge_cnt     <= 1'b1;
        end
   else if (enable)
        begin
        if(!edge_count)
        begin
        edge_cnt <= edge_cnt + 1'b1;
        end
        else if (edge_count)
        begin
        edge_cnt <= 'b1;
        end
        end
     else if (!enable)
     edge_cnt <=1'b1;   
  end  

// edge_max_flag  &&  bit_max_flag

assign edge_count = (edge_cnt == 4'b1000) ? 1'b1 : 1'b0 ;
assign bit_count  = (bit_cnt  == 4'b1011) ? 1'b1 : 1'b0 ;
endmodule