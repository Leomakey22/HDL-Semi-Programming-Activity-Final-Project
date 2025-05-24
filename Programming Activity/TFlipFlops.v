// T Flip-Flop module
module t_flip_flop (
    input clk,
    input t,
    input reset, // Added reset signal
    output reg q
);

    // Use non-blocking assignment for sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0; // Reset to 0
        end else begin
            if (t) begin
                q <= ~q; // Toggle if t is high
            end else begin
                q <= q; // Keep the same state if t is low
            end
        end
    end

endmodule

// Testbench for the T Flip-Flop
module t_flip_flop_tb;

    // Declare signals
    reg clk, t, reset;
    wire q;

    // Instantiate the T flip-flop
    t_flip_flop tff (
        .clk(clk),
        .t(t),
        .reset(reset),
        .q(q)
    );

    // Generate clock signal
    always #5 clk = ~clk; // Toggle clock every 5 time units

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        t = 0;
        reset = 1; // Initialize reset to 1

        // Dump waveforms for GTKWave
        $dumpfile("t_flip_flop.vcd");
        $dumpvars(0, t_flip_flop_tb);

        // Apply stimulus with reset
        #10 reset = 0;  // Take reset low after 10 ns
        #20 t = 1;      // t = 1 (toggle) at 20 ns
        #20 t = 0;      // t = 0 (no change) at 40 ns
        #20 t = 1;      // t = 1 (toggle) at 60 ns
        #20 t = 0;      // t = 0 (no change) at 80 ns
        #20 t = 1;      // t = 1 (toggle) at 100 ns
        #20 reset = 1; // Assert reset again
        #10 $finish;    // Finish simulation
    end

endmodule
