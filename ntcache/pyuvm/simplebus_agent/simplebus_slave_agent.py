import cocotb
import cocotb.binary
from pyuvm import *
from cocotb.triggers import *
from .simplebus_seqitem import SimplebusSeqItem, SimplebusSeqItemType
from .simplebus_interface import SimpleBusCMD

class SimplebusSlaveDriver(uvm_driver):
    def build_phase(self):
        self.item = None
        self.bif = ConfigDB().get(self, "bif", "out_if")

    async def get_request(self):
        self.bif.req_ready.value = 1
        while True:
            await RisingEdge(self.bif.clock)
            if self.bif.req_valid.value == 1:
                break

        self.item.tr_type = SimplebusSeqItemType.REQ
        self.item.req_addr = int(self.bif.req_addr.value)
        self.item.req_size = int(self.bif.req_size.value)
        self.item.req_cmd = int(self.bif.req_cmd.value)
        self.item.req_wmask = int(self.bif.req_wmask.value)
        try:
            self.item.req_wdata = int(self.bif.req_wdata.value)
        except ValueError:
            self.item.req_wdata = 0
        self.item.req_user = int(self.bif.req_user.value)

        self.bif.req_ready.value = 0
        await RisingEdge(self.bif.clock)

    async def drive_response(self, seq_item, is_read_req):
        if is_read_req:
            while self.bif.resp_ready.value == 0:
                await RisingEdge(self.bif.clock)
            self.bif.resp_valid.value = 1
            for i in range(1 << seq_item.resp_size):
                self.bif.resp_cmd.value = SimpleBusCMD.ReadLast\
                    if (i == ((1 << seq_item.resp_size) - 1)) else SimpleBusCMD.Read
                self.bif.resp_rdata.value = seq_item.resp_rdata[i]
                await RisingEdge(self.bif.clock)

            self.bif.resp_valid.value = 0
            await RisingEdge(self.bif.clock)
        else:
            while self.bif.resp_ready.value == 0:
                await RisingEdge(self.bif.clock)
            self.bif.resp_valid.value = 1
            self.bif.resp_cmd.value = SimpleBusCMD.WriteResp
            self.bif.resp_user.value = seq_item.resp_user

            await RisingEdge(self.bif.clock)
            self.bif.resp_valid.value = 0
            await RisingEdge(self.bif.clock)

    async def run_phase(self):
        is_read_req = False
        while True:
            # get request
            self.item = await self.seq_item_port.get_next_item()
            assert self.item.tr_type == SimplebusSeqItemType.GET_REQ
            await self.get_request()
            is_read_req = (self.item.req_cmd == 0 or self.item.req_cmd == 2)
            self.seq_item_port.put_response(self.item)
            self.seq_item_port.item_done()

            # send response
            self.item = await self.seq_item_port.get_next_item()
            assert self.item.tr_type == SimplebusSeqItemType.RESP
            await self.drive_response(self.item, is_read_req)
            self.seq_item_port.item_done()

class SimplebusSlaveAgent(uvm_agent):
    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        self.driver = SimplebusSlaveDriver("driver", self)
        ConfigDB().set(self, "seqr", "SEQR", self.seqr)

    def connect_phase(self):
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
