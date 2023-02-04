/*
   ****** Clock Divider Block ******
   by:
       Mohamed Hazem Mamdouh
       7-9-2022
       12:54 PM   
*/
// port list of clock divider module
module CLK_DIV(
    input       wire           RST ,
    input       wire           CLK ,
    input       wire           CLK_EN,
    input       wire  [4:0]    DIV_RATIO ,
    output      wire           DIV_CLK
);

// internal signal

reg  [4:0]      Count;
reg             Flag,DIV_CLK1;
wire [4:0]      H,L ;
wire            LSB,CLK_Enable;

// sequential always block

always @(posedge CLK or negedge RST)
   begin
// check rset the block or not 
    if(!RST)
        begin
        DIV_CLK1 <= 0 ;
        Count    <= 5'b00000 ;
        Flag     <= 0 ;
        end
// check if even number or not and the counter is reach the required value or not then Toggle 
    else if ( (L != Count) && CLK_EN && !LSB)  
        begin
        Count    <= Count + 5'b00001;
        end
    else if ( (L == Count) && CLK_EN && !LSB ) 
        begin
        DIV_CLK1 <= !DIV_CLK1;
        Count    <= 5'b00001 ;
        end
// check if odd number or not and the counter is reach the required value or not then Toggle       
    else if (( (Count != H) &&  Flag)||((Count != L) && !Flag) && LSB && CLK_EN)
        begin
        Count    <= Count + 5'b00001;
        end
    else if ((((Count == L) && !Flag)||((Count == H) && Flag)) && LSB && CLK_EN) 
        begin
        DIV_CLK1 <= !DIV_CLK1;
        Flag     <= !Flag;
        Count    <= 5'b00001 ;
        end     
        end    
    
// assign LSB , Low divivde Ratio , High divided Ratio and Enable flag
    
assign LSB  =  DIV_RATIO[0];
assign L    = (DIV_RATIO>>1); 
assign H    =  L + 5'b00001;
assign CLK_Enable  =(DIV_RATIO > 5'b00001) ? 1'b1 : 1'b0;

/* asssign statment to set the output of clock divider

   if not enable the clock divider or the divived ratio equal zero or one ,
   the output Clock equal the refrence Clock.
   else the output equal the divided Clock
    
*/
assign DIV_CLK     =(!CLK_EN || !CLK_Enable ) ? CLK :DIV_CLK1 ; 
endmodule
