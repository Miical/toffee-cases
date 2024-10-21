`ifndef AXI_SEQUENCER__SV
`define AXI_SEQUENCER__SV

`include "axi_vip/axi_transaction.sv"

class axi_sequencer extends uvm_sequencer #(axi_transaction);
   `uvm_component_utils(axi_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
endclass

`endif
