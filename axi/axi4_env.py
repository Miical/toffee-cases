from axi4_agent import AXI4Bundle, AXI4MasterAgent
from axi4_refmodel import AXI4RefModel
from mlvp.env import *

class AXI4Env(Env):
    def __init__(self, axi4_bundle: AXI4Bundle):
        super().__init__()

        self.in_agent = AXI4MasterAgent(axi4_bundle)
        self.attach(AXI4RefModel())
