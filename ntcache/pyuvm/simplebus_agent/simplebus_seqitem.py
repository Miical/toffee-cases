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
        if self.tr_type != other.tr_type:
            return False
        if self.tr_type == SimplebusSeqItemType.REQ:
            return self.req_addr == other.req_addr and self.req_size == other.req_size and \
                   self.req_cmd == other.req_cmd and self.req_wmask == other.req_wmask and \
                   self.req_wdata == other.req_wdata and self.req_user == other.req_user
        elif self.tr_type == SimplebusSeqItemType.RESP:
            return self.resp_cmd == other.resp_cmd and self.resp_user == other.resp_user and \
                   self.resp_size == other.resp_size and self.resp_rdata == other.resp_rdata
        else:
            return True

    def __str__(self):
        if self.tr_type == SimplebusSeqItemType.REQ:
            return f"SimplebusSeqItem({self.tr_type}, addr: {hex(self.req_addr)}, req_size: {hex(self.req_size)}, \
                req_cmd: {hex(self.req_cmd)}, req_wmask: {hex(self.req_wmask)}, req_wdata: {self.req_wdata}, \
                req_user: {hex(self.req_user)})"
        elif self.tr_type == SimplebusSeqItemType.RESP:
            return f"SimplebusSeqItem({self.tr_type}, resp_cmd: {hex(self.resp_cmd)}, resp_user: {hex(self.resp_user)}, \
                resp_size: {hex(self.resp_size)}, resp_rdata: {self.resp_rdata})"
        else:
            return f"SimplebusSeqItem({self.tr_type})"
