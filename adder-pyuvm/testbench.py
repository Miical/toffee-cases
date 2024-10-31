import pyuvm
import random
from pyuvm import *
from adder_env import AdderEnv, AdderSeqItem
from cocotb.triggers import *

class RandomSeq(uvm_sequence):
    async def body(self):
        for _ in range(10000):
            seq_item = AdderSeqItem()
            seq_item.randomize()
            await self.start_item(seq_item)
            await self.finish_item(seq_item)

class BounarySeq(uvm_sequence):
    async def body(self):
        for _ in range(1000):
            for a in [0, 2**64-1]:
                for b in [0, 2**64-1]:
                    cin = random.randint(0, 1)
                    seq_item = AdderSeqItem(a=a, b=b, cin=cin)
                    await self.start_item(seq_item)
                    await self.finish_item(seq_item)

@pyuvm.test()
class AdderRandomTest(uvm_test):
    def build_phase(self):
        self.env = AdderEnv("env", self)

    def end_of_elaboration_phase(self):
        self.random_seq= RandomSeq.create("random_seq")

    async def run_phase(self):
        self.raise_objection()
        seqr = ConfigDB().get(None, "", "SEQR")
        await self.random_seq.start(seqr)
        self.drop_objection()

@pyuvm.test()
class AdderBoundaryTest(uvm_test):
    def build_phase(self):
        self.env = AdderEnv("env", self)

    def end_of_elaboration_phase(self):
        self.boundary_seq= BounarySeq.create("boundary_seq")

    async def run_phase(self):
        self.raise_objection()
        seqr = ConfigDB().get(None, "", "SEQR")
        await self.boundary_seq.start(seqr)
        self.drop_objection()
