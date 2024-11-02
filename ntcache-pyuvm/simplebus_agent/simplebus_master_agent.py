import cocotb
from pyuvm import *
from cocotb.triggers import *
from .simplebus_seqitem import SimplebusSeqItem, SimplebusSeqItemType

class SimplebusMasterDriver(uvm_driver):
    def build_phase(self):
        self.bif = ConfigDB().get(None, "", "in_if")

    async def drive_a_pkt(self, seq_item):
        while self.bif.req_ready.value == 0:
            await RisingEdge(self.bif.clock)

        self.bif.req_valid.value = 1
        self.bif.req_addr.value = seq_item.req_addr
        self.bif.req_size.value = seq_item.req_size
        self.bif.req_cmd.value = seq_item.req_cmd
        self.bif.req_wmask.value = seq_item.req_wmask
        self.bif.req_wdata.value = seq_item.req_wdata
        self.bif.req_user.value = seq_item.req_user

        await RisingEdge(self.bif.clock)
        self.bif.req_valid.value = 0

    async def get_response(self):
        self.bif.resp_ready.value = 1
        while self.bif.resp_valid.value == 0:
            await RisingEdge(self.bif.clock)
        self.bif.resp_ready.value = 0

        item = SimplebusSeqItem("master_resp")
        item.resp_user = self.bif.resp_user.value
        item.resp_cmd = self.bif.resp_cmd.value
        item.resp_rdata.append(self.bif.resp_rdata.value)
        return item

    async def run_phase(self):
        while True:
            seq_item = await self.seq_item_port.get_next_item()
            print(seq_item)
            assert seq_item.tr_type == SimplebusSeqItemType.REQ
            await self.drive_a_pkt(seq_item)
            resp_item = await self.get_response()
            await self.seq_item_port.put_response(resp_item)
            self.seq_item_port.item_done()

class AXIMasterMonitor(uvm_monitor):
    def build_phase(self):
        self.ap = uvm_analysis_port("ap", self)
        self.dut = cocotb.top

    async def run_phase(self):
        ...

class SimplebusMasterAgent(uvm_agent):
    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        self.driver = SimplebusMasterDriver("driver", self)
        # self.monitor = AXIMonitor("monitor", self)
        ConfigDB().set(None, "*", "SEQR", self.seqr)

    def connect_phase(self):
        # self.ap = self.monitor.ap
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
