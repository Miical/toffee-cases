
import random
import pytest
from mlvp import *
from mlvp.triggers import *
from UT_AXI4RAM import DUTAXI4RAM
from axi4_env import AXI4Bundle, AXI4Env

@pytest.mark.mlvp_async
async def test_random(mlvp_request):
    env: AXI4Env = await mlvp_request()

    async def timeout_exit():
        await ClockCycles(env.in_agent.bundle, 1000)
        exit(-1)
    async with Executor(exit="none") as exec:
        exec(timeout_exit())

    await env.in_agent.write(0, [1, 2, 3, 4])
    print(await env.in_agent.read(0, 12))


@pytest.fixture()
def mlvp_request(mlvp_pre_request: PreRequest):
    dut = mlvp_pre_request.create_dut(DUTAXI4RAM, "clock", "AXI4RAM.fst")
    setup_logging(INFO)

    async def start_code():
        start_clock(dut)
        dut.reset.value = 1
        await triggers.ClockCycles(dut, 10)
        dut.reset.value = 0
        return AXI4Env(AXI4Bundle.from_prefix("io_in_").bind(dut))
    return start_code
