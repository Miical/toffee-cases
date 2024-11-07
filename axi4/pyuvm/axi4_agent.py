import cocotb
import random
from pyuvm import *
from cocotb.triggers import *

clock_period = 10000
half_period = clock_period // 2

class AXI4SeqItemType(Enum):
    READ = 0
    WRITE = 1
    READ_RESP = 2
    WRITE_RESP = 3

class AXI4Config:
    FIXED, INCR, WARP = 0, 1, 2
    OKAY, EXOKAY, SLVERR, DECERR = 0, 1, 2, 3
    AxSIZE = 0x3
    BURST_TYPE = INCR

class AXI4SeqItem(uvm_sequence_item):
    def __init__(self, name="AXI4SeqItem", tr_type=AXI4SeqItemType.READ, addr=0, len=0, data=[]):
        super().__init__(name)
        self.tr_type = tr_type
        self.addr = addr
        self.len = len
        self.data = data

    def randomize(self):
        self.addr = random.randint(0, (1<<10)-1) >> 3 << 3
        self.len = random.randint(1, 15)
        self.data = [random.randint(0, 2**64-1) for _ in range(self.len)]

    def __eq__(self, other):
        if self.tr_type == AXI4SeqItemType.READ:
            return self.tr_type == other.tr_type and self.addr == other.addr and self.len == other.len
        elif self.tr_type == AXI4SeqItemType.WRITE:
            return self.tr_type == other.tr_type and self.addr == other.addr and self.len == other.len and self.data == other.data
        elif self.tr_type == AXI4SeqItemType.READ_RESP:
            return self.tr_type == other.tr_type and self.data == other.data and self.len == other.len
        elif self.tr_type == AXI4SeqItemType.WRITE_RESP:
            return self.tr_type == other.tr_type

    def __str__(self):
        return f"AXI4SeqItem({self.tr_type}, {self.addr}, {self.len}, {self.data})"

class AXI4Driver(uvm_driver):
    def build_phase(self):
        self.dut = cocotb.top

    async def ar_send_addr(self, addr, len, size, burst_type):
        assert (addr & ((1 << size) - 1)) == 0, "Address must be aligned to size"
        assert len >= 0, "Length must be non-negative"
        self.dut.io_in_ar_valid.value = 1
        self.dut.io_in_ar_bits_addr.value = addr
        self.dut.io_in_ar_bits_len.value = len
        self.dut.io_in_ar_bits_size.value = size
        self.dut.io_in_ar_bits_burst.value = burst_type
        await RisingEdge(self.dut.clock)

        while not self.dut.io_in_ar_ready.value:
            await RisingEdge(self.dut.clock)
        self.dut.io_in_ar_valid.value = 0

    async def aw_send_addr(self, addr, len, size, burst_type):
        assert (addr & ((1 << size) - 1)) == 0, "Address must be aligned to size"
        assert len >= 0, "Length must be non-negative"
        self.dut.io_in_aw_valid.value = 1
        self.dut.io_in_aw_bits_addr.value = addr
        self.dut.io_in_aw_bits_len.value = len
        self.dut.io_in_aw_bits_size.value = size
        self.dut.io_in_aw_bits_burst.value = burst_type
        await RisingEdge(self.dut.clock)

        while not self.dut.io_in_aw_ready.value:
            await RisingEdge(self.dut.clock)
        self.dut.io_in_aw_valid.value = 0

    async def drive_a_pkt(self, seq_item):
        if seq_item.tr_type == AXI4SeqItemType.READ:
            await self.ar_send_addr(seq_item.addr, seq_item.len-1, AXI4Config.AxSIZE, AXI4Config.BURST_TYPE)
            self.dut.io_in_r_ready.value = 1
            while True:
                if self.dut.io_in_r_valid.value and self.dut.io_in_r_ready.value and \
                    self.dut.io_in_r_bits_last.value:
                    break
                await RisingEdge(self.dut.clock)
            self.dut.io_in_r_ready.value = 0
            await RisingEdge(self.dut.clock)

        elif seq_item.tr_type == AXI4SeqItemType.WRITE:
            await self.aw_send_addr(seq_item.addr, seq_item.len-1, AXI4Config.AxSIZE, AXI4Config.BURST_TYPE)
            for i in range(seq_item.len):
                self.dut.io_in_w_valid.value = 1
                self.dut.io_in_w_bits_data.value = seq_item.data[i]
                self.dut.io_in_w_bits_last.value = i == seq_item.len - 1
                self.dut.io_in_w_bits_strb.value = 0xFF
                await RisingEdge(self.dut.clock)

                while not self.dut.io_in_w_ready.value:
                    await RisingEdge(self.dut.clock)
                self.dut.io_in_w_valid.value = 0

            self.dut.io_in_b_ready.value = 1
            while not self.dut.io_in_b_valid.value:
                await RisingEdge(self.dut.clock)
            self.dut.io_in_b_ready.value = 0
            await RisingEdge(self.dut.clock)

    async def run_phase(self):
        while True:
            seq_item = await self.seq_item_port.get_next_item()
            await self.drive_a_pkt(seq_item)
            self.seq_item_port.item_done()

