module counter4 (
    input wire clk,        // Clock input
    input wire nReset,     // Active-low asynchronous reset
    input wire nE,         // Active-low enable
    input wire cntby2,     // Increment-by-2 enable
    output reg [3:0] count // 4-bit counter output
);

  // Asynchronous reset: The counter is reset regardless of the clock.
  always @(posedge clk or negedge nReset) begin
    if (~nReset) begin
      count <= 4'b0000; // Reset the counter to 0
    end else if (~nE) begin // Check enable: Only count if nE is low
      if (cntby2) begin
        count <= count + 2'b10; // Increment by 2
      end else begin
        count <= count + 1'b1;  // Increment by 1
      end
    end 
  end

endmodule

// Testbench Module
module counter4_tb;

  // Declare signals for the testbench
  reg clk;
  reg nReset;
  reg nE;
  reg cntby2;
  wire [3:0] count;

  // Instantiate the counter4 module
  counter4 dut (
    .clk(clk),
    .nReset(nReset),
    .nE(nE),
    .cntby2(cntby2),
    .count(count)
  );

  // Generate a clock signal
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Toggle clock every 5 time units (period = 10)
  end

  // Apply reset, enable, and cntby2 signals
  initial begin
    nReset = 0; // Assert reset 
    nE     = 1;
    cntby2 = 0;
    #10;
    nReset = 1; // Deassert reset
    #20;

    nE = 0;     // Enable the counter
    #40;
    cntby2 = 1;  // Test increment by 2
    #40;
    cntby2 = 0;  // Test increment by 1
    #40;
    nE = 1;     // Disable the counter
    #20;
    nReset = 0;  // Test reset again
    #10;
    nReset = 1;
    #20;
    $finish;
  end

  // Dump signals for waveform viewing in GTKWave
  initial begin
    $dumpfile("counter4.vcd");
    $dumpvars(0, counter4_tb);
  end

endmodule
