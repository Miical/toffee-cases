import pytest
from mlvp import *
from UT_Cache import DUTCache
from ntcache_env import *

def replicate_bits(binary_num, replication, num_bits):
    result = 0
    for i in range(num_bits):
        bit = (binary_num >> i) & 1
        for j in range(replication):
            result = result | (bit << (i * replication + j))
    return result

class SimpleBusRam:
    def __init__(self, agent: SimpleBusSlaveAgent):
        self.data = {}
        self.agent = agent

    async def response_write_burst(self, req):
        addr = req["addr"]
        while (True):
            data, wmask = req["wdata"], req["wmask"]
            wmask = replicate_bits(wmask, 8, 8)
            if addr not in self.data:
                self.data[addr] = 0
            self.data[addr] = (self.data[addr] & (~wmask)) | (data & wmask)
            await self.agent.write_resp()
            if (req["cmd"] == SimpleBusCMD.WriteLast):
                break

            req = await self.agent.get_req()
            addr += 8

    async def response_once(self):
        req = await self.agent.get_req()
        if (req["cmd"] == SimpleBusCMD.ReadBurst or \
            req["cmd"] == SimpleBusCMD.Read):
            data_pkt = []
            firstaddr = req["addr"] & 0xffffffc0
            id = (req["addr"] - firstaddr) >> 3
            for _ in range(1 << req["size"]):
                if (firstaddr + (id << 3) in self.data):
                    data_pkt.append(self.data[firstaddr + (id << 3)])
                else:
                    data_pkt.append(0)
                id = (id + 1) % (1 << req["size"])
            await self.agent.read_resp(req["size"], data_pkt)

        elif (req["cmd"] == SimpleBusCMD.WriteBurst):
            await self.response_write_burst(req)

        elif (req["cmd"] == SimpleBusCMD.Write):
            addr, data, wmask = req["addr"] & 0xfffffff8, req["wdata"], req["wmask"]
            wmask = replicate_bits(wmask, 8, 8)
            if addr not in self.data:
                self.data[addr] = 0
            self.data[addr] = (self.data[addr] & (~wmask)) | (data & wmask)
            await self.agent.write_resp()

    async def work(self):
        while True:
            await self.response_once()

@pytest.fixture
def start_func(mlvp_pre_request: PreRequest):
    setup_logging(ERROR)
    dut = mlvp_pre_request.create_dut(DUTCache, "clock", "Cache.fst")

    async def start_code():
        start_clock(dut)
        dut.reset.value = 1
        await triggers.ClockCycles(dut, 1)
        dut.reset.value = 0
        dut.io_out_mem_req_ready.value = 1
        dut.io_in_resp_ready.value = 1
        await triggers.AllValid(dut.io_in_req_ready)

        env = NTCacheEnv(dut)
        async with Executor(exit="none") as exec:
            exec(SimpleBusRam(env.mem_agent).work(),sche_group="mmio")
            exec(SimpleBusRam(env.mmio_agent).work(), sche_group="mem")

        return env
    return start_code
