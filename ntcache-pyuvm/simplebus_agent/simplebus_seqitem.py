import random
from enum import Enum
from pyuvm import *

class SimplebusSeqItemType(Enum):
    REQ = 0
    RESP = 1
    GET_REQ = 2

class SimplebusSeqItem(uvm_sequence_item):
    def __init__(self, name="SimplebusSeqItem"):
        super().__init__(name)

        self.tr_type = SimplebusSeqItemType.REQ
        self.req_addr = 0
        self.req_size = 0
        self.req_cmd = 0
        self.req_wmask = 0
        self.req_wdata = 0
        self.req_user = 0

        self.resp_cmd = 0
        self.resp_user = 0
        self.resp_size = 0
        self.resp_rdata = []

    def randomize(self):
        self.req_addr = random.randint(0, 2**32-1)
        self.req_size = random.randint(0, 2**3-1)
        self.req_cmd = random.randint(0, 2**4-1)
        self.req_wmask = random.randint(0, 2**8-1)
        self.req_wdata = random.randint(0, 2**64-1)
        self.req_user = random.randint(0, 2**16-1)

        self.resp_cmd = random.randint(0, 2**4-1)
        self.resp_user = random.randint(0, 2**16-1)
        self.resp_size = random.randint(0, 2**3-1)
        self.resp_rdata = [random.randint(0, 2**64-1) for _ in range(8)]

    def __eq__(self, other):
        ...

    def __str__(self):
        return f"SimplebusSeqItem({self.tr_type}, {self.req_addr}, {self.req_size}, {self.req_cmd}, {self.req_wmask}, \
            {self.req_wdata}, {self.req_user}, {self.resp_cmd}, {self.resp_user}, {self.resp_size}, {self.resp_rdata})"
