/*
   ******  FSM Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/


//********** inputs and outputs ports decleration *************//


module CTRL_TX # (
    parameter WIDTH  = 8
    ) 
(

input   wire                       CLK,
input   wire                       RST,
input   wire    [WIDTH-1:0]        RdData,
input   wire    [15:0]             ALU_OUT,                   
input   wire                       OUT_Valid,Busy,RdData_Valid,enable_alu,enable_reg,
output  reg     [WIDTH-1:0]        TX_P_DATA,
output  reg                        TX_D_VLD

);


// gray state encoding
localparam  [1:0]      IDLE          = 2'b00,
                       alu_data_1    = 2'b01,
                       alu_data_2    = 2'b11,
                       reg_data      = 2'b10;


reg  [1:0]             Current_State, Next_State;
			

reg                    TX_D_VLD_c;
reg  [WIDTH-1:0]       TX_P_DATA_c;



//state transiton 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    Current_State <= IDLE ;
   end
  else
   begin
    Current_State <= Next_State ;
   end
 end
 

// next state logic
always @ (*)
 begin
  case(Current_State)
  IDLE      : begin
              if(enable_alu)
              begin
			        Next_State = alu_data_1;
              TX_D_VLD_c  = 'b0;
              TX_P_DATA_c = TX_P_DATA;
              end
              else if (enable_reg)
              begin
              Next_State = reg_data;
              TX_D_VLD_c  = 'b0;
              TX_P_DATA_c = TX_P_DATA;
              end
              else if (Busy)
              begin
              Next_State = IDLE;
              TX_D_VLD_c  = 0;	
              TX_P_DATA_c = TX_P_DATA;
              end
              else 
              begin
              Next_State = IDLE;
              TX_D_VLD_c  = TX_D_VLD;	
              TX_P_DATA_c = TX_P_DATA;
              end		
              end

  alu_data_1: begin
              if(OUT_Valid && !Busy)
              begin
			        Next_State = alu_data_1;
              TX_D_VLD_c  = 'b1;
              TX_P_DATA_c = ALU_OUT[7:0];
              end
              else if (Busy)
              begin
              TX_P_DATA_c = TX_P_DATA;
              TX_D_VLD_c  = 0;
              Next_State  = alu_data_2;
              end
              else
              begin
              Next_State  = alu_data_1;
              TX_D_VLD_c  = TX_D_VLD;	
              TX_P_DATA_c = TX_P_DATA;	
              end
              end

  alu_data_2: begin
              if(!Busy)
              begin
			        Next_State = IDLE;
              TX_D_VLD_c  = 'b1;
              TX_P_DATA_c = ALU_OUT[15:8];
              end
              /*else if (Busy)
              begin
              TX_P_DATA_c = TX_P_DATA;
              TX_D_VLD_c  = 0;
              Next_State  = IDLE;
              end*/
              else
              begin
              Next_State  = alu_data_2;
              TX_D_VLD_c  = TX_D_VLD;	
              TX_P_DATA_c = TX_P_DATA;	
              end		
              end            
  reg_data  : begin
              if(RdData_Valid && !Busy)
              begin
              Next_State = IDLE;
              TX_P_DATA_c = RdData;
              TX_D_VLD_c  = 'b1;
              end
              else
              begin
              Next_State = reg_data;
              TX_P_DATA_c = 0;
              TX_D_VLD_c  = 'b0;	
              end
              end

  default   : begin
			        Next_State = IDLE ;
              TX_D_VLD_c  = 'b0;	
              TX_P_DATA_c = 'b0;	 
              end	
  endcase                 	   
 end 


 
 

//register output 
always @ (posedge CLK or negedge RST)

  begin
  if(!RST)
   begin
    TX_D_VLD    <= 'b0;
    TX_P_DATA   <= 'b0;
   end
  else
   begin
    TX_D_VLD    <= TX_D_VLD_c;
    TX_P_DATA   <= TX_P_DATA_c;
    
   end
 end
  

endmodule   
