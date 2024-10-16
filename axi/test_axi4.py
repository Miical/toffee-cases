
import random
import pytest
from mlvp import *
from mlvp.triggers import *
from UT_AXI4RAM import DUTAXI4RAM
from axi4_env import AXI4Bundle, AXI4Env

@pytest.mark.mlvp_async
async def test_random(mlvp_request):
    env: AXI4Env = await mlvp_request()

    for _ in range(1000):
        addr = random.randint(0, (4<<5)-1) >> 3 << 3
        data = [random.randint(0, (1<<64)-1) for _ in range(random.randint(1, (1<<4)-1))]
        await env.in_agent.write(addr, data)
        await env.in_agent.read(addr, len(data))

@pytest.fixture()
def mlvp_request(mlvp_pre_request: PreRequest):
    dut = mlvp_pre_request.create_dut(DUTAXI4RAM, "clock", "AXI4RAM.fst")

    async def start_code():
        start_clock(dut)
        dut.reset.value = 1
        await triggers.ClockCycles(dut, 10)
        dut.reset.value = 0
        return AXI4Env(AXI4Bundle.from_prefix("io_in_").bind(dut))
    return start_code
