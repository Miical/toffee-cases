import cocotb.clock
import pyuvm
from random import randint, choice
import cocotb
from pyuvm import *
from simplebus_agent import SimplebusInterface, SimpleBusCMD, SimplebusSeqItemType, SimplebusSeqItem
from cache_env import CacheEnv
from cocotb.triggers import *
from utils import replicate_bits

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
        seq_item.resp_cmd = SimpleBusCMD.WriteResp
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
            if (req.req_cmd == SimpleBusCMD.WriteLast):
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
    dut.io_flush.value = 0
    dut.reset.value = 1
    await RisingEdge(dut.clock)
    dut.reset.value = 0
    for _ in range(10):
        await RisingEdge(dut.clock)

async def generate_clock(dut):
    while True:
        dut.clock.value = 0
        await Timer(10000, units="ns")
        dut.clock.value = 1
        await Timer(10000, units="ns")

class BaseTest(uvm_test):
    def build_phase(self):
        self.dut = cocotb.top
        self.in_if = SimplebusInterface({
            "reset": self.dut.reset,
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
            "reset": self.dut.reset,
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
            "reset": self.dut.reset,
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

        ConfigDB().set(self, "env.in_agent.driver.bif", "in_if", self.in_if)
        ConfigDB().set(self, "env.in_agent.monitor.bif", "in_if", self.in_if)
        ConfigDB().set(self, "env.mem_agent.driver.bif", "out_if", self.mem_if)
        ConfigDB().set(self, "env.mmio_agent.driver.bif", "out_if", self.mmio_if)
        self.env = CacheEnv("env", self)

    def end_of_elaboration_phase(self):
        self.mem_seq = MemorySeq.create("mem_seq")
        self.mmio_seq = MemorySeq.create("mmio_seq")

    async def run_phase(self):
        cocotb.start_soon(generate_clock(cocotb.top))
        await init_dut(cocotb.top)
        mem_seqr = ConfigDB().get(self, "env.mem_agent.seqr", "SEQR")
        mmio_seqr = ConfigDB().get(self, "env.mmio_agent.seqr", "SEQR")
        cocotb.start_soon(self.mem_seq.start(mem_seqr))
        cocotb.start_soon(self.mmio_seq.start(mmio_seqr))

class ReadSequence(uvm_sequence):
    async def body(self):
        for _ in range(25000):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.randomize()
            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.req_cmd = SimpleBusCMD.Read
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            await self.get_response()

@pyuvm.test()
class TestRead(BaseTest):
    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.random_seq = ReadSequence.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        await super().run_phase()
        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        await self.random_seq.start(in_seqr)
        self.drop_objection()

class WriteSequence(uvm_sequence):
    async def body(self):
        for _ in range(10000):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.randomize()
            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.req_cmd = SimpleBusCMD.Write
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            await self.get_response()

@pyuvm.test()
class TestWrite(BaseTest):
    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.random_seq = WriteSequence.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        await super().run_phase()
        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        await self.random_seq.start(in_seqr)
        self.drop_objection()

class RandomReadWriteSequence(uvm_sequence):
    async def body(self):
        for _ in range(15000):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.randomize()
            seq_item.tr_type = SimplebusSeqItemType.REQ
            if choice([True, False]):
                seq_item.req_cmd = SimpleBusCMD.Read
            else:
                seq_item.req_cmd = SimpleBusCMD.Write
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            await self.get_response()

@pyuvm.test()
class TestRandomReadWrite(BaseTest):
    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.random_seq = RandomReadWriteSequence.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        await super().run_phase()
        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        await self.random_seq.start(in_seqr)
        self.drop_objection()

class ReadWriteSameAddrSequence(uvm_sequence):
    async def body(self):
        for _ in range(8000):
            seq_item = SimplebusSeqItem("RandomSeqItem")
            seq_item.randomize()
            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.req_cmd = SimpleBusCMD.Write
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            await self.get_response()

            seq_item.tr_type = SimplebusSeqItemType.REQ
            seq_item.req_cmd = SimpleBusCMD.Read
            await self.start_item(seq_item)
            await self.finish_item(seq_item)
            await self.get_response()

@pyuvm.test()
class TestReadWriteSameAddr(BaseTest):
    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.random_seq = ReadWriteSameAddrSequence.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        await super().run_phase()
        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        await self.random_seq.start(in_seqr)
        self.drop_objection()

class ReadWriteSameGroupSequence(uvm_sequence):
    async def body(self):
        for group in range(1<<7):
            for _ in range(60):
                seq_item = SimplebusSeqItem("RandomSeqItem")
                seq_item.randomize()
                seq_item.tr_type = SimplebusSeqItemType.REQ
                seq_item.req_cmd = SimpleBusCMD.Write
                seq_item.req_addr = (randint(1, (1<<19)-1)<<13) + (group<<6) + randint(0, (1<<6)-1)
                await self.start_item(seq_item)
                await self.finish_item(seq_item)
                await self.get_response()

                seq_item.tr_type = SimplebusSeqItemType.REQ
                seq_item.req_cmd = SimpleBusCMD.Read
                await self.start_item(seq_item)
                await self.finish_item(seq_item)
                await self.get_response()

@pyuvm.test()
class TestReadWriteSameGroup(BaseTest):
    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.random_seq = ReadWriteSameGroupSequence.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        await super().run_phase()
        in_seqr = ConfigDB().get(self, "env.in_agent.seqr", "SEQR")
        await self.random_seq.start(in_seqr)
        self.drop_objection()
