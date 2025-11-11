 module tb_simon_cipher_algorithm;
    
        parameter N = 48;
        parameter M = 2;
    
        reg  [(2*N-1):0] x;
        reg  [(N*M-1):0] key;
        reg  [6:0]       round;
        wire [(2*N-1):0] y;
    
        // Instantiate the SIMON Ciphers
        simon_cipher_algorithm #(N, M) dut (
            .x(x),
            .key(key),
            .round(round),
            .y(y)
        );
    
        initial begin
            $dumpfile("simon_cipher_wave.vcd");
            $dumpvars(0, tb_simon_cipher_algorithm);
    
            $monitor("Time=%0t | Round=%0d | key_i=%h | Input=%h | Output=%h", 
                     $time, round, dut.key_i, x, y);
            
            // Example inputs
            x   = 96'h0123_4567_89AB_CDEF_1234_5678;
            key = 96'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF;
    
            // Run through a few rounds
            for (round = 0; round < 5; round = round + 1)
                #10;
    
            $finish;
        end
    
    endmodule
