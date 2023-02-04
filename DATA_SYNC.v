/*
   ******  BIT SYNC Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/
`timescale 1us/1ns
module DATA_SYNC # (
    parameter BUS_WIDTH  = 8,
    parameter NUM_STAGES = 2
    )
(
    input  wire                        CLK,
    input  wire                        RST,
    input  wire                        bus_enable,
    input  wire  [BUS_WIDTH-1:0]       unsync_bus,
    output reg   [BUS_WIDTH-1:0]       sync_bus,
    output reg                         enable_pulse

);


// internal signal
reg                                    enable_flop;
wire                                   Pulse_Gen;
wire        [BUS_WIDTH-1:0]            sync_bus_comp;
reg         [NUM_STAGES-1:0]           REG_en ;

//----------------- Multi flop synchronizer --------------//

always@(posedge CLK or negedge RST)

  begin
  if(!RST)
  begin
  REG_en <= 0;
  end
  else
  begin
  REG_en <= {REG_en[NUM_STAGES-2:0],bus_enable};
  end
  end
  
  //----------------- pulse generator --------------------
  
always@(posedge CLK or negedge RST)
  begin
  if(!RST)      // active low
  begin
  enable_flop <= 1'b0 ;	
  end
  else
  begin
  enable_flop <= REG_en[NUM_STAGES-1] ;
  end  
  end

  assign Pulse_Gen = REG_en[NUM_STAGES-1] && !enable_flop ;

  //----------------- multiplexing --------------------

  assign sync_bus_comp = Pulse_Gen ? unsync_bus : sync_bus ;

  //----------- destination domain flop ---------------

always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    sync_bus <= 'b0 ;	
   end
  else
   begin
    sync_bus <= sync_bus_comp ;
   end  
 end
 
//--------------- delay generated pulse ------------

always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    enable_pulse <= 1'b0 ;	
   end
  else
   begin
    enable_pulse <= Pulse_Gen ;
   end  
 end
endmodule