`timescale 1ns/1ps

module simon_96_96 (
    input               clk,
    input               rst,
    input               en,
    input  [95:0]       plaintext,     // 2*n = 96
    input  [95:0]       key,           // n*m = 48*2 = 96
    output reg [95:0]   ciphertext,
    output              done
);

    // === SIMON 96/96 CONSTANTS ===
    localparam N = 48;          // word size
    localparam M = 2;           // key words
    localparam ROUNDS = 52;     // rounds for SIMON-96/96

    // === FSM STATES ===
    localparam S_IDLE   = 2'b00;
    localparam S_ENABLE = 2'b01;
    localparam S_BUSY   = 2'b10;
    localparam S_DONE   = 2'b11;

    reg [1:0]  state, next_state;
    reg [7:0]  round_cnt, next_round_cnt;

    reg  [95:0] x;          // current block state
    wire [95:0] y;          // next state from round function
    wire [47:0] key_i;      // generated key for this round

    // key schedule memory
    reg [47:0] key_schedule [0:ROUNDS-1];

    // === Instantiate your modules ===
    roundfunction #(N, M) RF (
        .x(x),
        .k(key_i),
        .y(y)
    );

    // "key" or 2 previous subkeys fed based on round_cnt
    wire [95:0] key_feed = (round_cnt < M) ?
                            key :
                            { key_schedule[round_cnt],
                              key_schedule[round_cnt-1] };

    keyscheduling #(N, M) KS (
        .key(key_feed),
        .i(round_cnt),
        .key_i(key_i)
    );

    // === OUTPUT KEY selection ===
    wire [47:0] k_selected =
        (round_cnt < M) ?
        key[(round_cnt+1)*N-1 -: N] :     // Extract initial words
        key_schedule[round_cnt];          // Use computed subkeys

    // === NEXT COUNTER ===
    assign next_round_cnt =
        (state == S_ENABLE) ? 0 :
        (state == S_BUSY)   ? round_cnt + 1 :
                              round_cnt;

    // === NEXT STATE LOGIC ===
    assign next_state =
        rst               ? S_IDLE :
        en                ? S_ENABLE :
        (state == S_ENABLE) ? S_BUSY :
        (state == S_BUSY && round_cnt < (ROUNDS-1)) ? S_BUSY :
        (state == S_BUSY && round_cnt == (ROUNDS-1)) ? S_DONE :
        (state == S_DONE) ? S_DONE :
                            S_IDLE;

    assign done = (state == S_DONE);

    // === NEXT BLOCK STATE ===
    wire [95:0] next_x =
        (state == S_ENABLE) ? plaintext :
        y;

    // === NEXT CIPHERTEXT ===
    wire [95:0] next_ciphertext =
        (en == 1) ? 0 :
        (state == S_BUSY && next_state == S_DONE) ? y :
        ciphertext;

    // === SEQUENTIAL BLOCK ===
    always @(posedge clk) begin
        if (rst) begin
            state        <= S_IDLE;
            round_cnt    <= 0;
            x            <= 0;
            ciphertext   <= 0;
        end
        else begin
            state        <= next_state;
            round_cnt    <= next_round_cnt;
            x            <= next_x;
            ciphertext   <= next_ciphertext;

            // store generated keys
            if (state == S_ENABLE)
                key_schedule[0] <= key[47:0];
            else if (state == S_BUSY)
                key_schedule[next_round_cnt] <= key_i;
        end
    end

endmodule

