import cocotb
import random
from pyuvm import *
from cocotb.triggers import *

clock_period = 1000
half_period = clock_period // 2

class AdderSeqItem(uvm_sequence_item):
    def __init__(self, name="AdderSeqItem", a=0, b=0, cin=0, sum=0, cout=0):
        super().__init__(name)
        self.a = a
        self.b = b
        self.cin = cin
        self.sum = sum
        self.cout = cout

    def randomize(self):
        self.a = random.randint(0, 2**64-1)
        self.b = random.randint(0, 2**64-1)
        self.cin = random.randint(0, 1)

    def __eq__(self, other):
        return self.a == other.a and self.b == other.b and self.cin == other.cin and \
            self.sum == other.sum and self.cout == other.cout

    def __str__(self):
        return f"a={self.a}, b={self.b}, cin={self.cin}, sum={self.sum}, cout={self.cout}"

class AdderDriver(uvm_driver):
    def build_phase(self):
        self.dut = cocotb.top

    async def drive_a_pkt(self, seq_item):
        self.dut.io_a.value = seq_item.a
        self.dut.io_b.value = seq_item.b
        self.dut.io_cin.value = seq_item.cin
        await Timer(clock_period, units='ns')

    async def run_phase(self):
        while True:
            seq_item = await self.seq_item_port.get_next_item()
            await self.drive_a_pkt(seq_item)
            self.seq_item_port.item_done()

class AdderMonitor(uvm_monitor):
    def build_phase(self):
        self.ap = uvm_analysis_port("ap", self)
        self.dut = cocotb.top

    async def run_phase(self):
        while True:
            await Timer(clock_period, units='ns')
            seq_item = AdderSeqItem()
            seq_item.a = self.dut.io_a.value
            seq_item.b = self.dut.io_b.value
            seq_item.cin = self.dut.io_cin.value
            seq_item.sum = self.dut.io_sum.value
            seq_item.cout = self.dut.io_cout.value
            self.ap.write(seq_item)

class AdderAgent(uvm_agent):
    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        self.driver = AdderDriver("driver", self)
        self.monitor = AdderMonitor("monitor", self)
        ConfigDB().set(None, "*", "SEQR", self.seqr)

    def connect_phase(self):
        self.ap = self.monitor.ap
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
