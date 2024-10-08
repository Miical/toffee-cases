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

        $display("okkkkkkk0");
        `uvm_do_with(tr, {
            tr_type         == simplebus_item::REQ;
            req_cmd         == 4'b0000;
            req_addr[31:30] != 2'b01;
            req_addr[31:28] != 4'b0011;
        });
        `uvm_info("in_seq", "send transaction", UVM_HIGH);

        tr.print();
        $display("okkkkkkk1");
        get_response(rsp);
        $display("okkkkkkk2");
        rsp.print();

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
