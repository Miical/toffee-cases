from pyuvm import *
from simplebus_agent import SimplebusSeqItem, SimplebusMasterAgent, SimplebusSeqItemType, SimplebusSlaveAgent

# class AdderScoreboard(uvm_scoreboard):
#     class AnalysisExport(uvm_analysis_export):
#         def __init__(self, *args, **kwargs):
#             super().__init__(*args, **kwargs)
#             self.mem = {}
#             self.std_item = AXISeqItem()

#         def write(self, seq_item):
#             if seq_item.tr_type == AXISeqItemType.WRITE:
#                 for i, d in enumerate(seq_item.data):
#                     self.mem[(seq_item.addr >> 3) + i] = d
#                 self.std_item.tr_type = AXISeqItemType.WRITE_RESP
#             elif seq_item.tr_type == AXISeqItemType.READ:
#                 self.std_item.tr_type = AXISeqItemType.READ_RESP
#                 self.std_item.data = [self.mem.get((seq_item.addr >> 3) + i, 0) for i in range(seq_item.len)]
#                 self.std_item.len = seq_item.len
#             else:
#                 if self.std_item != seq_item:
#                     self.logger.error("SCOREBOARD_MISMATCH", f"Expected: {self.std_item}, Got: {seq_item}")
#                 else:
#                     self.logger.info("SCOREBOARD_MATCH")

#     def build_phase(self):
#         super().build_phase()
#         self.ap_analysis_export = AdderScoreboard.AnalysisExport("ap_analysis_export", self)

class CacheEnv(uvm_env):
    def build_phase(self):
        self.in_agent = SimplebusMasterAgent("in_agent", self)
        self.mem_agent = SimplebusSlaveAgent("mem_agent", self)
        # self.scoreboard = AdderScoreboard("scoreboard", self)

    def connect_phase(self):
        ...
        # self.agent.ap.connect(self.scoreboard.ap_analysis_export)
