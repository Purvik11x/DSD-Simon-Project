`timescale 1ns/1ps

module roundfunction_tb;

  // Parameters
  parameter N = 48;
  parameter M = 2;

  // Testbench signals
  reg  [(2*N-1):0] x;
  reg  [(N-1):0]   k;
  wire [(2*N-1):0] y;

  // Instantiate DUT
  roundfunction #(N, M) dut (
    .x(x),
    .k(k),
    .y(y)
  );

  // Test procedure
  initial begin
    $display("==========================================");
    $display("      SIMON ROUND FUNCTION TESTBENCH      ");
    $display("==========================================");
    $dumpfile("roundfunction_tb.vcd");
    

    // Test 1
    x = 96'h00000000000000000000; // both halves 0
    k = 48'h000000000000;
    #10;
    $display("T1: x=%h k=%h -> y=%h", x, k, y);

    // Test 2
    x = 96'h00000000000000000001;
    k = 48'h000000000001;
    #10;
    $display("T2: x=%h k=%h -> y=%h", x, k, y);

    // Test 3
    x = 96'hFFFFFFFFFFFFFFFFFFFF; // all 1s
    k = 48'hFFFFFFFFFFFF;
    #10;
    $display("T3: x=%h k=%h -> y=%h", x, k, y);

    // Test 4
    x = 96'h123456789ABCDEF01234;
    k = 48'h111111111111;
    #10;
    $display("T4: x=%h k=%h -> y=%h", x, k, y);

    // Test 5 - Randomized inputs
    repeat (5) begin
      x = $random;
      x = {x, $random}; // fill both halves
      k = $random;
      #10;
      $display("RND: x=%h k=%h -> y=%h", x, k, y);
    end

    $display("==========================================");
    $display("        TESTBENCH COMPLETED SUCCESSFULLY  ");
    $display("==========================================");
    $finish;
  end

endmodule