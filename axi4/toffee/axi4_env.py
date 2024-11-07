from axi4_agent import AXI4Bundle, AXI4MasterAgent
from toffee import *

class AXI4Model(Model):
    def __init__(self):
        super().__init__()
        self.mem = {}

    @driver_hook(agent_name="in_agent")
    def read(self, addr, len):
        return [self.mem.get((addr >> 3) + i, 0) for i in range(len)]

    @driver_hook(agent_name="in_agent")
    def write(self, addr, data):
        for i, d in enumerate(data):
            self.mem[(addr >> 3) + i] = d
        return 0

class AXI4Env(Env):
    def __init__(self, axi4_bundle: AXI4Bundle):
        super().__init__()

        self.in_agent = AXI4MasterAgent(axi4_bundle)
        self.attach(AXI4Model())
