from mlvp.model import *

class AXI4RefModel(Model):
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
