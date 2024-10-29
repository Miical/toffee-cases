from toffee import *
import toffee_test
from random import randint
from UT_Adder import DUTAdder
from env import AdderEnv, AdderBundle

@toffee_test.testcase
async def test_random(adder_env):
    for _ in range(10000):
        await adder_env.add_agent.exec_add(randint(0, 2**64-1), randint(0, 2**64-1), randint(0, 1))

@toffee_test.testcase
async def test_boundary(adder_env):
    for _ in range(1000):
        for a in [0, 2**64-1]:
            for b in [0, 2**64-1]:
                await adder_env.add_agent.exec_add(a, b, randint(0, 1))

@toffee_test.fixture
async def adder_env(toffee_request: toffee_test.ToffeeRequest):
    dut = toffee_request.create_dut(DUTAdder)
    start_clock(dut)
    return AdderEnv(AdderBundle.from_prefix("io_").bind(dut))
