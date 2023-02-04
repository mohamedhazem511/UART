/*
   ******  data sampling Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module data_sampling # (
   // parameter BUS_WIDTH =  8,
   // parameter Oversampling = 8
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        dat_samp_en,
    input  wire          [3:0]         edge_cnt,
    input  wire                        RX_IN,
    input  wire          [4:0]         Prescale,
    output reg                         sampled_bit

);

// internal signal


reg   [2:0]            samp_reg;
wire  [4:0]            less_edge,equ_edge,gre_edge;
wire                   OUT;

// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        sampled_bit  <= 0;
        samp_reg     <= 0;
        end

   else if (dat_samp_en)
        begin
        if (edge_cnt == less_edge)
        begin
        samp_reg [0]  <= RX_IN;
        end
        else if (edge_cnt == equ_edge)
        begin
        samp_reg [1]  <= RX_IN;
        end
        else if (edge_cnt == gre_edge)
        begin
        samp_reg [2] <= RX_IN;
        sampled_bit <= OUT;
        end
       /* else if (edge_cnt == gre_edge+ 1'b1 )
        begin
        sampled_bit <= OUT;
        end*/
        end
  end  


assign less_edge = ((Prescale >>1) - 1'b1);
assign equ_edge  = ((Prescale >>1));
assign gre_edge  = ((Prescale >>1) + 1'b1);
assign OUT       = ((samp_reg[0] && samp_reg[1]) || (samp_reg[0] && samp_reg[2]) || (samp_reg[1] && samp_reg[2])) ?  1'b1 : 1'b0; 
endmodule