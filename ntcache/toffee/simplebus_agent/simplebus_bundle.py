from toffee import Bundle, Signals

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
