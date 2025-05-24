// combined.v
// This file contains both the binary_to_decimal module and its testbench.

// binary_to_decimal module
// This module converts a 4-bit binary input to a 7-segment display output
// and an additional LED output, incorporating sequential modeling.

module binary_to_decimal (
    input  clk,                 // Clock input for sequential logic
    input  rst_n,               // Asynchronous active-low reset
    input  [3:0] binary_in,       // 4-bit binary input (binary_in[3]=A, binary_in[2]=B, binary_in[1]=C, binary_in[0]=D)
    output reg [6:0] seven_seg_out, // 7-segment display output (seven_seg_out[6]=A, ..., seven_seg_out[0]=G)
    output reg led_out            // Additional LED output (H)
);

    // Behavioral modeling using an always block for sequential logic.
    // Outputs (seven_seg_out, led_out) are registered and update on the positive edge of the clock,
    // or asynchronously reset on the negative edge of rst_n.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin // Asynchronous active-low reset condition
            seven_seg_out <= 7'b0000000; // Reset all 7-segment segments OFF
            led_out <= 1'b0;             // Reset LED H OFF
        end else begin
            // This 'case' statement implements the combinational logic based on the truth table.
            // The results are then assigned to the output registers.
            case (binary_in)
                // Decimal 0 (Binary 0000)
                4'b0000: begin
                    seven_seg_out <= 7'b1111110; // Corresponds to '0'
                    led_out <= 1'b0;
                end
                // Decimal 1 (Binary 0001)
                4'b0001: begin
                    seven_seg_out <= 7'b0110000; // Corresponds to '1'
                    led_out <= 1'b0;
                end
                // Decimal 2 (Binary 0010)
                4'b0010: begin
                    seven_seg_out <= 7'b1101101; // Corresponds to '2'
                    led_out <= 1'b0;
                end
                // Decimal 3 (Binary 0011)
                4'b0011: begin
                    seven_seg_out <= 7'b1111001; // Corresponds to '3'
                    led_out <= 1'b0;
                end
                // Decimal 4 (Binary 0100)
                4'b0100: begin
                    seven_seg_out <= 7'b0110011; // Corresponds to '4'
                    led_out <= 1'b0;
                end
                // Decimal 5 (Binary 0101)
                4'b0101: begin
                    seven_seg_out <= 7'b1011011; // Corresponds to '5'
                    led_out <= 1'b0;
                end
                // Decimal 6 (Binary 0110)
                4'b0110: begin
                    seven_seg_out <= 7'b1011111; // Corresponds to '6'
                    led_out <= 1'b0;
                end
                // Decimal 7 (Binary 0111)
                4'b0111: begin
                    seven_seg_out <= 7'b1110000; // Corresponds to '7'
                    led_out <= 1'b0;
                end
                // Decimal 8 (Binary 1000)
                4'b1000: begin
                    seven_seg_out <= 7'b1111111; // Corresponds to '8'
                    led_out <= 1'b0;
                end
                // Decimal 9 (Binary 1001)
                4'b1001: begin
                    seven_seg_out <= 7'b1111011; // Corresponds to '9'
                    led_out <= 1'b0;
                end
                // Decimal 10 (Binary 1010) - H LED ON
                // Updated based on the latest image: 7'b1111110 (like '0')
                4'b1010: begin
                    seven_seg_out <= 7'b1111110;
                    led_out <= 1'b1;             // LED H is ON
                end
                // Decimal 11 (Binary 1011) - H LED ON
                // Updated based on the latest image: 7'b0110000 (like '1')
                4'b1011: begin
                    seven_seg_out <= 7'b0110000;
                    led_out <= 1'b1;             // LED H is ON
                end
                // Decimal 12 (Binary 1100) - H LED ON
                // Updated based on the latest image: 7'b1101101 (like '2')
                4'b1100: begin
                    seven_seg_out <= 7'b1101101;
                    led_out <= 1'b1;             // LED H is ON
                end
                // Decimal 13 (Binary 1101) - H LED ON
                // Updated based on the latest image: 7'b1111001 (like '3')
                4'b1101: begin
                    seven_seg_out <= 7'b1111001;
                    led_out <= 1'b1;             // LED H is ON
                end
                // Decimal 14 (Binary 1110) - H LED ON
                // Updated based on the latest image: 7'b0110011 (like '4')
                4'b1110: begin
                    seven_seg_out <= 7'b0110011;
                    led_out <= 1'b1;             // LED H is ON
                end
                // Decimal 15 (Binary 1111) - H LED ON
                // Updated based on the latest image: 7'b1011011 (like '5')
                4'b1111: begin
                    seven_seg_out <= 7'b1011011;
                    led_out <= 1'b1;             // LED H is ON
                end
                default: begin
                    // This 'default' case handles any unexpected inputs.
                    seven_seg_out <= 7'b0000000; // All segments OFF
                    led_out <= 1'b0;             // LED OFF
                end
            endcase
        end
    end

