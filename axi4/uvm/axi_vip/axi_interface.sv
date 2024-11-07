`ifndef AXI_INTERFACE__SV
`define AXI_INTERFACE__SV

interface axi_interface(input clock, input reset);
    logic        aw_ready;
    logic        aw_valid;
    logic [31:0] aw_addr;
    logic [2:0]  aw_prot;
    logic        aw_id;
    logic        aw_user;
    logic [7:0]  aw_len;
    logic [2:0]  aw_size;
    logic [1:0]  aw_burst;
    logic        aw_lock;
    logic [3:0]  aw_cache;
    logic [3:0]  aw_qos;
    logic        w_ready;
    logic        w_valid;
    logic [63:0] w_data;
    logic [7:0]  w_strb;
    logic        w_last;
    logic        b_ready;
    logic        b_valid;
    logic [1:0]  b_resp;
    logic        b_id;
    logic        b_user;
    logic        ar_ready;
    logic        ar_valid;
    logic [31:0] ar_addr;
    logic [2:0]  ar_prot;
    logic        ar_id;
    logic        ar_user;
    logic [7:0]  ar_len;
    logic [2:0]  ar_size;
    logic [1:0]  ar_burst;
    logic        ar_lock;
    logic [3:0]  ar_cache;
    logic [3:0]  ar_qos;
    logic        r_ready;
    logic        r_valid;
    logic [1:0]  r_resp;
    logic [63:0] r_data;
    logic        r_last;
    logic        r_id;
    logic        r_user;
endinterface //axi_if

`endif
