`ifndef ADDER_SEQUENCER__SV
`define ADDER_SEQUENCER__SV

`include "adder_ports/adder_transaction.sv"

class adder_sequencer extends uvm_sequencer #(adder_transaction);
   `uvm_component_utils(adder_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
endclass

`endif
