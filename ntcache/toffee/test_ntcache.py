from random import randint
from base_test import *

@toffee_test.testcase
async def test_read(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(25000):
        await env.in_agent.read(randint(0, (1<<32)-1), 4, randint(0, 0xff))

@toffee_test.testcase
async def test_write(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(10000):
        await env.in_agent.write(randint(0, (1<<32)-1), 4, randint(0, (1<<64)-1), randint(0, 0xff), randint(0, 0xff))

@toffee_test.testcase
async def test_random_read_write(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(15000):
        if randint(0, 1):
            await env.in_agent.read(randint(0, (1<<32)-1), 4, randint(0, 0xff))
        else:
            await env.in_agent.write(randint(0, (1<<32)-1), 4, randint(0, (1<<64)-1), randint(0, 0xff), randint(0, 0xff))

@toffee_test.testcase
async def test_read_write_same_addr(start_func):
    env: NTCacheEnv = await start_func()
    for _ in range(8000):
        addr = randint(0, (1<<32)-1)
        await env.in_agent.write(addr, 4, randint(0, (1<<64)-1), randint(0, 0xff), randint(0, 0xff))
        await env.in_agent.read(addr, 4, randint(0, 0xff))

@toffee_test.testcase
async def test_read_write_same_group(start_func):
    env: NTCacheEnv = await start_func()
    for group in range(1<<7):
        for _ in range(60):
            addr = (randint(1, (1<<19)-1)<<13) + (group<<6) + randint(0, (1<<6)-1)
            await env.in_agent.write(addr, 4, randint(0, (1<<64)-1), randint(0, 0xff), randint(0, 0xff))
            await env.in_agent.read(addr, 4, randint(0, 0xff))
