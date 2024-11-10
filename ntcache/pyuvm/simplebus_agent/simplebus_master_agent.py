import cocotb
from pyuvm import *
from cocotb.triggers import *
from .simplebus_interface import SimpleBusCMD
from .simplebus_seqitem import SimplebusSeqItem, SimplebusSeqItemType

class SimplebusMasterDriver(uvm_driver):
    def build_phase(self):
        self.item = None
        self.bif = ConfigDB().get(self, "bif", "in_if")

    async def drive_a_pkt(self, seq_item):
        while self.bif.req_ready.value != 1:
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
        await RisingEdge(self.bif.clock)

    async def get_response(self):
        self.bif.resp_ready.value = 1
        await RisingEdge(self.bif.clock)
        while self.bif.resp_valid.value == 0:
            await RisingEdge(self.bif.clock)
        self.bif.resp_ready.value = 0

        self.item.resp_user = int(self.bif.resp_user.value)
        self.item.resp_cmd = int(self.bif.resp_cmd.value)
        self.item.resp_rdata.append(int(self.bif.resp_rdata.value))
        RisingEdge(self.bif.clock)

    async def run_phase(self):
        while True:
            self.item = await self.seq_item_port.get_next_item()
            assert self.item.tr_type == SimplebusSeqItemType.REQ
            await self.drive_a_pkt(self.item)
            await self.get_response()
            self.seq_item_port.put_response(self.item)
            self.seq_item_port.item_done()

class SimplebusMasterMonitor(uvm_monitor):
    def build_phase(self):
        self.req_ap = uvm_analysis_port("req_ap", self)
        self.resp_ap = uvm_analysis_port("resp_ap", self)
        self.bif = ConfigDB().get(self, "bif", "in_if")

    async def collect_req_pkt(self):
        for _ in range(100):
            await RisingEdge(self.bif.clock)

        while True:
            item = SimplebusSeqItem("req_item")
            while True:
                if self.bif.req_valid.value == 1 and self.bif.req_ready.value == 1:
                    break
                await RisingEdge(self.bif.clock)

            item.tr_type = SimplebusSeqItemType.REQ
            item.req_addr = int(self.bif.req_addr.value)
            item.req_size = int(self.bif.req_size.value)
            item.req_cmd = int(self.bif.req_cmd.value)
            item.req_wmask = int(self.bif.req_wmask.value)
            item.req_wdata = int(self.bif.req_wdata.value)
            item.req_user = int(self.bif.req_user.value)
            self.req_ap.write(item)
            await RisingEdge(self.bif.clock)

    async def collect_resp_pkt(self):
        for _ in range(100):
            await RisingEdge(self.bif.clock)

        while True:
            item = SimplebusSeqItem("resp_item")
            while True:
                await RisingEdge(self.bif.clock)
                if self.bif.resp_valid.value == 1 and self.bif.resp_ready.value == 1:
                    break

            item.tr_type = SimplebusSeqItemType.RESP
            item.resp_cmd = int(self.bif.resp_cmd.value)
            if item.resp_cmd == SimpleBusCMD.ReadLast:
                item.resp_rdata.append(int(self.bif.resp_rdata.value))
            item.resp_user = int(self.bif.resp_user.value)
            self.resp_ap.write(item)
            await RisingEdge(self.bif.clock)

    async def run_phase(self):
        cocotb.start_soon(self.collect_req_pkt())
        cocotb.start_soon(self.collect_resp_pkt())

class SimplebusMasterAgent(uvm_agent):
    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        self.driver = SimplebusMasterDriver("driver", self)
        self.monitor = SimplebusMasterMonitor("monitor", self)
        ConfigDB().set(self, "*", "SEQR", self.seqr)

    def connect_phase(self):
        self.req_ap = self.monitor.req_ap
        self.resp_ap = self.monitor.resp_ap
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
