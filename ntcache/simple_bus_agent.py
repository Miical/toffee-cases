from mlvp import Bundle, Signals
from mlvp.triggers import *
from mlvp.agent import *

"""
SimpleBusBundle
"""
from enum import Enum

class SimpleBusCMD():
    Read, Write, ReadBurst, WriteBurst, WriteLast, Probe, Prefetch = 0, 1, 2, 3, 7, 8, 4
    ReadLast, WriteResp, ProbeHit, ProbMiss = 6, 5, 12, 8

class DecoupledBundle(Bundle):
    ready, valid = Signals(2)

class SimpleBusRequestBundle(DecoupledBundle):
    addr, size, cmd, wmask, wdata, user = Signals(6)

class SimpleBusResponseBundle(DecoupledBundle):
    cmd, rdata, user = Signals(3)

class SimpleBusBundle(Bundle):
    req = SimpleBusRequestBundle.from_regex(r"^req_(?:(valid|ready)|bits_(.*))")
    resp = SimpleBusResponseBundle.from_regex(r"^resp_(?:(valid|ready)|bits_(.*))")

"""
SimpleBusAgent
"""

class SimpleBusMasterAgent(Agent):
    def __init__(self, bundle):
        super().__init__(bundle.step)
        self.bundle: SimpleBusBundle = bundle

    async def send_req(self, addr, size, cmd, user=0, wmask=0, wdata=0):
        await AllValid(self.bundle.req.ready, delay=0)
        self.bundle.req.assign({
            "valid": 1,
            "addr": addr,
            "size": size,
            "cmd": cmd,
            "user": user,
            "wmask": wmask,
            "wdata": wdata
        })
        await self.bundle.step()
        self.bundle.req.valid.value = 0

    async def get_resp(self):
        self.bundle.resp.ready.value = 1
        await AllValid(self.bundle.resp.valid)
        resp = self.bundle.resp.as_dict()
        self.bundle.resp.ready.value = 0
        return resp

    @driver_method()
    async def read(self, addr, size, user=0):
        self.send_req(addr, size, SimpleBusCMD.Read, user)
        return await self.get_resp()

    @driver_method()
    async def write(self, addr, size, wdata, wmask, user=0):
        await self.send_req(addr, size, SimpleBusCMD.Write, user, wmask, wdata)
        return await self.get_resp()

class SimpleBusSlaveAgent(Agent):
    def __init__(self, bundle):
        super().__init__(bundle.step)
        self.bundle: SimpleBusBundle = bundle

    @driver_method()
    async def read_resp(self, size, rdata: list, user=0):
        assert len(rdata) == 1 << size

        await AllValid(self.bundle.resp.ready, delay=0)
        self.bundle.resp.valid.value = 1
        for i in range(1 << size):
            self.bundle.resp.cmd.value = SimpleBusCMD.ReadLast if (i == ((1 << size) - 1)) else SimpleBusCMD.Read
            self.bundle.resp.rdata.value = rdata[i]
            await self.bundle.step()
        self.bundle.resp.valid.value = 0

    @driver_method()
    async def write_resp(self, user=0):
        await AllValid(self.bundle.resp.ready, delay=0)
        self.bundle.resp.assign({
            "valid": 1,
            "cmd": SimpleBusCMD.WriteResp,
            "user": user
        })
        await self.bundle.step()
        self.bundle.resp.valid.value = 0

    @driver_method()
    async def get_req(self):
        self.bundle.req.ready.value = 1
        await AllValid(self.bundle.req.valid)
        req = self.bundle.req.as_dict()
        self.bundle.req.ready.value = 0
        return req
