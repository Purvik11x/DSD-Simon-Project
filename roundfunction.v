`timescale 1ns/1ps
module roundfunction #(parameter N=48,M=2)  
(input [(2*N-1):0] x,
 input [(N-1):0] k,
 output [(2*N-1):0] y );
 
 wire [N-1:0] x0,x1,lr1,lr2,lr8;
 
 assign x0 = x[N-1:0];
 assign x1 = x[2*N-1:N];
 
 //xi+1=xi+1 ROund function formula for first half
 assign y[N-1:0] = x1;
 
 assign lr1 = {x1[N-2:0],x1[N-1]};
 assign lr2 = {x1[N-3:0],x1[N-1:N-2]};
 assign lr8 = {x1[N-9:0],x1[N-1:N-8]};
 
 //xi+2​=xi​⊕((S1(xi+1​)&S8(xi+1​))⊕S2(xi+1​)⊕ki​) Round function formula for second half
 assign y[2*N-1:N] = x0^(((lr1 & lr8)^lr2)^k);
  

endmodule
