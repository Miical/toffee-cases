from toffee import *
from .simplebus_bundle import *

class SimpleBusMasterAgent(Agent):
    def __init__(self, bundle):
        super().__init__(bundle.step)
        self.bundle: SimpleBusBundle = bundle

    async def send_req(self, addr, size, cmd, user=0, wmask=0, wdata=0):
        await AllValid(self.bundle.req.ready, delay=0)
        self.bundle.req.assign({
            "valid": 1,   "addr": addr,   "size": size,  "cmd": cmd,
            "user": user, "wmask": wmask, "wdata": wdata
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
        await self.send_req(addr, size, SimpleBusCMD.Read, user)
        resp = await self.get_resp()
        return {key:resp[key] for key in ["rdata", "user"]}

    @driver_method()
    async def write(self, addr, size, wdata, wmask, user=0):
        await self.send_req(addr, size, SimpleBusCMD.Write, user, wmask, wdata)
        resp = await self.get_resp()
        return {key:resp[key] for key in ["user"]}
