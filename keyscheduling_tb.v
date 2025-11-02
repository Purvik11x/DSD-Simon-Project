`timescale 1ns/1ps

module tb_keyscheduling;

  parameter N = 48;
  parameter M = 2;

  reg [(N*M-1):0] key;
  reg [6:0] i;

  wire [(N-1):0] key_i;

 
  keyscheduling #(N, M) uut (
    .key(key),
    .i(i),
    .key_i(key_i)
  );

    initial begin
 
    $display("SIMON Key Scheduling Testbench (N=%0d, M=%0d)", N, M);
  
    $display("Time(ns)\ti\tkey_i (hex)");
   

    key = {48'h1211100A09, 48'h08020100E0};

    for (i = 0; i < 10; i = i + 1) begin
      #10; // Wait 10ns between iterations
      $display("%0dns\t%0d\t%h", $time, i, key_i);
    end

    $finish;
  end

endmodule
