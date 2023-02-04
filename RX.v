/*
   ******  FSM Block ******
   by:
       Mohamed Hazem Mamdouh
       10-9-2022
       3:54 PM   
*/


//********** inputs and outputs ports decleration *************//


module CTRL_RX # (
    parameter WIDTH  = 8
    ) 
(

input   wire                       CLK,
input   wire                       RST,
input   wire    [WIDTH-1:0]        RX_P_Data,
input   wire                       RX_D_VLD,
output  reg                        ALU_EN,CLK_EN,WrEn,RdEn,clk_div_en,
output  reg     [WIDTH-1:0]        WrData,
output  reg     [3:0]              Address,ALU_FUN,
output  reg                        enable_alu,enable_reg
);


// gray state encoding
localparam   [2:0]     IDLE        = 3'b000,
                       OP_A        = 3'b001,
                       OP_B        = 3'b010,
                       alu_fun     = 3'b011,
                       wr_data     = 3'b100,
                       rd_data     = 3'b101,
                       wr_addr     = 3'b110;


reg  [2:0]             Current_State, Next_State;
			

reg                    ALU_EN_c,CLK_EN_c,WrEn_c,RdEn_c,clk_div_en_c;
reg  [WIDTH-1:0]       WrData_c;
reg     [3:0]          Address_c,ALU_FUN_c;
reg                    enable_alu_c,enable_reg_c;


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
              if((RX_P_Data == 8'hAA) && (RX_D_VLD))
			        Next_State = wr_addr ;
			        else if ((RX_P_Data == 8'hBB) && (RX_D_VLD))
			        Next_State = rd_data ; 
              else if ((RX_P_Data == 8'hCC) && (RX_D_VLD))
			        Next_State = OP_A ; 
              else if ((RX_P_Data == 8'hDD) && (RX_D_VLD))
			        Next_State = alu_fun ;
              else
              Next_State = IDLE; 			
              end

  wr_addr   : begin
              if(RX_D_VLD)
			        Next_State = wr_data;
              else
              Next_State = wr_addr;		
              end
  wr_data   : begin
              if(RX_D_VLD)
              Next_State = IDLE;
              else
              Next_State = wr_data;	
              end
  rd_data   : begin
              if(RX_D_VLD)
              Next_State = IDLE;
              else
              Next_State = rd_data;
              end
  OP_A      : begin
              if(RX_D_VLD)
              Next_State = OP_B;
              else
              Next_State = OP_A;
              end
  OP_B      : begin
              if(RX_D_VLD)
              Next_State = alu_fun;
              else
              Next_State = OP_B;
              end
  alu_fun   : begin
              if(RX_D_VLD)
              Next_State = IDLE;
              else
              Next_State = alu_fun;
              end
                          

  default   : begin
			        Next_State = IDLE ; 
              end	
  endcase                 	   
 end 

 
// output logic
always @ (*)
 begin
              ALU_EN_c     = 'b0;
              CLK_EN_c     = 'b0;
              WrEn_c       = 'b0;
              RdEn_c       = 'b0;
              clk_div_en_c = 'b1;
              WrData_c     = 'b0;
              Address_c    = 'b0;
              ALU_FUN_c    = 'b0;
              enable_alu_c = 'b0;
              enable_reg_c = 'b0;
              
  case(Current_State)
  IDLE      : begin
              ALU_EN_c     = 'b0;
              CLK_EN_c     = 'b0;
              WrEn_c       = 'b0;
              RdEn_c       = 'b0;
              clk_div_en_c = 'b1;
              WrData_c     = 'b0;
              Address_c    = 'b0;
              ALU_FUN_c    = 'b0;
              enable_alu_c = 'b0;
              enable_reg_c = 'b0;
              end
  wr_addr   : begin
              if(RX_D_VLD)
              begin
              Address_c = RX_P_Data[3:0];
			        end
              else
              Address_c    = 'b0;
              end
  wr_data   : begin
              if(RX_D_VLD)
              begin
              WrEn_c    = 1'b1;
              Address_c = Address;
              WrData_c  = RX_P_Data;
              enable_reg_c = 1'b1;
              end
              else
              Address_c = RX_P_Data[3:0];
              end
  rd_data   : begin
              if(RX_D_VLD)
              begin
              RdEn_c    = 1'b1;
              Address_c = RX_P_Data;
              enable_reg_c = 1'b1;
              end
              else
              Address_c    = 'b0;
              end
  OP_A      : begin
              if(RX_D_VLD)
              begin
              Address_c = 'b0000;
              WrEn_c    = 1'b1;
              WrData_c  = RX_P_Data;
              end
              else
              Address_c = 'b0;
              end
  OP_B      : begin
              if(RX_D_VLD)
              begin
              Address_c = 'b0001;
              WrEn_c    = 1'b1;
              WrData_c  = RX_P_Data;
              end
              else
              Address_c = 'b0;
              end
  alu_fun   : begin
              CLK_EN_c  = 1'b1;
              if(RX_D_VLD)
              begin
              Address_c    = 'b0;
              ALU_EN_c     = 1'b1;
              ALU_FUN_c    = RX_P_Data;
              enable_alu_c = 1'b1;
              end
              else
              Address_c    = 'b0;
              end                        
  default:    begin
              ALU_EN_c     = 'b0;
              CLK_EN_c     = 'b0;
              WrEn_c       = 'b0;
              RdEn_c       = 'b0;
              clk_div_en_c = 'b1;
              WrData_c     = 'b0;
              Address_c    = 'b0;
              ALU_FUN_c    = 'b0;		
              end	
  endcase         	                       	              
 end 
 
 

//register output 
always @ (posedge CLK or negedge RST)

  begin
  if(!RST)
   begin
    ALU_EN      <= 0;
    CLK_EN      <= 0;
    WrEn        <= 0;
    RdEn        <= 0;
    clk_div_en  <= 0;
    WrData      <= 0;
    Address     <= 0;
    ALU_FUN     <= 0;
    enable_alu  <= 0;
    enable_reg  <= 0;
   end
  else
   begin
    ALU_EN      <= ALU_EN_c;
    CLK_EN      <= CLK_EN_c;
    WrEn        <= WrEn_c;
    RdEn        <= RdEn_c;
    clk_div_en  <= clk_div_en_c;
    WrData      <= WrData_c;
    Address     <= Address_c;
    ALU_FUN     <= ALU_FUN_c;
    enable_alu  <= enable_alu_c;
    enable_reg  <= enable_reg_c;
    
   end
 end


endmodule   