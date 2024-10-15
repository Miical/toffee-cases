`ifndef ADDER_IF
`define ADDER_IF

interface adder_if(input clock);
    logic [63:0] a;
    logic [63:0] b;
    logic        cin;
    logic [63:0] sum;
    logic        cout;
endinterface //adder_if

`endif