class AXI4Monitor(uvm_monitor):
    def build_phase(self):
        self.ap = uvm_analysis_port("ap", self)
        self.dut = cocotb.top

    async def collect_ar_pkt(self):
        while True:
            if self.dut.io_in_ar_valid.value and self.dut.io_in_ar_ready.value:
                seq_item = AXI4SeqItem(
                    tr_type=AXI4SeqItemType.READ,
                    addr=self.dut.io_in_ar_bits_addr.value,
                    len=self.dut.io_in_ar_bits_len.value + 1)
                self.ap.write(seq_item)
            await RisingEdge(self.dut.clock)

    async def collect_aw_w_pkt(self):
        while True:
            seq_item = AXI4SeqItem(tr_type=AXI4SeqItemType.WRITE)
            seq_item.data = []
            seq_item.len = 0
            while True:
                if self.dut.io_in_aw_valid.value and self.dut.io_in_aw_ready.value:
                    seq_item.addr = self.dut.io_in_aw_bits_addr.value
                    seq_item.len = self.dut.io_in_aw_bits_len.value + 1
                    break
                await RisingEdge(self.dut.clock)

            while True:
                if self.dut.io_in_w_valid.value and self.dut.io_in_w_ready.value:
                    seq_item.data.append(self.dut.io_in_w_bits_data.value)
                    if self.dut.io_in_w_bits_last.value:
                        seq_item.len = len(seq_item.data)
                        break
                await RisingEdge(self.dut.clock)

            self.ap.write(seq_item)
            await RisingEdge(self.dut.clock)

    async def collect_b_pkt(self):
        while True:
            if self.dut.io_in_b_valid.value and self.dut.io_in_b_ready.value:
                seq_item = AXI4SeqItem(tr_type=AXI4SeqItemType.WRITE_RESP)
                self.ap.write(seq_item)
            await RisingEdge(self.dut.clock)

    async def collect_r_pkt(self):
        while True:
            seq_item = AXI4SeqItem(tr_type=AXI4SeqItemType.READ_RESP)
            seq_item.data = []
            seq_item.len = 0

            while True:
                if self.dut.io_in_r_valid.value and self.dut.io_in_r_ready.value:
                    seq_item.data.append(self.dut.io_in_r_bits_data.value)
                    if self.dut.io_in_r_bits_last.value:
                        seq_item.len = len(seq_item.data)
                        break
                await RisingEdge(self.dut.clock)

            self.ap.write(seq_item)
            await RisingEdge(self.dut.clock)

    async def run_phase(self):
        cocotb.start_soon(self.collect_ar_pkt())
        cocotb.start_soon(self.collect_aw_w_pkt())
        cocotb.start_soon(self.collect_b_pkt())
        cocotb.start_soon(self.collect_r_pkt())

class AXI4Agent(uvm_agent):
    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        self.driver = AXI4Driver("driver", self)
        self.monitor = AXI4Monitor("monitor", self)
        ConfigDB().set(None, "*", "SEQR", self.seqr)

    def connect_phase(self):
        self.ap = self.monitor.ap
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
