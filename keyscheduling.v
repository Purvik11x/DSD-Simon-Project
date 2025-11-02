`timescale 1ns/1ps
module keyscheduling #(parameter N=48,M=2)  
(input [(N*M-1):0] key,
 input [6:0] i,
 output reg[(N-1):0] key_i );

reg [N-1:0] temp,rot1,rot3;
reg [7:0] index;

localparam [0:61] z_2 = 62'b10101111011100000011010010011000101000010001111110010110110011;


always@(key,i)
begin 
    if(i<M)
          key_i=key[((N*(i+1)-1)-:N)];
    else
    begin
        temp={key[2:0],key[N-1:3]};
        rot3=temp;
        rot1={rot3[0],rot3[N-1:1]};
        index = (i-M)<62? i-M: (i-M)-62;
        key_i = ~key[N-1:0] ^ temp ^ z_2[index] ^ 2'b11;
    end
end

endmodule



        
