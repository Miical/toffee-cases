module AXI4RAM(
  input         clock,
  input         reset,
  output        io_in_aw_ready,
  input         io_in_aw_valid,
  input  [31:0] io_in_aw_bits_addr,
  input  [2:0]  io_in_aw_bits_prot,
  input         io_in_aw_bits_id,
  input         io_in_aw_bits_user,
  input  [7:0]  io_in_aw_bits_len,
  input  [2:0]  io_in_aw_bits_size,
  input  [1:0]  io_in_aw_bits_burst,
  input         io_in_aw_bits_lock,
  input  [3:0]  io_in_aw_bits_cache,
  input  [3:0]  io_in_aw_bits_qos,
  output        io_in_w_ready,
  input         io_in_w_valid,
  input  [63:0] io_in_w_bits_data,
  input  [7:0]  io_in_w_bits_strb,
  input         io_in_w_bits_last,
  input         io_in_b_ready,
  output        io_in_b_valid,
  output [1:0]  io_in_b_bits_resp,
  output        io_in_b_bits_id,
  output        io_in_b_bits_user,
  output        io_in_ar_ready,
  input         io_in_ar_valid,
  input  [31:0] io_in_ar_bits_addr,
  input  [2:0]  io_in_ar_bits_prot,
  input         io_in_ar_bits_id,
  input         io_in_ar_bits_user,
  input  [7:0]  io_in_ar_bits_len,
  input  [2:0]  io_in_ar_bits_size,
  input  [1:0]  io_in_ar_bits_burst,
  input         io_in_ar_bits_lock,
  input  [3:0]  io_in_ar_bits_cache,
  input  [3:0]  io_in_ar_bits_qos,
  input         io_in_r_ready,
  output        io_in_r_valid,
  output [1:0]  io_in_r_bits_resp,
  output [63:0] io_in_r_bits_data,
  output        io_in_r_bits_last,
  output        io_in_r_bits_id,
  output        io_in_r_bits_user
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [63:0] _RAND_24;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] rdata_mem_0 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_0_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_0_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_0_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_0_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_0_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_0_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_0_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_1 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_1_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_1_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_1_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_1_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_1_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_1_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_1_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_2 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_2_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_2_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_2_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_2_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_2_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_2_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_2_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_3 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_3_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_3_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_3_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_3_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_3_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_3_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_3_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_4 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_4_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_4_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_4_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_4_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_4_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_4_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_4_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_5 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_5_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_5_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_5_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_5_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_5_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_5_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_5_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_6 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_6_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_6_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_6_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_6_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_6_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_6_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_6_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] rdata_mem_7 [0:511]; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_7_rdata_MPORT_1_en; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_7_rdata_MPORT_1_addr; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_7_rdata_MPORT_1_data; // @[AXI4RAM.scala 51:18]
  wire [7:0] rdata_mem_7_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
  wire [8:0] rdata_mem_7_rdata_MPORT_addr; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_7_rdata_MPORT_mask; // @[AXI4RAM.scala 51:18]
  wire  rdata_mem_7_rdata_MPORT_en; // @[AXI4RAM.scala 51:18]
  reg [7:0] value; // @[Counter.scala 61:40]
  reg [7:0] readBeatCnt; // @[Counter.scala 61:40]
  wire  _T = io_in_ar_ready & io_in_ar_valid; // @[Decoupled.scala 51:35]
  reg [7:0] r; // @[Reg.scala 35:20]
  wire [7:0] _GEN_0 = _T ? io_in_ar_bits_len : r; // @[Reg.scala 36:18 35:20 36:22]
  reg [1:0] r_1; // @[Reg.scala 35:20]
  wire [1:0] _GEN_1 = _T ? io_in_ar_bits_burst : r_1; // @[Reg.scala 36:18 35:20 36:22]
  wire [31:0] _WIRE_2 = {{24'd0}, io_in_ar_bits_len}; // @[AXI4Slave.scala 45:{69,69}]
  wire [38:0] _GEN_19 = {{7'd0}, _WIRE_2}; // @[AXI4Slave.scala 45:89]
  wire [38:0] _T_4 = _GEN_19 << io_in_ar_bits_size; // @[AXI4Slave.scala 45:89]
  wire [38:0] _T_5 = ~_T_4; // @[AXI4Slave.scala 45:42]
  wire [38:0] _GEN_59 = {{7'd0}, io_in_ar_bits_addr}; // @[AXI4Slave.scala 45:40]
  wire [38:0] _T_6 = _GEN_59 & _T_5; // @[AXI4Slave.scala 45:40]
  reg [38:0] raddr_r; // @[Reg.scala 35:20]
  wire [38:0] _GEN_2 = _T ? _T_6 : raddr_r; // @[Reg.scala 36:18 35:20 36:22]
  wire [7:0] _value_T_1 = readBeatCnt + 8'h1; // @[Counter.scala 77:24]
  wire [7:0] _GEN_3 = _GEN_1 == 2'h2 & readBeatCnt == _GEN_0 ? 8'h0 : _value_T_1; // @[AXI4Slave.scala 50:{77,93} Counter.scala 77:15]
  reg  ren_REG; // @[AXI4Slave.scala 73:17]
  wire  _ren_T_1 = io_in_r_ready & io_in_r_valid; // @[Decoupled.scala 51:35]
  wire  ren = ren_REG | _ren_T_1 & ~io_in_r_bits_last; // @[AXI4Slave.scala 73:44]
  wire [7:0] _GEN_4 = ren ? _GEN_3 : readBeatCnt; // @[AXI4Slave.scala 48:18 Counter.scala 61:40]
  wire [7:0] _value_T_3 = value + 8'h1; // @[Counter.scala 77:24]
  wire [31:0] _value_T_4 = io_in_ar_bits_addr >> io_in_ar_bits_size; // @[AXI4Slave.scala 57:45]
  wire [31:0] _value_T_5 = _value_T_4 & _WIRE_2; // @[AXI4Slave.scala 57:67]
  wire  _T_14 = io_in_ar_bits_len != 8'h0 & io_in_ar_bits_burst == 2'h2; // @[AXI4Slave.scala 58:40]
  wire  _T_18 = io_in_ar_bits_len == 8'h7; // @[AXI4Slave.scala 60:30]
  wire  _T_19 = io_in_ar_bits_len == 8'h1 | io_in_ar_bits_len == 8'h3 | _T_18; // @[AXI4Slave.scala 59:71]
  wire  _T_21 = _T_19 | io_in_ar_bits_len == 8'hf; // @[AXI4Slave.scala 60:38]
  wire [31:0] _GEN_7 = _T ? _value_T_5 : {{24'd0}, _GEN_4}; // @[AXI4Slave.scala 56:27 57:23]
  wire  _r_busy_T_2 = _ren_T_1 & io_in_r_bits_last; // @[AXI4Slave.scala 70:52]
  reg  r_busy; // @[StopWatch.scala 24:20]
  wire  _GEN_8 = _r_busy_T_2 ? 1'h0 : r_busy; // @[StopWatch.scala 26:19 24:20 26:23]
  wire  _GEN_9 = _T | _GEN_8; // @[StopWatch.scala 27:{20,24}]
  wire  _io_in_r_valid_T_2 = ren & (_T | r_busy); // @[AXI4Slave.scala 74:35]
  reg  io_in_r_valid_r; // @[StopWatch.scala 24:20]
  wire  _GEN_10 = _ren_T_1 ? 1'h0 : io_in_r_valid_r; // @[StopWatch.scala 26:19 24:20 26:23]
  wire  _GEN_11 = _io_in_r_valid_T_2 | _GEN_10; // @[StopWatch.scala 27:{20,24}]
  reg [7:0] writeBeatCnt; // @[Counter.scala 61:40]
  wire  _waddr_T = io_in_aw_ready & io_in_aw_valid; // @[Decoupled.scala 51:35]
  reg [31:0] waddr_r; // @[Reg.scala 35:20]
  wire [31:0] _GEN_12 = _waddr_T ? io_in_aw_bits_addr : waddr_r; // @[Reg.scala 36:18 35:20 36:22]
  wire  _T_25 = io_in_w_ready & io_in_w_valid; // @[Decoupled.scala 51:35]
  wire [7:0] _value_T_7 = writeBeatCnt + 8'h1; // @[Counter.scala 77:24]
  wire  _w_busy_T_1 = io_in_b_ready & io_in_b_valid; // @[Decoupled.scala 51:35]
  reg  w_busy; // @[StopWatch.scala 24:20]
  wire  _GEN_15 = _w_busy_T_1 ? 1'h0 : w_busy; // @[StopWatch.scala 26:19 24:20 26:23]
  wire  _GEN_16 = _waddr_T | _GEN_15; // @[StopWatch.scala 27:{20,24}]
  wire  _io_in_b_valid_T_1 = _T_25 & io_in_w_bits_last; // @[AXI4Slave.scala 97:41]
  reg  io_in_b_valid_r; // @[StopWatch.scala 24:20]
  wire  _GEN_17 = _w_busy_T_1 ? 1'h0 : io_in_b_valid_r; // @[StopWatch.scala 26:19 24:20 26:23]
  wire  _GEN_18 = _io_in_b_valid_T_1 | _GEN_17; // @[StopWatch.scala 27:{20,24}]
  reg  io_in_b_bits_id_r; // @[Reg.scala 19:16]
  reg  io_in_b_bits_user_r; // @[Reg.scala 19:16]
  reg  io_in_r_bits_id_r; // @[Reg.scala 19:16]
  reg  io_in_r_bits_user_r; // @[Reg.scala 19:16]
  wire [31:0] _wIdx_T = _GEN_12 & 32'hfff; // @[AXI4RAM.scala 33:33]
  wire [28:0] _GEN_61 = {{21'd0}, writeBeatCnt}; // @[AXI4RAM.scala 36:27]
  wire [28:0] wIdx = _wIdx_T[31:3] + _GEN_61; // @[AXI4RAM.scala 36:27]
  wire [38:0] _rIdx_T = _GEN_2 & 39'hfff; // @[AXI4RAM.scala 33:33]
  wire [35:0] _GEN_62 = {{28'd0}, readBeatCnt}; // @[AXI4RAM.scala 37:27]
  wire [35:0] rIdx = _rIdx_T[38:3] + _GEN_62; // @[AXI4RAM.scala 37:27]
  wire  _wen_T_1 = wIdx < 29'h200; // @[AXI4RAM.scala 34:32]
  wire [63:0] _rdata_T_12 = {rdata_mem_7_rdata_MPORT_1_data,rdata_mem_6_rdata_MPORT_1_data,
    rdata_mem_5_rdata_MPORT_1_data,rdata_mem_4_rdata_MPORT_1_data,rdata_mem_3_rdata_MPORT_1_data,
    rdata_mem_2_rdata_MPORT_1_data,rdata_mem_1_rdata_MPORT_1_data,rdata_mem_0_rdata_MPORT_1_data}; // @[Cat.scala 33:92]
  reg [63:0] rdata; // @[Reg.scala 19:16]
  wire [31:0] _GEN_63 = reset ? 32'h0 : _GEN_7; // @[Counter.scala 61:{40,40}]
  assign rdata_mem_0_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_0_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_0_rdata_MPORT_1_data = rdata_mem_0[rdata_mem_0_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_0_rdata_MPORT_data = io_in_w_bits_data[7:0];
  assign rdata_mem_0_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_0_rdata_MPORT_mask = io_in_w_bits_strb[0];
  assign rdata_mem_0_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_1_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_1_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_1_rdata_MPORT_1_data = rdata_mem_1[rdata_mem_1_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_1_rdata_MPORT_data = io_in_w_bits_data[15:8];
  assign rdata_mem_1_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_1_rdata_MPORT_mask = io_in_w_bits_strb[1];
  assign rdata_mem_1_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_2_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_2_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_2_rdata_MPORT_1_data = rdata_mem_2[rdata_mem_2_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_2_rdata_MPORT_data = io_in_w_bits_data[23:16];
  assign rdata_mem_2_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_2_rdata_MPORT_mask = io_in_w_bits_strb[2];
  assign rdata_mem_2_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_3_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_3_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_3_rdata_MPORT_1_data = rdata_mem_3[rdata_mem_3_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_3_rdata_MPORT_data = io_in_w_bits_data[31:24];
  assign rdata_mem_3_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_3_rdata_MPORT_mask = io_in_w_bits_strb[3];
  assign rdata_mem_3_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_4_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_4_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_4_rdata_MPORT_1_data = rdata_mem_4[rdata_mem_4_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_4_rdata_MPORT_data = io_in_w_bits_data[39:32];
  assign rdata_mem_4_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_4_rdata_MPORT_mask = io_in_w_bits_strb[4];
  assign rdata_mem_4_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_5_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_5_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_5_rdata_MPORT_1_data = rdata_mem_5[rdata_mem_5_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_5_rdata_MPORT_data = io_in_w_bits_data[47:40];
  assign rdata_mem_5_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_5_rdata_MPORT_mask = io_in_w_bits_strb[5];
  assign rdata_mem_5_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_6_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_6_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_6_rdata_MPORT_1_data = rdata_mem_6[rdata_mem_6_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_6_rdata_MPORT_data = io_in_w_bits_data[55:48];
  assign rdata_mem_6_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_6_rdata_MPORT_mask = io_in_w_bits_strb[6];
  assign rdata_mem_6_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign rdata_mem_7_rdata_MPORT_1_en = 1'h1;
  assign rdata_mem_7_rdata_MPORT_1_addr = rIdx[8:0];
  assign rdata_mem_7_rdata_MPORT_1_data = rdata_mem_7[rdata_mem_7_rdata_MPORT_1_addr]; // @[AXI4RAM.scala 51:18]
  assign rdata_mem_7_rdata_MPORT_data = io_in_w_bits_data[63:56];
  assign rdata_mem_7_rdata_MPORT_addr = wIdx[8:0];
  assign rdata_mem_7_rdata_MPORT_mask = io_in_w_bits_strb[7];
  assign rdata_mem_7_rdata_MPORT_en = _T_25 & _wen_T_1;
  assign io_in_aw_ready = ~w_busy; // @[AXI4Slave.scala 94:18]
  assign io_in_w_ready = io_in_aw_valid | w_busy; // @[AXI4Slave.scala 95:30]
  assign io_in_b_valid = io_in_b_valid_r; // @[AXI4Slave.scala 97:14]
  assign io_in_b_bits_resp = 2'h0; // @[AXI4Slave.scala 96:18]
  assign io_in_b_bits_id = io_in_b_bits_id_r; // @[AXI4Slave.scala 101:24]
  assign io_in_b_bits_user = io_in_b_bits_user_r; // @[AXI4Slave.scala 102:24]
  assign io_in_ar_ready = io_in_r_ready | ~r_busy; // @[AXI4Slave.scala 71:29]
  assign io_in_r_valid = io_in_r_valid_r; // @[AXI4Slave.scala 74:14]
  assign io_in_r_bits_resp = 2'h0; // @[AXI4Slave.scala 72:18]
  assign io_in_r_bits_data = rdata; // @[AXI4RAM.scala 59:18]
  assign io_in_r_bits_last = value == _GEN_0; // @[AXI4Slave.scala 47:36]
  assign io_in_r_bits_id = io_in_r_bits_id_r; // @[AXI4Slave.scala 103:24]
  assign io_in_r_bits_user = io_in_r_bits_user_r; // @[AXI4Slave.scala 104:24]
  always @(posedge clock) begin
    if (rdata_mem_0_rdata_MPORT_en & rdata_mem_0_rdata_MPORT_mask) begin
      rdata_mem_0[rdata_mem_0_rdata_MPORT_addr] <= rdata_mem_0_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_1_rdata_MPORT_en & rdata_mem_1_rdata_MPORT_mask) begin
      rdata_mem_1[rdata_mem_1_rdata_MPORT_addr] <= rdata_mem_1_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_2_rdata_MPORT_en & rdata_mem_2_rdata_MPORT_mask) begin
      rdata_mem_2[rdata_mem_2_rdata_MPORT_addr] <= rdata_mem_2_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_3_rdata_MPORT_en & rdata_mem_3_rdata_MPORT_mask) begin
      rdata_mem_3[rdata_mem_3_rdata_MPORT_addr] <= rdata_mem_3_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_4_rdata_MPORT_en & rdata_mem_4_rdata_MPORT_mask) begin
      rdata_mem_4[rdata_mem_4_rdata_MPORT_addr] <= rdata_mem_4_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_5_rdata_MPORT_en & rdata_mem_5_rdata_MPORT_mask) begin
      rdata_mem_5[rdata_mem_5_rdata_MPORT_addr] <= rdata_mem_5_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_6_rdata_MPORT_en & rdata_mem_6_rdata_MPORT_mask) begin
      rdata_mem_6[rdata_mem_6_rdata_MPORT_addr] <= rdata_mem_6_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (rdata_mem_7_rdata_MPORT_en & rdata_mem_7_rdata_MPORT_mask) begin
      rdata_mem_7[rdata_mem_7_rdata_MPORT_addr] <= rdata_mem_7_rdata_MPORT_data; // @[AXI4RAM.scala 51:18]
    end
    if (reset) begin // @[Counter.scala 61:40]
      value <= 8'h0; // @[Counter.scala 61:40]
    end else if (_ren_T_1) begin // @[AXI4Slave.scala 52:26]
      if (io_in_r_bits_last) begin // @[AXI4Slave.scala 54:33]
        value <= 8'h0; // @[AXI4Slave.scala 54:43]
      end else begin
        value <= _value_T_3; // @[Counter.scala 77:15]
      end
    end
    readBeatCnt <= _GEN_63[7:0]; // @[Counter.scala 61:{40,40}]
    if (reset) begin // @[Reg.scala 35:20]
      r <= 8'h0; // @[Reg.scala 35:20]
    end else if (_T) begin // @[Reg.scala 36:18]
      r <= io_in_ar_bits_len; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[Reg.scala 35:20]
      r_1 <= 2'h0; // @[Reg.scala 35:20]
    end else if (_T) begin // @[Reg.scala 36:18]
      r_1 <= io_in_ar_bits_burst; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[Reg.scala 35:20]
      raddr_r <= 39'h0; // @[Reg.scala 35:20]
    end else if (_T) begin // @[Reg.scala 36:18]
      raddr_r <= _T_6; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[AXI4Slave.scala 73:17]
      ren_REG <= 1'h0; // @[AXI4Slave.scala 73:17]
    end else begin
      ren_REG <= _T; // @[AXI4Slave.scala 73:17]
    end
    if (reset) begin // @[StopWatch.scala 24:20]
      r_busy <= 1'h0; // @[StopWatch.scala 24:20]
    end else begin
      r_busy <= _GEN_9;
    end
    if (reset) begin // @[StopWatch.scala 24:20]
      io_in_r_valid_r <= 1'h0; // @[StopWatch.scala 24:20]
    end else begin
      io_in_r_valid_r <= _GEN_11;
    end
    if (reset) begin // @[Counter.scala 61:40]
      writeBeatCnt <= 8'h0; // @[Counter.scala 61:40]
    end else if (_T_25) begin // @[AXI4Slave.scala 82:26]
      if (io_in_w_bits_last) begin // @[AXI4Slave.scala 84:33]
        writeBeatCnt <= 8'h0; // @[AXI4Slave.scala 84:43]
      end else begin
        writeBeatCnt <= _value_T_7; // @[Counter.scala 77:15]
      end
    end
    if (reset) begin // @[Reg.scala 35:20]
      waddr_r <= 32'h0; // @[Reg.scala 35:20]
    end else if (_waddr_T) begin // @[Reg.scala 36:18]
      waddr_r <= io_in_aw_bits_addr; // @[Reg.scala 36:22]
    end
    if (reset) begin // @[StopWatch.scala 24:20]
      w_busy <= 1'h0; // @[StopWatch.scala 24:20]
    end else begin
      w_busy <= _GEN_16;
    end
    if (reset) begin // @[StopWatch.scala 24:20]
      io_in_b_valid_r <= 1'h0; // @[StopWatch.scala 24:20]
    end else begin
      io_in_b_valid_r <= _GEN_18;
    end
    if (_waddr_T) begin // @[Reg.scala 20:18]
      io_in_b_bits_id_r <= io_in_aw_bits_id; // @[Reg.scala 20:22]
    end
    if (_waddr_T) begin // @[Reg.scala 20:18]
      io_in_b_bits_user_r <= io_in_aw_bits_user; // @[Reg.scala 20:22]
    end
    if (_T) begin // @[Reg.scala 20:18]
      io_in_r_bits_id_r <= io_in_ar_bits_id; // @[Reg.scala 20:22]
    end
    if (_T) begin // @[Reg.scala 20:18]
      io_in_r_bits_user_r <= io_in_ar_bits_user; // @[Reg.scala 20:22]
    end
    if (ren) begin // @[Reg.scala 20:18]
      rdata <= _rdata_T_12; // @[Reg.scala 20:22]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & _T_14 & ~reset & ~_T_21) begin
          $fwrite(32'h80000002,
            "Assertion failed\n    at AXI4Slave.scala:59 assert(axi4.ar.bits.len === 1.U || axi4.ar.bits.len === 3.U ||\n"
            ); // @[AXI4Slave.scala 59:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef STOP_COND
      if (`STOP_COND) begin
    `endif
        if (_T & _T_14 & ~reset & ~_T_21) begin
          $fatal; // @[AXI4Slave.scala 59:17]
        end
    `ifdef STOP_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_0[initvar] = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_1[initvar] = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_2[initvar] = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_3[initvar] = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_4[initvar] = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_5[initvar] = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_6[initvar] = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    rdata_mem_7[initvar] = _RAND_7[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  value = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  readBeatCnt = _RAND_9[7:0];
  _RAND_10 = {1{`RANDOM}};
  r = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  r_1 = _RAND_11[1:0];
  _RAND_12 = {2{`RANDOM}};
  raddr_r = _RAND_12[38:0];
  _RAND_13 = {1{`RANDOM}};
  ren_REG = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  r_busy = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  io_in_r_valid_r = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  writeBeatCnt = _RAND_16[7:0];
  _RAND_17 = {1{`RANDOM}};
  waddr_r = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  w_busy = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  io_in_b_valid_r = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  io_in_b_bits_id_r = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  io_in_b_bits_user_r = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  io_in_r_bits_id_r = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  io_in_r_bits_user_r = _RAND_23[0:0];
  _RAND_24 = {2{`RANDOM}};
  rdata = _RAND_24[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
