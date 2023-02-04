/*
   ******  Stop Bit Check Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module stop_chk # (
    parameter BUS_WIDTH =  8
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        stp_chk_en,
    input  wire                        sampled_bit,
    output reg                         stp_err,
    output reg                         STP_ERR

);



// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        stp_err  <= 0;
        STP_ERR  <= 0;
        end

   else if (stp_chk_en)
        begin
        if (sampled_bit)
        begin
        stp_err  <= 1'b0;
        STP_ERR  <= 1'b0;
        end
        else if (!sampled_bit)
        begin
        stp_err  <= 1'b1;
        STP_ERR  <= 1'b1;
        end
        end
    else if (!stp_chk_en )
        begin
        stp_err  <= 1'b0;
        STP_ERR  <= 1'b0;
        end        
end
endmodule