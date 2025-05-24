module priority_encoder_4to2(
    input wire [3:0] in,
    output reg [2:0] out
);

    always @* begin
        case(1'b1)
            in[3]: out = 3'b111;
            in[2]: out = 3'b101;
            in[1]: out = 3'b011;
			in[0]: out = 3'b001;
			default: out = 3'bxx0;
        endcase
    end

endmodule

module priority_encoder_4to2_tb;

    reg [3:0] in;
    wire [2:0] out;

    // Instantiate the DUT
    priority_encoder_4to2 uut (
        .in(in),
        .out(out)
    );

    initial begin
		$dumpfile("4to2.vcd");
        $dumpvars(0, priority_encoder_4to2_tb);
	end
	initial begin
		in = 4'b0000;
        #3 
		in = 4'b0001;
        #3 
		in = 4'b0010;
        #3 
		in = 4'b0100;
        #3 
		in = 4'b0101;
		#3 
		in = 4'b0110;
		#3
		in = 4'b0111;
		#3
		in = 4'b1000;
		#3
		in = 4'b1001;
		#3
		in = 4'b1010;
		#3
		in = 4'b1011;
		#3
		in = 4'b1100;
		#3
		in = 4'b1101;
		#3
		in = 4'b1110;
		#3
		in = 4'b1111;
		#3
       $finish;
    end
endmodule
