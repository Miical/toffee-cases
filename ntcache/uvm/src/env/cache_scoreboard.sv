`ifndef CACHE_SCOREBOARD__SV
`define CACHE_SCOREBOARD__SV

`include "simplebus/simplebus_item.sv"

`uvm_analysis_imp_decl(_req)
`uvm_analysis_imp_decl(_resp)
class cache_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp_req #(simplebus_item, cache_scoreboard) req_ap;
    uvm_analysis_imp_resp #(simplebus_item, cache_scoreboard) resp_ap;

    `uvm_component_utils(cache_scoreboard)

    typedef int unsigned int_map_t[int];
    int_map_t data;
    simplebus_item tr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        tr = new("tr");
        req_ap = new("req_ap", this);
        resp_ap = new("resp_ap", this);
    endfunction

    virtual function write_req(simplebus_item trans);
        int addr, wmask, wdata;

        if (trans.req_cmd == READ_CMD) begin
            addr = trans.req_addr & 32'hfffffff8;
            tr.tr_type = simplebus_item::RESP;
            tr.resp_cmd = READ_LAST_CMD;
            tr.resp_user = trans.req_user;
            for (int i = 0; i < 8; i++) begin
                tr.resp_rdata[i] = 0;
            end

            if (data.exists(addr) == 1) begin
                tr.resp_rdata[0] = data[addr];
            end
        end

        else if (trans.req_cmd == WRITE_CMD) begin
            addr = trans.req_addr & 32'hfffffff8;
            wdata = trans.req_wdata;
            wmask = replicate_bits(trans.req_wmask, 8, 8);
            if (data.exists(addr) == 0) begin
                data[addr] = 0;
            end
            data[addr] = (data[addr] & (~wmask)) | (wdata & wmask);

            tr.tr_type = simplebus_item::RESP;
            tr.resp_cmd = WRITE_RESP_CMD;
            tr.resp_user = trans.req_user;
            for (int i = 0; i < 8; i++) begin
                tr.resp_rdata[i] = 0;
            end
        end
    endfunction

    virtual function write_resp(simplebus_item trans);
        if (!trans.compare(tr)) begin
            `uvm_error("SCOREBOARD", $sformatf("Response transaction mismatch: expected %s, got %s", tr.sprint(), trans.sprint()));
        end
    endfunction
endclass

`endif
