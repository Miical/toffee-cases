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
        for _ in range(100):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.randomize()
            seq_item.req_cmd = SimpleBusCMD.Read
            seq_item.req_addr = 0x80000000
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            print(await self.get_response())


def replicate_bits(binary_num, replication, num_bits):
    result = 0
    for i in range(num_bits):
        bit = (binary_num >> i) & 1
        for j in range(replication):
            result = result | (bit << (i * replication + j))
    return result

class MemorySeq(uvm_sequence):
    def __init__(self, name):
        super().__init__(name)
        self.data = {}

    async def get_req(self):
        seq_item = SimplebusSeqItem("MemorySeqItem")
        seq_item.tr_type = SimplebusSeqItemType.GET_REQ
        await self.start_item(seq_item)
        await self.finish_item(seq_item)
        req = await self.get_response()
        return req

    async def read_resp(self, size, data):
        seq_item = SimplebusSeqItem("MemorySeqItem")
        seq_item.tr_type = SimplebusSeqItemType.RESP
        seq_item.resp_size = size
        seq_item.resp_rdata = data
        await self.start_item(seq_item)
        await self.finish_item(seq_item)

    async def write_resp(self, user):
        seq_item = SimplebusSeqItem("MemorySeqItem")
        seq_item.tr_type = SimplebusSeqItemType.RESP
        seq_item.resp_cmd = SimpleBusCMD.WriteResp.value
        seq_item.resp_user = user
        await self.start_item(seq_item)
        await self.finish_item(seq_item)

    async def response_write_burst(self, req: SimplebusSeqItem):
        addr = req.req_addr
        while (True):
            data, wmask = req.req_wdata, req.req_wmask
            wmask = replicate_bits(wmask, 8, 8)
            if addr not in self.data:
                self.data[addr] = 0
            self.data[addr] = (self.data[addr] & (~wmask)) | (data & wmask)
            await self.write_resp(req.req_user)
            if (req.req_cmd == SimpleBusCMD.WriteLast.value):
                break

            req = await self.get_req()
            addr += 8

    async def response_once(self):
        req: SimplebusSeqItem = await self.get_req()
        if (req.req_cmd == SimpleBusCMD.ReadBurst or \
            req.req_cmd == SimpleBusCMD.Read):
            data_pkt = []
            firstaddr = req.req_addr & 0xffffffc0
            id = (req.req_addr - firstaddr) >> 3
            for _ in range(1 << req.req_size):
                if (firstaddr + (id << 3) in self.data):
                    data_pkt.append(self.data[firstaddr + (id << 3)])
                else:
                    data_pkt.append(0)
                id = (id + 1) % (1 << req.req_size)
            await self.read_resp(req.req_size, data_pkt)

        elif (req.req_cmd == SimpleBusCMD.WriteBurst):
            await self.response_write_burst(req)

        elif (req.req_cmd == SimpleBusCMD.Write):
            addr, data, wmask = req.req_addr & 0xfffffff8, req.req_wdata, req.req_wmask
            wmask = replicate_bits(wmask, 8, 8)
            if addr not in self.data:
                self.data[addr] = 0
            self.data[addr] = (self.data[addr] & (~wmask)) | (data & wmask)
            await self.write_resp(req.req_user)

    async def body(self):
        while True:
            await self.response_once()


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
    dut.io_flush.value = 0

    dut.reset.value = 1
    await RisingEdge(dut.clock)
    dut.reset.value = 0
    for _ in range(10):
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
            "req_ready": self.dut.io_in_req_ready,
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
        ConfigDB().set(None, "*", "mem_if", self.mem_if)
        self.env = CacheEnv("env", self)

    def end_of_elaboration_phase(self):
        self.random_seq = RandomSeq.create("random_seq")
        self.mem_seq = MemorySeq.create("mem_seq")

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)

        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        mem_seqr = ConfigDB().get(self, "env.mem_agent.seqr", "SEQR")

        cocotb.start_soon(self.mem_seq.start(mem_seqr))
        await self.random_seq.start(in_seqr)
        self.drop_objection()

