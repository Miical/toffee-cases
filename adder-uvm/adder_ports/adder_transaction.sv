`ifndef ADDER_TRANSACTION__SV
`define ADDER_TRANSACTION__SV

class adder_transaction extends uvm_sequence_item;
  rand bit [63:0] a, b;
  rand bit        cin;
  bit [63:0]      sum;
  bit             cout;

  `uvm_object_utils_begin(adder_transaction)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(cin, UVM_ALL_ON)
    `uvm_field_int(sum, UVM_ALL_ON)
    `uvm_field_int(cout, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "adder_transaction");
    super.new(name);
  endfunction
endclass

`endif
