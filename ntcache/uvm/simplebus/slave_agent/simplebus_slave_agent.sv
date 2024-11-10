`ifndef SIMPLEBUS_SLAVE_AGENT__SV
`define SIMPLEBUS_SLAVE_AGENT__SV

`include "simplebus/slave_agent/simplebus_slave_driver.sv"
`include "simplebus/slave_agent/simplebus_slave_sequencer.sv"

class simplebus_slave_agent extends uvm_agent;
    simplebus_slave_sequencer sqr;
    simplebus_slave_driver drv;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "ACTIVE", UVM_MEDIUM)
            sqr = simplebus_slave_sequencer::type_id::create("sqr", this);
            drv = simplebus_slave_driver::type_id::create("drv", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

    `uvm_component_utils(simplebus_slave_agent)
endclass;

`endif
