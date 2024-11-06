from typing import Any


class SimpleBusCMD():
    Read, Write, ReadBurst, WriteBurst, WriteLast, Probe, Prefetch = 0, 1, 2, 3, 7, 8, 4
    ReadLast, WriteResp, ProbeHit, ProbMiss = 6, 5, 12, 8

class DummySignal:
    def __getattribute__(self, name: str) -> Any:
        return None

    def __setattr__(self, name: str, value: Any) -> None:
        ...

class SimplebusInterface():
    def __init__(self, dict):
        self.clock = dict["clock"]
        self.req_ready = dict["req_ready"]
        self.req_valid = dict["req_valid"]
        self.req_addr = dict["req_addr"]
        self.req_size = dict["req_size"]
        self.req_cmd = dict["req_cmd"]
        self.req_wmask = dict["req_wmask"]
        self.req_wdata = dict["req_wdata"]
        self.req_user = dict["req_user"] if "req_user" in dict else DummySignal()

        self.resp_ready = dict["resp_ready"]
        self.resp_valid = dict["resp_valid"]
        self.resp_cmd = dict["resp_cmd"]
        self.resp_rdata = dict["resp_rdata"]
        self.resp_user = dict["resp_user"] if "resp_user" in dict else DummySignal()

