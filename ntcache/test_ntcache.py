import pytest
from mlvp import *
from UT_Cache import DUTCache
from ntcache_env import *

@pytest.fixture
def start_func(mlvp_pre_request: PreRequest):
    setup_logging(INFO)
    dut = mlvp_pre_request.create_dut(DUTCache, "clock", "cache.fst")

    async def start_code():
        start_clock(dut)
        dut.reset.value = 1
        await triggers.ClockCycles(dut, 1)
        dut.reset.value = 0
        dut.io_out_mem_req_ready.value = 1
        dut.io_in_resp_ready.value = 1
        await triggers.AllValid(dut.io_in_req_ready)

        return NTCacheEnv(dut)
    return start_code

async def memory_task(mem_agent: SimpleBusSlaveAgent):
    while True:
        req = await mem_agent.get_req()
        if req["cmd"] == SimpleBusCMD.Read or req["cmd"] == SimpleBusCMD.ReadBurst:
            data = [0x1234] * (1 << req["size"])
            await mem_agent.read_resp(req["size"], data)
        elif req["cmd"] == SimpleBusCMD.Write or req["cmd"] == SimpleBusCMD.WriteBurst:
            await mem_agent.send_resp(SimpleBusCMD.WriteResp, 0)

@pytest.mark.mlvp_async
async def test_read(start_func):
    env = await start_func()

    async with Executor(exit="any") as exec:
        exec(memory_task(env.mem_agent))
        exec(env.in_agent.write(0x80000000, 4, 0x1234, 0xf, 0))
