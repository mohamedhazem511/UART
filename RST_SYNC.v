/*
   ******  BIT SYNC Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/

module RST_SYNC # (
    parameter NUM_STAGES = 2
    )
(
    input  wire                 CLK,
    input  wire                 RST,
    output wire                 SYNC_RST

);



// memory with width of bus_width and depth of num_stages

reg  [NUM_STAGES-1:0] MEM ;

// seq always block

always@(posedge CLK or negedge RST )
  begin
    if(!RST)
    begin
    MEM <= 'b0;
    end
    else
    begin
	  MEM <= {MEM[NUM_STAGES-2:0],1'b1} ;
    end   
  end

  assign SYNC_RST = MEM[NUM_STAGES-1] ;
  
endmodule
