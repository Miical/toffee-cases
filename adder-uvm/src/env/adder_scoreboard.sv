`ifndef ADDER_SCOREBOARD__SV
`define ADDER_SCOREBOARD__SV

`include "adder_ports/adder_transaction.sv"

class adder_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(adder_transaction, adder_scoreboard) ap;
    `uvm_component_utils(adder_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function write(adder_transaction trans);
        bit [64:0] expected = {1'b0, trans.a} + {1'b0, trans.b} + trans.cin;
        if (trans.sum !== expected[63:0] || trans.cout !== expected[64]) begin
            `uvm_error("ADDER_SCOREBOARD", $sformatf("Mismatch! Expected sum: %0h, cout: %0b, Got sum: %0h, cout: %0b",
                        expected[63:0], expected[64], trans.sum, trans.cout))
        end else begin
            `uvm_info("ADDER_SCOREBOARD", "Result matches", UVM_LOW)
        end
    endfunction
endclass

`endif
