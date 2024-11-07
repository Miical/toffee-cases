import copy
from pyuvm import *
from adder_agent import AdderSeqItem, AdderAgent

class AdderScoreboard(uvm_scoreboard):
    class AnalysisExport(uvm_analysis_export):
        def write(self, seq_item):
            std_item = copy.deepcopy(seq_item)
            result = std_item.a + std_item.b + std_item.cin
            std_item.sum = result & ((1 << 64) - 1)
            std_item.cout = result >> 64

            if std_item != seq_item:
                self.logger.error("SCOREBOARD_MISMATCH", f"Expected: {std_item}, Got: {seq_item}")
            else:
                self.logger.info("SCOREBOARD_MATCH")

    def build_phase(self):
        super().build_phase()
        self.ap_analysis_export = AdderScoreboard.AnalysisExport("ap_analysis_export", self)


class AdderEnv(uvm_env):
    def build_phase(self):
        self.agent = AdderAgent("agent", self)
        self.scoreboard = AdderScoreboard("scoreboard", self)

    def connect_phase(self):
        self.agent.ap.connect(self.scoreboard.ap_analysis_export)
