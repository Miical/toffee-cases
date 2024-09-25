import pytest
from mlvp import *
from UT_Cache import DUTCache
from ntcache_env import NTCacheEnv

@pytest.fixture
def cache_dut(mlvp_pre_request: PreRequest):
    return mlvp_pre_request.create_dut(DUTCache, "clock")


@pytest.mark.mlvp_async
async def test_read(cache_dut: DUTCache):
    env = NTCacheEnv(cache_dut)
