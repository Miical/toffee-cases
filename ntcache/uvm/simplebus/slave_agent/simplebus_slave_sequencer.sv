`ifndef SIMPLEBUS_SLAVE_SEQUENCER__SV
`define SIMPLEBUS_SLAVE_SEQUENCER__SV

class simplebus_slave_sequencer extends uvm_sequencer #(simplebus_item);
   `uvm_component_utils(simplebus_slave_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
endclass

`endif
