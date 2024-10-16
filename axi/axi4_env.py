from axi4_agent import AXI4Bundle, AXI4MasterAgent
from mlvp.env import *

class AXI4Env(Env):
    def __init__(self, axi4_bundle: AXI4Bundle):
        self.in_agent = AXI4MasterAgent(axi4_bundle)
