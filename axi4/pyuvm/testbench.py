import cocotb.clock
import pyuvm
import random
import cocotb
from pyuvm import *
from axi4ram_env import AXISeqItem, AXISeqItemType, AXIEnv
from cocotb.triggers import *

class RandomSeq(uvm_sequence):
    async def body(self):
        for _ in range(1000):
            seq_item = AXISeqItem("RandomSeqItem")
            seq_item.tr_type = AXISeqItemType.WRITE
            seq_item.randomize()
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

            seq_item.tr_type = AXISeqItemType.READ
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

# class BounarySeq(uvm_sequence):
#     async def body(self):
#         for _ in range(1000):
#             for a in [0, 2**64-1]:
#                 for b in [0, 2**64-1]:
#                     cin = random.randint(0, 1)
#                     seq_item = AdderSeqItem(a=a, b=b, cin=cin)
#                     await self.start_item(seq_item)
#                     await self.finish_item(seq_item)

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

async def generate_clock(dut):
    """Generate clock pulses."""

    while True:
        dut.clock.value = 0
        await Timer(10000, units="ns")
        dut.clock.value = 1
        await Timer(10000, units="ns")

@pyuvm.test()
class AdderRandomTest(uvm_test):
    def build_phase(self):
        self.env = AXIEnv("env", self)

    def end_of_elaboration_phase(self):
        self.random_seq= RandomSeq.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.random_seq.start(seqr)
        self.drop_objection()
