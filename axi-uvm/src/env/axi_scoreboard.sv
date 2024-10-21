`ifndef AXI_SCOREBOARD__SV
`define AXI_SCOREBOARD__SV

`include "axi_vip/axi_transaction.sv"

// class axi_scoreboard extends uvm_scoreboard;
//     uvm_analysis_imp #(axi_transaction, axi_scoreboard) ap;
//     `uvm_component_utils(axi_scoreboard)

//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//         ap = new("ap", this);
//     endfunction

//     virtual function write(axi_transaction trans);
//         bit [64:0] expected = {1'b0, trans.a} + {1'b0, trans.b} + trans.cin;
//         if (trans.sum !== expected[63:0] || trans.cout !== expected[64]) begin
//             `uvm_error("axi_SCOREBOARD", $sformatf("Mismatch! Expected sum: %0h, cout: %0b, Got sum: %0h, cout: %0b",
//                         expected[63:0], expected[64], trans.sum, trans.cout))
//         end else begin
//             `uvm_info("axi_SCOREBOARD", "Result matches", UVM_LOW)
//         end
//     endfunction
// endclass

`endif
