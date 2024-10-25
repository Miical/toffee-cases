`ifndef ADDER_MONITOR__SV
`define ADDER_MONITOR__SV

`include "adder_ports/adder_transaction.sv"

class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)
    virtual adder_if aif;
    uvm_analysis_port #(adder_transaction) ap;

    function new(string name = "adder_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "aif", aif))
            `uvm_fatal("adder_monitor", "No virtual interface set up.")
        ap = new("ap", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        while(1) begin
            collect_one_pkt();
        end
    endtask

    task collect_one_pkt();
        adder_transaction tr;

        tr = new("tr");
        tr.a = aif.a;
        tr.b = aif.b;
        tr.cin = aif.cin;
        tr.sum = aif.sum;
        tr.cout = aif.cout;

        ap.write(tr);
        @(posedge aif.clock);
    endtask
endclass

`endif
