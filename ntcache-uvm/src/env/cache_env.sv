`ifndef CACHE_ENV__SV
`define CACHE_ENV__SV

`include "simplebus/master_agent/simplebus_master_agent.sv"
`include "simplebus/slave_agent/simplebus_slave_agent.sv"

class cache_env extends uvm_env;
    `uvm_component_utils(cache_env)

    simplebus_master_agent in_agent;
    simplebus_slave_agent mem_agent;
    simplebus_slave_agent mmio_agent;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        in_agent = simplebus_master_agent::type_id::create("in_agent", this);
        mem_agent = simplebus_slave_agent::type_id::create("mem_agent", this);
        mmio_agent = simplebus_slave_agent::type_id::create("mmio_agent", this);
        `uvm_info(get_type_name(), "build_phase", UVM_MEDIUM)
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif
