from pyuvm import *
from simplebus_agent import SimplebusSeqItem, SimplebusMasterAgent, SimplebusSeqItemType, SimplebusSlaveAgent, SimpleBusCMD
from utils import replicate_bits

class CacheScoreboard(uvm_scoreboard):
    class ReqAnalysisExport(uvm_analysis_export):
        def __init__(self, name, parent, std_item: SimplebusSeqItem):
            super().__init__(name, parent)

            self.data = {}
            self.std_item = std_item

        def cache_read(self, seq_item):
            addr = seq_item.req_addr
            self.std_item.tr_type = SimplebusSeqItemType.RESP
            self.std_item.resp_cmd = SimpleBusCMD.ReadLast
            self.std_item.resp_user = seq_item.req_user
            self.std_item.resp_rdata = [self.data.get(addr, 0)]

        def cache_write(self, seq_item):
            addr = seq_item.req_addr
            data = seq_item.req_wdata
            wmask = replicate_bits(seq_item.req_wmask, 8, 8)
            if (addr not in self.data):
                self.data[addr] = 0
            self.data[addr] = (self.data[addr] & (~wmask)) | (data & wmask)

            self.std_item.tr_type = SimplebusSeqItemType.RESP
            self.std_item.resp_cmd = SimpleBusCMD.WriteResp
            self.std_item.resp_user = seq_item.req_user
            self.std_item.resp_rdata = []

        def write(self, seq_item):
            assert seq_item.tr_type == SimplebusSeqItemType.REQ

            if seq_item.req_cmd == SimpleBusCMD.Read:
                self.cache_read(seq_item)
            elif seq_item.req_cmd == SimpleBusCMD.Write:
                self.cache_write(seq_item)
            else:
                raise ValueError("Invalid command")

    class RespAnalysisExport(uvm_analysis_export):
        def __init__(self, name, parent, std_item):
            super().__init__(name, parent)

            self.std_item = std_item

        def write(self, seq_item):
            assert seq_item.tr_type == SimplebusSeqItemType.RESP

            if self.std_item != seq_item:
                self.logger.error("SCOREBOARD_MISMATCH", f"Expected: {self.std_item}, Got: {seq_item}")
            else:
                self.logger.info("SCOREBOARD_MATCH")

    def build_phase(self):
        super().build_phase()
        self.std_item = SimplebusSeqItem("std_item")
        self.req_export = CacheScoreboard.ReqAnalysisExport("req_export", self, self.std_item)
        self.resp_export = CacheScoreboard.RespAnalysisExport("resp_export", self, self.std_item)

class CacheEnv(uvm_env):
    def build_phase(self):
        self.in_agent = SimplebusMasterAgent("in_agent", self)
        self.mem_agent = SimplebusSlaveAgent("mem_agent", self)
        self.mmio_agent = SimplebusSlaveAgent("mmio_agent", self)
        self.scoreboard = CacheScoreboard("scoreboard", self)

    def connect_phase(self):
        self.in_agent.req_ap.connect(self.scoreboard.req_export)
        self.in_agent.resp_ap.connect(self.scoreboard.resp_export)
