`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class memory_sequence extends uvm_sequence #(simplebus_item);
    `uvm_object_utils(memory_sequence)
    simplebus_item tr;
    typedef int unsigned int_map_t[int];
    int_map_t data;

    function new(string name = "memory_sequence");
        super.new(name);
    endfunction

    task response_once();
        `uvm_do_with(tr, {tr_type == simplebus_item::GET_REQ;});
        get_response(rsp);

        if (rsp.req_cmd == 4'b0010 || rsp.req_cmd == 4'b0000) begin
            int firstaddr = tr.req_addr & 32'hffffffc0;
            int id = (tr.req_addr - firstaddr) >> 3;
            `uvm_info("mem_seq", "enter", UVM_MEDIUM);
            for (int i = 0; i < (1 << tr.req_size); i++) begin
                if (data.exists(firstaddr + (id << 3)))
                    tr.resp_rdata[i] = data[firstaddr + (id << 3)];
                else
                    tr.resp_rdata[i] = 0;
                id = (id + 1) % (1 << tr.req_size);
            end

            tr.tr_type = simplebus_item::RESP;
            tr.resp_size = rsp.req_size;
            `uvm_send(tr)
        end

        `uvm_info("mem_seq", "rsp print", UVM_MEDIUM);
        rsp.print();
    endtask

    virtual task body();
        forever begin
            response_once();
        end
    endtask
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    cache_env env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = cache_env::type_id::create("env", this);

        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.mem_agent.sqr.main_phase",
                                                "default_sequence",
                                                memory_sequence::type_id::get());
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.mmio_agent.sqr.main_phase",
                                                "default_sequence",
                                                memory_sequence::type_id::get());
    endfunction

    virtual function void report_phase(uvm_phase phase);
        uvm_report_server server;
        int err_num;
        super.report_phase(phase);

        server = uvm_report_server::get_server();
        err_num = server.get_severity_count(UVM_ERROR);

        if (err_num != 0)
            `uvm_fatal("FATAL", $sformatf("Test failed with %0d errors", err_num))
        else
            `uvm_info("PASSED", "Test passed", UVM_NONE)
    endfunction
endclass

`endif