endmodule


// testbench module
// This is a testbench module to simulate the binary_to_decimal converter.
// It generates a .vcd file for waveform viewing in gtkwave.

module testbench;

    // Declare signals that will connect to the DUT (Device Under Test)
    reg  tb_clk;                // Testbench clock signal
    reg  tb_rst_n;              // Testbench reset signal (active-low)
    reg  [3:0]  tb_binary_in;       // Testbench input for binary_in
    wire [6:0]  tb_seven_seg_out;   // Testbench wire for seven_seg_out
    wire        tb_led_out;         // Testbench wire for led_out

    // Instantiate the Device Under Test (DUT)
    // Connect testbench signals to the DUT's ports
    binary_to_decimal dut (
        .clk          (tb_clk),
        .rst_n        (tb_rst_n),
        .binary_in    (tb_binary_in),
        .seven_seg_out(tb_seven_seg_out),
        .led_out      (tb_led_out)
    );

    // Clock generation
    // Generates a clock with a period of 20 time units (10 high, 10 low)
    initial begin
        tb_clk = 1'b0; // Initialize clock to 0
        forever #10 tb_clk = ~tb_clk; // Toggle clock every 10 time units
    end

    // Initial block for simulation setup and stimulus generation
    initial begin
        // Dump waves to a VCD file for gtkwave
        $dumpfile("binary_to_decimal.vcd"); // Specify the output VCD file name
        $dumpvars(0, testbench);           // Dump all signals in the testbench module

        // Apply reset sequence
        tb_rst_n = 1'b0; // Assert reset
        tb_binary_in = 4'bxxxx; // Undefined input during reset
        #20;             // Hold reset for 20 time units (one full clock cycle)
        tb_rst_n = 1'b1; // De-assert reset
        #10;             // Wait for half a clock cycle after reset de-assertion

        // Apply stimulus for all 16 possible binary inputs
        // Each input is applied for 20 time units (one full clock cycle)
        // This allows the registered outputs to update on the clock edge.

        tb_binary_in = 4'b0000; // Decimal 0
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0001; // Decimal 1
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0010; // Decimal 2
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0011; // Decimal 3
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0100; // Decimal 4
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0101; // Decimal 5
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0110; // Decimal 6
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b0111; // Decimal 7
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1000; // Decimal 8
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1001; // Decimal 9
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1010; // Decimal 10 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1011; // Decimal 11 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1100; // Decimal 12 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1101; // Decimal 13 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1110; // Decimal 14 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;
        tb_binary_in = 4'b1111; // Decimal 15 (H LED ON)
        $display("Time: %0t | Input: %b | 7-Segment: %b | LED: %b", $time, tb_binary_in, tb_seven_seg_out, tb_led_out);
        #20;

        $finish; // End the simulation after all inputs have been tested
    end

endmodule
