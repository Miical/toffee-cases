from simple_bus_agent import *
from mlvp.env import *

class NTCacheEnv(Env):
    def __init__(self, dut):
        super().__init__()
        in_bundle = SimpleBusBundle.from_prefix("io_in_").bind(dut)
        out_bundle = SimpleBusBundle.from_prefix("io_out_").bind(dut)
        mmio_bundle = SimpleBusBundle.from_prefix("io_mmio_").bind(dut)

        self.in_agent: SimpleBusAgent = SimpleBusAgent(in_bundle)
        self.out_agent: SimpleBusAgent = SimpleBusAgent(out_bundle)
        self.mmio_agent: SimpleBusAgent = SimpleBusAgent(mmio_bundle)
