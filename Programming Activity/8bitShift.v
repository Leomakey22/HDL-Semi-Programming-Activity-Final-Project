module shift_register_8bit (
    input clk,
    input nReset,
    input Load,
    input ShiftR,
    input data_in,     // Serial input
    input [7:0] parallel_in, // Parallel input
    output data_out    // Serial output
);

    reg [7:0] shift_reg; // 8-bit register

    always @(posedge clk) begin
        if (~nReset) begin
            shift_reg <= 8'b0; // Reset
        end else if (Load) begin
            shift_reg <= parallel_in; // Load from parallel input
        end else if (ShiftR) begin
            shift_reg <= {shift_reg[6:0], data_in}; // Shift right
        end else begin
            // No change
            shift_reg <= shift_reg;
        end
    end

    assign data_out = shift_reg[7]; // Serial output is the MSB
    
endmodule

// Testbench for the 8-bit Shift Register
module shift_register_8bit_tb;

    reg clk;
    reg nReset;
    reg Load;
    reg ShiftR;
    reg data_in;
    reg [7:0] parallel_in;
    wire data_out;

    // Instantiate the shift register module
    shift_register_8bit uut (
        .clk(clk),
        .nReset(nReset),
        .Load(Load),
        .ShiftR(ShiftR),
        .data_in(data_in),
        .parallel_in(parallel_in),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10 time units
    end

    // Test sequence
    initial begin
        nReset = 0;  // Reset
        Load   = 0;
        ShiftR = 0;
        data_in = 0;
        parallel_in = 8'b0;
        
        #20 nReset = 1;  // Deassert reset
        #20 Load = 1;      // Load parallel data
        parallel_in = 8'b10101010;
        #20 Load = 0;
        
        #20 ShiftR = 1;    // Shift right
        data_in = 1;
        #20 data_in = 0;
        #20 data_in = 1;
        #20 ShiftR = 0;
        
        #100 $finish;       // Stop simulation after a while
    end

  // Dump signals for waveform viewing
  initial begin
    $dumpfile("shift_register.vcd"); // Create a VCD file for GTKWave
    $dumpvars(0, shift_register_8bit_tb); // Dump all signals in the testbench
  end

endmodule
