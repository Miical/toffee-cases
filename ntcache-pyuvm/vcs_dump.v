module vcs_dump;
    initial begin
        if ($test$plusargs("COCOTB_DUMP_VCD")) begin
            $dumpfile("Cache.vcd");
            $dumpvars(0, Cache);
        end
        else if ($test$plusargs("COCOTB_DUMP_VPD")) begin
            $vcdplusfile("Cache.vpd");
            $vcdpluson(0, Cache);
            $vcdplusmemon();
        end
    end
endmodule
