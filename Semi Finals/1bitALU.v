module Sigbin(x,s,R);
	input [1:0]x;
	input [1:0]s;
	output reg R;
	
always @ (*) begin
    case(s)
      2'b00: R = x[0] ^ x[1];  // Addition
      2'b01: R = x[0] ^ x[1];  // Subtraction, assuming borrowing is not considered
      2'b10: R = x[0] & x[1];  // Bitwise AND
      2'b11: R = x[0] || x[1];  // Bitwise OR
      default: R = 0;
    endcase
  end
 
	
endmodule

module Sigbin_stimulus_generator(x,S);
	output reg [1:0]x;
	output reg [1:0]S;
	initial
	begin
		
		S=3'b000;
		x=2'b00;
		
		
		$dumpfile("alu.vcd");
		$dumpvars;
		
		
		S=2'b00; x=2'b00; 
		#3
		S=2'b00; x=2'b01; 
		#3
		S=2'b00; x=2'b10; 
		#3
		S=2'b00; x=2'b11; 
		#3
	
		S=2'b01; x=2'b00; 
		#3
		S=2'b01; x=2'b01; 
		#3
		S=2'b01; x=2'b10; 
		#3
		S=2'b01; x=2'b11; 
		#3
		
		S=2'b10; x=2'b00;
		#3
		S=2'b10; x=2'b01;
		#3
		S=2'b10; x=2'b10;
		#3
		S=2'b10; x=2'b11;
		
		#3
		S=2'b11; x=2'b00;
		#3
		S=2'b11; x=2'b01;
		#3
		S=2'b11; x=2'b10;
		#3
		S=2'b11; x=2'b11;
		#3
		
		$finish;
	end
endmodule

module Sigbin_testbench();
	wire [1:0]s;
	wire [1:0]x;
	
	Sigbin arithmeticOps(x,s,R);
	Sigbin_stimulus_generator arithmetic(x,s);
endmodule