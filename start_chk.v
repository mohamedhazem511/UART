/*
   ******  START Bit Check Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module start_chk # (
    parameter BUS_WIDTH =  8
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        strt_chk_en,
    input  wire                        sampled_bit,
    output reg                         strt_glitch

);



// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        strt_glitch   <= 0;
        end

   else if (strt_chk_en)
        begin
        if (!sampled_bit)
        begin
        strt_glitch  <= 1'b0;
        end
        else if(sampled_bit)
        begin
        strt_glitch  <= 1'b1;
        end
        end
    else if (!strt_chk_en)
        strt_glitch  <= 1'b0;         
end

endmodule