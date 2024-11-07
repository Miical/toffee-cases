
import random
from toffee import *
import toffee_test
from UT_AXI4RAM import DUTAXI4RAM
from axi4_env import AXI4Bundle, AXI4Env
from hypothesis import given, settings, HealthCheck, strategies as st

@toffee_test.testcase
async def test_read_once(axi4_env: AXI4Env):
    for _ in range(30000):
        await axi4_env.in_agent.read(random.randint(0, (1<<12)-1) >> 3 << 3, 1)

@toffee_test.testcase
async def test_read_burst(axi4_env: AXI4Env):
    for _ in range(10000):
        await axi4_env.in_agent.read(random.randint(0, (1<<11)-1) >> 3 << 3, random.randint(1, 16))

@toffee_test.testcase
async def test_write_once(axi4_env: AXI4Env):
    for _ in range(30000):
        await axi4_env.in_agent.write(random.randint(0, (1<<12)-1) >> 3 << 3, [random.randint(0, (1<<64)-1)])

@toffee_test.testcase
async def test_write_burst(axi4_env: AXI4Env):
    for _ in range(10000):
        await axi4_env.in_agent.write(
            random.randint(0, (1<<11)-1) >> 3 << 3,
            [random.randint(0, (1<<64)-1) for _ in range(random.randint(1, 16))])

@toffee_test.testcase
async def test_read_and_write_same_addr(axi4_env: AXI4Env):
    for _ in range(5000):
        addr = random.randint(0, (1<<11)-1) >> 3 << 3
        data = [random.randint(0, (1<<64)-1) for _ in range(random.randint(1, 16))]
        await axi4_env.in_agent.write(addr, data)
        await axi4_env.in_agent.read(addr, len(data))

@toffee_test.testcase
async def test_random_read_and_write(axi4_env: AXI4Env):
    for _ in range(10000):
        addr = random.randint(0, (1<<10)-1) >> 3 << 3
        data = [random.randint(0, (1<<64)-1) for _ in range(random.randint(1, 16))]
        if random.choice([True, False]):
            await axi4_env.in_agent.write(addr, data)
        else:
            await axi4_env.in_agent.read(addr, len(data))

@toffee_test.fixture
async def axi4_env(toffee_request: toffee_test.ToffeeRequest):
    dut = toffee_request.create_dut(DUTAXI4RAM, "clock", "AXI4RAM.fst")
    start_clock(dut)
    return AXI4Env(AXI4Bundle.from_prefix("io_in_").bind(dut))
