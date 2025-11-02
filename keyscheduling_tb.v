`timescale 1ns/1ps

module tb_keyscheduling;

  parameter N = 48;
  parameter M = 2;

  reg [(N*M-1):0] key;
  reg [6:0] i;
  wire [(N-1):0] key_i;

  // Instantiate DUT
  keyscheduling #(N, M) uut (
    .key(key),
    .i(i),
    .key_i(key_i)
  );

  // Expected key outputs for comparison
  // These are dummy expected values — replace them with correct ones later
  reg [(N-1):0] expected_keys [0:9];

  integer j;
  integer errors = 0;

  initial begin
    // ------------------------------------------------------------
    $display("------------------------------------------------------------");
    $display("SIMON Key Scheduling Testbench (N=%0d, M=%0d)", N, M);
    $display("------------------------------------------------------------");
    $display("Time(ns)\ti\tkey_i (hex)\tExpected (hex)\tResult");
    $display("------------------------------------------------------------");

    // Initialize test key
    key = {48'h1211100A09, 48'h08020100E0};

    // ------------------------------------------------------------
    // Expected key outputs for i = 0..9
    // NOTE: Replace these with correct expected values from known test vectors
    expected_keys[0] = 48'h0008020100E0;
    expected_keys[1] = 48'h001211100A09;
    expected_keys[2] = 48'hFFF6FDBEDF01;
    expected_keys[3] = 48'hFFF6FDBEDF00;
    expected_keys[4] = 48'hFFF6FDBEDF01;
    expected_keys[5] = 48'hFFF6FDBEDF00;
    expected_keys[6] = 48'hFFF6FDBEDF01;
    expected_keys[7] = 48'hFFF6FDBEDF01;
    expected_keys[8] = 48'hFFF6FDBEDF01;
    expected_keys[9] = 48'hFFF6FDBEDF01;

    // ------------------------------------------------------------
    // Run test loop
    for (i = 0; i < 10; i = i + 1) begin
      #10; // Wait 10ns between iterations
      if (key_i === expected_keys[i]) begin
        $display("%0dns\t%0d\t%h\t%h\tPASS", $time, i, key_i, expected_keys[i]);
      end else begin
        $display("%0dns\t%0d\t%h\t%h\tFAIL", $time, i, key_i, expected_keys[i]);
        errors = errors + 1;
      end
    end

    // ------------------------------------------------------------
    // Final report
    $display("------------------------------------------------------------");
    if (errors == 0)
      $display("✅ All test cases PASSED!");
    else
      $display("❌ %0d test cases FAILED.", errors);

    $display("------------------------------------------------------------");
    $finish;
  end

endmodule


