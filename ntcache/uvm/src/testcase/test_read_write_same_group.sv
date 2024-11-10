`ifndef TEST_READ_WRITE_SAME_GROUP__SV
`define TEST_READ_WRITE_SAME_GROUP__SV

class test_read_write_same_group_sequence extends uvm_sequence #(simplebus_item);
    `uvm_object_utils(test_read_write_same_group_sequence)

    simplebus_item tr;

    function new(string name = "test_read_write_same_group_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for (int group = 0; group < (1 << 7); group++) begin
            for (int i = 0; i < 60; i++) begin
                `uvm_do_with(tr, {
                    tr_type == simplebus_item::REQ;
                    req_cmd == WRITE_CMD;
                    req_addr[12:6] == group;
                });
                get_response(rsp);

                `uvm_do_with(tr, {
                    tr_type == simplebus_item::REQ;
                    req_cmd == READ_CMD;
                    req_addr == tr.req_addr;
                });
                get_response(rsp);
            end
        end

        #100
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass


class test_read_write_same_group extends base_test;
    `uvm_component_utils(test_read_write_same_group)

    function new(string name = "test_read_write_same_group", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.in_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_read_write_same_group_sequence::type_id::get());
    endfunction
endclass

`endif
