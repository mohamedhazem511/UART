/*
   ******  BIT SYNC Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module BIT_SYNC # (
    parameter BUS_WIDTH = 1,
    parameter NUM_STAGES = 2
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire  [BUS_WIDTH-1:0]       ASYNC,
    output reg   [BUS_WIDTH-1:0]       SYNC

);


// integer parameter

integer N ;

// memory with width of bus_width and depth of num_stages

reg   [BUS_WIDTH-1:0]       MEM  [NUM_STAGES-1:0];

// seq always block

always@(posedge CLK or negedge RST)
  begin
   if (!RST) 
        begin
        SYNC  <= 0;
        for(N=0 ; N <NUM_STAGES ; N = N+1)
        begin
        MEM[N] <= 0;
        end
        end   
   else 
	    begin
	    MEM[0] <= ASYNC;  
        for(N=0 ; N <NUM_STAGES-1 ; N = N+1)
        begin
        MEM[N+1] <= MEM[N];
        end
        SYNC   <= MEM[NUM_STAGES-1] ;
        end
  end
endmodule