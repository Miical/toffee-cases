`ifndef TEST_READ_AND_WRITE_SAME_ADDR__SV
`define TEST_READ_AND_WRITE_SAME_ADDR__SV

class test_read_and_write_same_addr_sequence extends uvm_sequence #(axi_transaction);
    `uvm_object_utils(test_read_and_write_same_addr_sequence)

    axi_transaction tr;

    function new(string name = "test_read_and_write_same_addr");
        super.new(name);
    endfunction

    virtual task body();
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for (int i = 0; i < 5000; i++) begin
            `uvm_do_with(tr, {
                tr.tr_type == tr.tr_type == axi_transaction::WRITE;
                tr.addr[2:0] == 0;
                tr.addr < (32'd1 << 10);
                tr.addr > 0;
                tr.len > 0;
                tr.len < 8'd16;
            })
            `uvm_send(tr)

            tr.tr_type = axi_transaction::READ;
            `uvm_send(tr)
        end

        #100
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass


class test_read_and_write_same_addr extends base_test;
    `uvm_component_utils(test_read_and_write_same_addr)

    function new(string name = "test_read_and_write_same_addr", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.axi_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_read_and_write_same_addr_sequence::type_id::get());
    endfunction
endclass

`endif
