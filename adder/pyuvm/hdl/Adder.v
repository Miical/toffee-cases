module Adder #(
    parameter WIDTH = 64
) (
    input  [WIDTH-1:0] io_a,
    input  [WIDTH-1:0] io_b,
    input              io_cin,
    output [WIDTH-1:0] io_sum,
    output             io_cout
);

/* verilator lint_off WIDTHEXPAND */
assign {io_cout, io_sum}  = io_a + io_b + io_cin;
/* verilator lint_on WIDTHEXPAND */

endmodule
