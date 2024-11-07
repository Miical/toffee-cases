`ifndef SIMPLEBUS_MASTER_SEQUENCER__SV
`define SIMPLEBUS_MASTER_SEQUENCER__SV

class simplebus_master_sequencer extends uvm_sequencer #(simplebus_item);
   `uvm_component_utils(simplebus_master_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
endclass

`endif
