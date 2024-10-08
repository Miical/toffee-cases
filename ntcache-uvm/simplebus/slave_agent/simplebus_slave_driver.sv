`ifndef SIMPLEBUS_SLAVE_DRIVER_SV
`define SIMPLEBUS_SLAVE_DRIVER_SV

`include "simplebus/simplebus_if.sv"
`include "simplebus/simplebus_item.sv"

class simplebus_slave_driver extends uvm_driver#(simplebus_item);
    `uvm_component_utils(simplebus_slave_driver)

    virtual simplebus_if bif;
    simplebus_item item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual simplebus_if)::get(this, "", "bif", bif))
            `uvm_fatal("NO_BIF", "simplebus_if not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        int is_read_req = 0;
        forever begin
            // Get request
            seq_item_port.get_next_item(item);
            assert (item.tr_type == simplebus_item::GET_REQ);
            get_request();
            is_read_req = (item.req_cmd == 0);
            seq_item_port.put_response(item);
            seq_item_port.item_done();

            // Get response
            seq_item_port.get_next_item(item);
            assert (item.tr_type == simplebus_item::RESP);
            driver_one_pkt(is_read_req);
            seq_item_port.item_done();
        end
    endtask

    task driver_one_pkt(int is_read_req);
        if (is_read_req) begin
            // Read Response
            @(posedge bif.resp_ready);
            bif.resp_valid <= 1'b1;
            for (int i = 0; i < (1 << item.req_size); i++) begin
                bif.resp_cmd <= (i == ((1 << item.req_size) - 1)) ? 4'b0110 : 4'b0000;
                bif.resp_rdata <= item.resp_rdata[i];

                @(posedge bif.clock);
            end
            bif.resp_valid <= 1'b0;
        end
        else begin
            // Write Response
            @(posedge bif.resp_ready);
            bif.resp_valid <= 1'b1;
            bif.resp_cmd  <= 4'b0101;
            bif.resp_user <= item.resp_user;

            @(posedge bif.clock);
            bif.resp_valid <= 1'b0;
        end
    endtask

    task get_request();
        bif.req_ready <= 1'b1;
        @(posedge bif.req_valid);
        bif.req_ready <= 1'b0;

        item.tr_type <= simplebus_item::REQ;
        item.req_addr <= bif.req_addr;
        item.req_size <= bif.req_size;
        item.req_cmd <= bif.req_cmd;
        item.req_wmask <= bif.req_wmask;
        item.req_wdata <= bif.req_wdata;
        item.req_user <= bif.req_user;
        `uvm_info(get_type_name(), "got request", UVM_HIGH);
    endtask
endclass

`endif
