`ifndef ADDER_AGENT__SV
`define ADDER_AGENT__SV

`include "adder_ports/adder_agent/adder_sequencer.sv"
`include "adder_ports/adder_agent/adder_driver.sv"
`include "adder_ports/adder_agent/adder_monitor.sv"

class adder_agent extends uvm_agent;
    adder_sequencer sqr;
    adder_driver drv;
    adder_monitor mon;

    uvm_analysis_port #(adder_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "ACTIVE", UVM_MEDIUM)
            sqr = adder_sequencer::type_id::create("sqr", this);
            drv = adder_driver::type_id::create("drv", this);
        end
        mon = adder_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        ap = mon.ap;
    endfunction

    `uvm_component_utils(adder_agent)
endclass;

`endif
