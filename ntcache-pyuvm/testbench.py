import cocotb.clock
import pyuvm
import random
import cocotb
from pyuvm import *
from simplebus_agent import SimplebusInterface, SimpleBusCMD, SimplebusSeqItemType, SimplebusSeqItem
from cache_env import CacheEnv
from cocotb.triggers import *

class RandomSeq(uvm_sequence):
    async def body(self):
        for _ in range(1):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.randomize()
            seq_item.req_cmd = SimpleBusCMD.Read
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            print("okk")
            print(await self.get_response())


async def init_dut(dut):
    dut.io_in_req_valid.value = 0
    dut.io_in_req_bits_addr.value = 0
    dut.io_in_req_bits_size.value = 0
    dut.io_in_req_bits_cmd.value = 0
    dut.io_in_req_bits_wmask.value = 0
    dut.io_in_req_bits_wdata.value = 0
    dut.io_in_req_bits_user.value = 0
    dut.io_in_resp_ready.value = 0

    dut.io_out_mem_req_ready.value = 0
    dut.io_out_mem_resp_valid.value = 0
    dut.io_out_mem_resp_bits_cmd.value = 0
    dut.io_out_mem_resp_bits_rdata.value = 0

    dut.io_mmio_req_ready.value = 0
    dut.io_mmio_resp_valid.value = 0
    dut.io_mmio_resp_bits_cmd.value = 0
    dut.io_mmio_resp_bits_rdata.value = 0

    dut.io_out_coh_resp_ready.value = 0
    dut.io_out_coh_req_valid.value = 0
    dut.io_out_coh_req_bits_addr.value = 0
    dut.io_out_coh_req_bits_size.value = 0
    dut.io_out_coh_req_bits_cmd.value = 0
    dut.io_out_coh_req_bits_wmask.value = 0
    dut.io_out_coh_req_bits_wdata.value = 0

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
        self.dut = cocotb.top
        self.in_if = SimplebusInterface({
            "clock": self.dut.clock,
            "req_valid": self.dut.io_in_req_valid,
            "req_ready": self.dut.io_out_mem_req_ready,
            "req_addr": self.dut.io_in_req_bits_addr,
            "req_size": self.dut.io_in_req_bits_size,
            "req_cmd": self.dut.io_in_req_bits_cmd,
            "req_wmask": self.dut.io_in_req_bits_wmask,
            "req_wdata": self.dut.io_in_req_bits_wdata,
            "req_user": self.dut.io_in_req_bits_user,
            "resp_valid": self.dut.io_in_resp_valid,
            "resp_ready": self.dut.io_in_resp_ready,
            "resp_cmd": self.dut.io_in_resp_bits_cmd,
            "resp_rdata": self.dut.io_in_resp_bits_rdata,
            "resp_user": self.dut.io_in_resp_bits_user
        })

        self.mem_if = SimplebusInterface({
            "clock": self.dut.clock,
            "req_valid": self.dut.io_out_mem_req_valid,
            "req_ready": self.dut.io_out_mem_req_ready,
            "req_addr": self.dut.io_out_mem_req_bits_addr,
            "req_size": self.dut.io_out_mem_req_bits_size,
            "req_cmd": self.dut.io_out_mem_req_bits_cmd,
            "req_wmask": self.dut.io_out_mem_req_bits_wmask,
            "req_wdata": self.dut.io_out_mem_req_bits_wdata,
            "resp_valid": self.dut.io_out_mem_resp_valid,
            "resp_ready": self.dut.io_out_mem_resp_ready,
            "resp_cmd": self.dut.io_out_mem_resp_bits_cmd,
            "resp_rdata": self.dut.io_out_mem_resp_bits_rdata,
        })

        self.mmio_if = SimplebusInterface({
            "clock": self.dut.clock,
            "req_valid": self.dut.io_mmio_req_valid,
            "req_ready": self.dut.io_mmio_req_ready,
            "req_addr": self.dut.io_mmio_req_bits_addr,
            "req_size": self.dut.io_mmio_req_bits_size,
            "req_cmd": self.dut.io_mmio_req_bits_cmd,
            "req_wmask": self.dut.io_mmio_req_bits_wmask,
            "req_wdata": self.dut.io_mmio_req_bits_wdata,
            "resp_valid": self.dut.io_mmio_resp_valid,
            "resp_ready": self.dut.io_mmio_resp_ready,
            "resp_cmd": self.dut.io_mmio_resp_bits_cmd,
            "resp_rdata": self.dut.io_mmio_resp_bits_rdata,
        })

        ConfigDB().set(None, "*", "in_if", self.in_if)
        self.env = CacheEnv("env", self)

    def end_of_elaboration_phase(self):
        self.random_seq= RandomSeq.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        seqr = ConfigDB().get(None, "", "SEQR")
        await self.random_seq.start(seqr)
        self.drop_objection()

