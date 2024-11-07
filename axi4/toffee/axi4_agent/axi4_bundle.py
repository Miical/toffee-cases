from toffee import Bundle, Signals

class DecoupledBundle(Bundle):
    ready, valid = Signals(2)

class AXI4BundleAW(DecoupledBundle):
    addr, prot, id, user, len, size, burst, lock, cache, qos = Signals(10)

class AXI4BundleW(DecoupledBundle):
    data, strb, last = Signals(3)

class AXI4BundleB(DecoupledBundle):
    resp, id, user = Signals(3)

class AXI4BundleAR(AXI4BundleAW): ...

class RBundle(DecoupledBundle):
    resp, data, last, id, user = Signals(5)

class AXI4Bundle(Bundle):
    aw = AXI4BundleAW.from_regex(r"aw_(?:(valid|ready)|bits_(.*))")
    w  = AXI4BundleW.from_regex(r"w_(?:(valid|ready)|bits_(.*))")
    b  = AXI4BundleB.from_regex(r"b_(?:(valid|ready)|bits_(.*))")
    ar = AXI4BundleAR.from_regex(r"ar_(?:(valid|ready)|bits_(.*))")
    r  = RBundle.from_regex(r"r_(?:(valid|ready)|bits_(.*))")
