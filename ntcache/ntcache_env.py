from simple_bus_agent import *
from cache_ref import CacheRefModel
from mlvp.env import *

class NTCacheEnv(Env):
    def __init__(self, dut):
        super().__init__()
        in_bundle = SimpleBusBundle.from_prefix("io_in_").set_name("in").bind(dut)
        mem_bundle = SimpleBusBundle.from_prefix("io_out_mem_").set_name("mem").bind(dut)
        mmio_bundle = SimpleBusBundle.from_prefix("io_mmio_").set_name("mmio").bind(dut)

        self.in_agent = SimpleBusMasterAgent(in_bundle)
        self.mem_agent = SimpleBusSlaveAgent(mem_bundle)
        self.mmio_agent= SimpleBusSlaveAgent(mmio_bundle)

        self.attach(CacheRefModel())
