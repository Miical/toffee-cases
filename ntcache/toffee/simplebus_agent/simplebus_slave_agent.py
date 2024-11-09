from toffee import *
from .simplebus_bundle import *

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
        self.bundle.resp.assign({"valid": 1, "cmd": SimpleBusCMD.WriteResp, "user": user})
        await self.bundle.step()
        self.bundle.resp.valid.value = 0

    @driver_method()
    async def get_req(self):
        self.bundle.req.ready.value = 1
        await AllValid(self.bundle.req.valid)
        req = self.bundle.req.as_dict()
        self.bundle.req.ready.value = 0
        return req
