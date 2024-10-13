`ifndef CACHE_ENV__SV
`define CACHE_ENV__SV

`include "simplebus/master_agent/simplebus_master_agent.sv"
`include "simplebus/slave_agent/simplebus_slave_agent.sv"
`include "src/env/cache_scoreboard.sv"

class cache_env extends uvm_env;
    `uvm_component_utils(cache_env)

    simplebus_master_agent in_agent;
    simplebus_slave_agent mem_agent;
    simplebus_slave_agent mmio_agent;

    cache_scoreboard scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        in_agent = simplebus_master_agent::type_id::create("in_agent", this);
        mem_agent = simplebus_slave_agent::type_id::create("mem_agent", this);
        mmio_agent = simplebus_slave_agent::type_id::create("mmio_agent", this);
        scoreboard = cache_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        in_agent.req_ap.connect(scoreboard.req_ap);
        in_agent.resp_ap.connect(scoreboard.resp_ap);
        `uvm_info(get_type_name(), "connected", UVM_LOW)
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif
