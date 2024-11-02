module vcs_dump;
    initial begin
        if ($test$plusargs("COCOTB_DUMP_VCD")) begin
            $dumpfile("AXI4RAM.vcd");
            $dumpvars(0, AXI4RAM);
        end
        else if ($test$plusargs("COCOTB_DUMP_VPD")) begin
            $vcdplusfile("AXI4RAM.vpd");
            $vcdpluson(0, AXI4RAM);
            $vcdplusmemon();
        end
    end
endmodule
