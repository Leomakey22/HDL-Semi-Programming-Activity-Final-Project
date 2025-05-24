module decoder(
    input [2:0] input_bits,
    output reg [7:0] output_bits
);

always @*
begin
    if(input_bits == 3'b000)
        output_bits = 8'b00000001;
    else if(input_bits == 3'b001)
        output_bits = 8'b00000010;
    else if(input_bits == 3'b010)
        output_bits = 8'b00000100;
    else if(input_bits == 3'b011)
        output_bits = 8'b00001000;
    else if(input_bits == 3'b100)
        output_bits = 8'b00010000;
    else if(input_bits == 3'b101)
        output_bits = 8'b00100000;
    else if(input_bits == 3'b110)
        output_bits = 8'b01000000;
    else
        output_bits = 8'b10000000;
end

endmodule

module testbench_decoder_3x8;

reg [2:0] input_bits;
wire [7:0] output_bits;

decoder uut (
    .input_bits(input_bits),
    .output_bits(output_bits)
);

initial begin
    $dumpfile("decoder.vcd");
    $dumpvars(0, testbench_decoder_3x8);

	input_bits = 3'b000;
    #3;
	input_bits = 3'b001;
    #3;
	input_bits = 3'b010;
    #3;
	input_bits = 3'b011;
    #3;
    input_bits = 3'b100;
    #3;
    input_bits = 3'b101;
    #3;
    input_bits = 3'b110;
    #3;
    input_bits = 3'b111;
    #3;

    $finish;
end

endmodule
