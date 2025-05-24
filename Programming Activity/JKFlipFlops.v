// JK Flip-Flop module
module jk_flip_flop (
    input clk,     // Clock input
    input j,       // J input
    input k,       // K input
    input reset_n, // Active-low reset
    output reg q,  // Q output
    output reg q_bar // Q_bar output
);

    // Use an always block to define sequential behavior
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin // If reset_n is low, reset the flip-flop
            q <= 1'b0;
            q_bar <= 1'b1;
        end else begin
            case ({j, k})
                2'b00: begin // J=0, K=0: No change
                    q <= q;
                    q_bar <= q_bar;
                end
                2'b01: begin // J=0, K=1: Reset
                    q <= 1'b0;
                    q_bar <= 1'b1;
                end
                2'b10: begin // J=1, K=0: Set
                    q <= 1'b1;
                    q_bar <= 1'b0;
                end
                2'b11: begin // J=1, K=1: Toggle
                    q <= ~q;
                    q_bar <= ~q_bar;
                end
            endcase
        end
    end

endmodule

// Testbench module
module jk_flip_flop_tb;
    // Declare signals for the testbench
    reg clk;
    reg j;
    reg k;
    reg reset_n;
    wire q;
    wire q_bar;

    // Instantiate the JK flip-flop
    jk_flip_flop uut (
        .clk(clk),
        .j(j),
        .k(k),
        .reset_n(reset_n),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate a clock signal
    always #5 clk = ~clk; // Toggle clock every 5 time units

    // Initialize signals and apply stimulus
    initial begin
        // Initialize all signals
        clk = 1'b0;
        j = 1'b0;
        k = 1'b0;
        reset_n = 1'b0; // Start with reset active

        // Dump waveforms for GTKWave
        $dumpfile("flipflop.vcd");  // Specify the VCD file name
        $dumpvars(0, jk_flip_flop_tb); // Dump all signals in the testbench

        // Apply a reset pulse
        #10 reset_n = 1'b1; // Deactivate reset after 10 time units

        // Apply different J and K combinations
        #20 j = 1'b0; k = 1'b0; // No change
        #20 j = 1'b0; k = 1'b1; // Reset
        #20 j = 1'b1; k = 1'b0; // Set
        #20 j = 1'b1; k = 1'b1; // Toggle
        #20 j = 1'b1; k = 1'b1; // Toggle again
        #20 j = 1'b0; k = 1'b0;
        #20 j = 1'b1; k = 1'b0;
        #20 j = 1'b0; k = 1'b1;
        #20 j = 1'b1; k = 1'b1;

        #20 $finish; // End the simulation
    end

    //optional display
    initial begin
        $monitor("Time = %0t, clk = %b, j = %b, k = %b, reset_n = %b, q = %b, q_bar = %b",
                 $time, clk, j, k, reset_n, q, q_bar);
    end

endmodule
