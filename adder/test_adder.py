import random
import pytest
from mlvp import *
from UT_Adder import DUTAdder
from env import AdderEnv, AdderBundle

@pytest.mark.mlvp_async
async def test_random(mlvp_request):
    env = mlvp_request()
    for _ in range(300000):
        a = random.randint(0, 2**64-1)
        b = random.randint(0, 2**64-1)
        cin = random.randint(0, 1)
        await env.add_agent.exec_add(a, b, cin)

@pytest.mark.mlvp_async
async def test_boundary(mlvp_request):
    env = mlvp_request()
    for _ in range(80000):
        for a in [0, 2**64-1]:
            for b in [0, 2**64-1]:
                await env.add_agent.exec_add(a, b, random.randint(0, 1))

@pytest.fixture()
def mlvp_request(mlvp_pre_request: PreRequest):
    dut = mlvp_pre_request.create_dut(DUTAdder)
    def start_code():
        start_clock(dut)
        return AdderEnv(AdderBundle.from_prefix("io_").bind(dut))
    return start_code
