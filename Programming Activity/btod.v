`timescale 1ns/1ps

// ============================================================================
// 4-bit Binary → Decimal on 7-Segment + “tens” LED
//  – Sequential: register the 4-bit input on clk/rst
//  – Behavioral: decode to segments A–G and drive LED when ≥10
// ============================================================================
module bin2dec7seg (
    input  wire        clk,     // system clock
    input  wire        rst_n,   // active-low reset
    input  wire [3:0]  bin,     // raw input 0…15
    output reg  [6:0]  seg,     // segments {A,B,C,D,E,F,G}, active-high
    output reg         led      // lights when bin ≥ 10
);

    // -- 1) Sequential: register the binary input
    reg [3:0] bin_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bin_reg <= 4'd0;
        else
            bin_reg <= bin;
    end

    // -- 2) Behavioral: compute “units” digit and tens-LED, then decode
    reg [3:0] unit;
    always @(*) begin
        // tens-LED logic
        if (bin_reg < 4'd10) begin
            led  = 1'b0;
            unit = bin_reg;
        end else begin
            led  = 1'b1;
            unit = bin_reg - 4'd10;
        end

        // seven-segment decoder for 0–9
        case (unit)
            4'd0: seg = 7'b1111110; // 0
            4'd1: seg = 7'b0110000; // 1
            4'd2: seg = 7'b1101101; // 2
            4'd3: seg = 7'b1111001; // 3
            4'd4: seg = 7'b0110011; // 4
            4'd5: seg = 7'b1011011; // 5
            4'd6: seg = 7'b1011111; // 6
            4'd7: seg = 7'b1110000; // 7
            4'd8: seg = 7'b1111111; // 8
            4'd9: seg = 7'b1111011; // 9
            default: seg = 7'b0000000;
        endcase
    end

endmodule


// ============================================================================
// Testbench for bin2dec7seg
//  – Generates clk, rst, sweeps bin=0..15
//  – Dumps VCD for GTKWave inspection
// ============================================================================
module tb_bin2dec7seg;
    // clocks & signals
    reg         clk = 0;
    reg         rst_n;
    reg  [3:0]  bin;
    wire [6:0]  seg;
    wire        led;

    // instantiate DUT
    bin2dec7seg dut (
        .clk   (clk),
        .rst_n (rst_n),
        .bin   (bin),
        .seg   (seg),
        .led   (led)
    );

    // clock: 50 MHz → 20 ns period
    always #10 clk = ~clk;

    initial begin
        // dump for GTKWave
        $dumpfile("bin2dec7seg.vcd");
        $dumpvars(0, tb_bin2dec7seg);

        // reset sequence
        rst_n = 1'b0;
        bin   = 4'd0;
        #50;
        rst_n = 1'b1;

        // sweep 0–15
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            bin = i;
            #20;  // one clock cycle
        end

        #50;
        $finish;
    end
endmodule
