`ifndef TEST_READ__SV
`define TEST_READ__SV

class test_read_sequence extends uvm_sequence #(simplebus_item);
    `uvm_object_utils(test_read_sequence)

    simplebus_item tr;

    function new(string name = "test_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for (int i = 0; i < 25000; i++) begin
            `uvm_do_with(tr, {
                tr_type == simplebus_item::REQ;
                req_cmd == READ_CMD;
            });
            get_response(rsp);
        end

        #100
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass


class test_read extends base_test;
    `uvm_component_utils(test_read)

    function new(string name = "test_read", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.in_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_read_sequence::type_id::get());
    endfunction
endclass

`endif
