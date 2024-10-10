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

    function replicate_bits(int binary_num, int replication, int num_bits);
        int result = 0;
        for (int i = 0; i < num_bits; i++) begin
            int b = (binary_num >> i) & 1;
            for (int j = 0; j < replication; j++) begin
                result = result | (b << (i * replication + j));
            end
        end
        return result;
    endfunction

    task response_write_burst(simplebus_item req);
        int addr, wdata, wmask;
        addr = req.req_addr;
        while (1) begin
            wdata = req.req_wdata;
            wmask = req.req_wmask;
            wmask = replicate_bits(wmask, 8, 8);
            if (!(data.exists(addr))) begin
                data[addr] = 0;
            end
            data[addr] = (data[addr] & (~wmask)) | (wdata & wmask);
            `uvm_do_with(tr, {
                tr_type == simplebus_item::RESP;
                resp_cmd == WRITE_RESP_CMD;
                resp_user == req.req_user;
            });

            if (req.req_cmd == WRITE_LAST_CMD)
                break;

            `uvm_do_with(tr, { tr_type == simplebus_item::GET_REQ; });
            get_response(req);
            addr += 8;
        end
    endtask

    task response_once();
        `uvm_do_with(tr, {tr_type == simplebus_item::GET_REQ;});
        get_response(rsp);

        if (rsp.req_cmd == READ_BURST_CMD || rsp.req_cmd == READ_CMD) begin
            int firstaddr = tr.req_addr & 32'hffffffc0;
            int id = (tr.req_addr - firstaddr) >> 3;
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

        else if (rsp.req_cmd == WRITE_BURST_CMD) begin
            response_write_burst(rsp);
        end

        else if (rsp.req_cmd == WRITE_CMD) begin
            int addr, wdata, wmask;
            addr = rsp.req_addr & 32'hfffffff8;
            wdata = rsp.req_wdata;
            wmask = rsp.req_wmask;
            wmask = replicate_bits(wmask, 8, 8);
            if (!(data.exists(addr))) begin
                data[addr] = 0;
            end
            data[addr] = (data[addr] & (~wmask)) | (wdata & wmask);
            `uvm_do_with(tr, {
                tr_type == simplebus_item::RESP;
                resp_cmd == 4'b0101;
                resp_user == rsp.req_user;
            });
        end
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
