import random
from base_test import *

@toffee_test.testcase
async def test_read(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(1000):
        await env.in_agent.read(
            addr = random.randint(0, 0xffffffff),
            size = 4,
            user = random.randint(0, 0xff),
        )

@toffee_test.testcase
async def test_write(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(1000):
        await env.in_agent.write(
            addr = random.randint(0, 0xffffffff),
            size = 4,
            wdata = random.randint(0, 0xff),
            wmask = random.randint(0, 0xff),
            user = random.randint(0, 0xff),
        )

@toffee_test.testcase
async def test_read_write_same_addr(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(1000):
        addr = random.randint(0, 0xffffffff)
        await env.in_agent.read(
            addr = addr,
            size = 4,
            user = random.randint(0, 0xff),
        )
        await env.in_agent.write(
            addr = addr,
            size = 4,
            wdata = random.randint(0, 0xff),
            wmask = random.randint(0, 0xff),
            user = random.randint(0, 0xff),
        )
