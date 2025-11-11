`timescale 1ns/1ps

module roundfunction #(parameter N=48, M=2)  
(
    input  [(2*N-1):0] x,
    input  [(N-1):0]   k,
    output [(2*N-1):0] y
);
 
    wire [N-1:0] x0, x1, lr1, lr2, lr8;
 
    assign x0 = x[N-1:0];
    assign x1 = x[2*N-1:N];
 
    // xi+1 = xi+1 Round function formula for first half
    assign y[N-1:0] = x1;
 
    // Rotations
    assign lr1 = {x1[N-2:0], x1[N-1]};
    assign lr2 = {x1[N-3:0], x1[N-1:N-2]};
    assign lr8 = {x1[N-9:0], x1[N-1:N-8]};
 
    // xi+2 = xi ⊕ ((S1(xi+1) & S8(xi+1)) ⊕ S2(xi+1) ⊕ ki)
    assign y[2*N-1:N] = x0 ^ (((lr1 & lr8) ^ lr2) ^ k);
  
endmodule

module keyscheduling #(parameter N=48, M=2)
(
    input  [(N*M-1):0] key,
    input  [6:0]       i,
    output reg [(N-1):0] key_i
);

    reg [N-1:0] temp, rot1, rot3;
    reg [7:0] index;

    localparam [0:61] z_2 = 62'b10101111011100000011010010011000101000010001111110010110110011;

    always @(*) begin
        if (i < M)
            key_i = key[(N*(i+1)-1) -: N];   
        else begin
            temp  = {key[2:0], key[N-1:3]}; 
            rot3  = temp;
            rot1  = {rot3[0], rot3[N-1:1]};  
            index = (i-M) < 62 ? (i-M) : (i-M)-62;
            key_i = ~key[N-1:0] ^ temp ^ z_2[index] ^ 2'b11;
        end
    end

endmodule

module simon_cipher_algorithm #(parameter N=48, M=2)
(
    input  [(2*N-1):0] x,      // Input data block
    input  [(N*M-1):0] key,    // Key input (concatenated keys)
    input  [6:0]       round,  // Round index
    output [(2*N-1):0] y       // Output block after round
);

    wire [N-1:0] key_i;

    // Instantiate key scheduling
    keyscheduling #(N, M) u_keysched (
        .key(key),
        .i(round),
        .key_i(key_i)
    );

    // Instantiate round function
    roundfunction #(N, M) u_round (
        .x(x),
        .k(key_i),
        .y(y)
    );

endmodule
