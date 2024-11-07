import cocotb.clock
import pyuvm
import random
import cocotb
from pyuvm import *
from axi4ram_env import AXI4SeqItem, AXI4SeqItemType, AXI4Env
from cocotb.triggers import *

class InitSeqeuence(uvm_sequence):
    async def body(self):
        for addr in range(0, 1<<12, 8 * 16):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.WRITE
            seq_item.len = 16
            seq_item.addr = addr
            seq_item.data = [0 for _ in range(16)]
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

async def init_dut(dut):
    dut.io_in_ar_valid.value = 0
    dut.io_in_ar_bits_addr.value = 0
    dut.io_in_ar_bits_len.value = 0
    dut.io_in_ar_bits_size.value = 0
    dut.io_in_ar_bits_burst.value = 0
    dut.io_in_ar_bits_cache.value = 0
    dut.io_in_ar_bits_prot.value = 0
    dut.io_in_ar_bits_qos.value = 0
    dut.io_in_ar_bits_lock.value = 0
    dut.io_in_ar_bits_id.value = 0
    dut.io_in_ar_bits_user.value = 0
    dut.io_in_aw_valid.value = 0
    dut.io_in_aw_bits_addr.value = 0
    dut.io_in_aw_bits_len.value = 0
    dut.io_in_aw_bits_size.value = 0
    dut.io_in_aw_bits_burst.value = 0
    dut.io_in_aw_bits_cache.value = 0
    dut.io_in_aw_bits_prot.value = 0
    dut.io_in_aw_bits_qos.value = 0
    dut.io_in_aw_bits_lock.value = 0
    dut.io_in_aw_bits_id.value = 0
    dut.io_in_aw_bits_user.value = 0
    dut.io_in_r_ready.value = 0
    dut.io_in_w_valid.value = 0
    dut.io_in_w_bits_strb.value = 0
    dut.io_in_w_bits_data.value = 0
    dut.io_in_w_bits_last.value = 0
    dut.io_in_b_ready.value = 0
    dut.reset.value = 1
    await RisingEdge(dut.clock)
    dut.reset.value = 0
    await RisingEdge(dut.clock)

    # pyuvm uses the same DUT to run all tests, so RAM must be initialized before testing
    seq = InitSeqeuence("init_seq")
    seqr = ConfigDB().get(None, "", "SEQR")
    await seq.start(seqr)

async def generate_clock(dut):
    while True:
        dut.clock.value = 0
        await Timer(10000, units="ns")
        dut.clock.value = 1
        await Timer(10000, units="ns")

class TestReadOnceSequence(uvm_sequence):
    async def body(self):
        for _ in range(30000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.READ
            seq_item.randomize()
            seq_item.len = 1
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestReadOnce(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestReadOnceSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()

class TestReadBurstSequence(uvm_sequence):
    async def body(self):
        for _ in range(10000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.READ
            seq_item.randomize()
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestReadBurst(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestReadBurstSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()

class TestWriteOnceSequence(uvm_sequence):
    async def body(self):
        for _ in range(30000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.WRITE
            seq_item.randomize()
            seq_item.len = 1
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestWriteOnce(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestWriteOnceSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()

class TestWriteBurstSequence(uvm_sequence):
    async def body(self):
        for _ in range(10000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.WRITE
            seq_item.randomize()
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestWriteBurst(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestWriteBurstSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()

class TestReadAndWriteSameAddrSequence(uvm_sequence):
    async def body(self):
        for _ in range(15000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.WRITE
            seq_item.randomize()
            seq_item.len = 1
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

            seq_item.tr_type = AXI4SeqItemType.READ
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestReadAndWriteSameAddr(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestReadAndWriteSameAddrSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()

class TestRandomReadAndWriteSequence(uvm_sequence):
    async def body(self):
        for _ in range(10000):
            seq_item = AXI4SeqItem("RandomSeqItem")
            seq_item.tr_type = AXI4SeqItemType.WRITE if random.choice([True, False]) else AXI4SeqItemType.READ
            seq_item.randomize()
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

@pyuvm.test()
class TestRandomReadAndWrite(uvm_test):
    def build_phase(self):
        self.env = AXI4Env("env", self)

    def end_of_elaboration_phase(self):
        self.seq = TestRandomReadAndWriteSequence("seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.seq.start(seqr)
        self.drop_objection()
