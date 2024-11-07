
import random
from toffee import *
import toffee_test
from UT_AXI4RAM import DUTAXI4RAM
from axi4_env import AXI4Bundle, AXI4Env
from hypothesis import given, settings, HealthCheck, strategies as st

@settings(max_examples=100, suppress_health_check=[HealthCheck.function_scoped_fixture])
@given(
    addr=st.integers(0, (4<<5)-1).map(lambda x: (x>>3)<<3),
    data=st.lists(
        st.integers(min_value=0, max_value=(1<<64)-1),
        min_size=1, max_size=(1<<4)-1
    )
)
@toffee_test.testcase
async def test_read_and_write(init_code, addr, data):
    env: AXI4Env = await init_code()
    await env.in_agent.write(addr, data)
    await env.in_agent.read(addr, len(data))

@toffee_test.fixture
async def init_code(toffee_request: toffee_test.ToffeeRequest):
    setup_logging(INFO)
    dut = toffee_request.create_dut(DUTAXI4RAM, "clock", "AXI4RAM.fst")
    start_clock(dut)
    env = AXI4Env(AXI4Bundle.from_prefix("io_in_").bind(dut))
    async def start_code():
        dut.reset.value = 1
        await ClockCycles(dut)
        dut.reset.value = 0
        return env
    return start_code
