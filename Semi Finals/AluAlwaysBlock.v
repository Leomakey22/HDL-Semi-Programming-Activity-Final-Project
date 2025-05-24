// 1-bit ALU using always block
module ALU_1bit (
    input wire X, Y,        // 1-bit Inputs
    input wire S0, S1,      // Select lines
    output reg R            // Output
);

    always @(*) begin
        case ({S1, S0})
            2'b00: R = X & Y;       // AND
            2'b01: R = X | Y;       // OR
            2'b10: R = X ^ Y;       // XOR
            2'b11: R = ~X;          // NOT X (unary op, ignore Y)
            default: R = 0;
        endcase
    end
endmodule
