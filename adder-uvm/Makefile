TESTCASE = test_random
VERBOSITY = UVM_MEDIUM

# code coverage command
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
CM_DIR = -cm_dir ./covdir.vdb

VCS_OPTS = -full64 -debug_all -sverilog +define+UVM_NO_DEPRECATED -CFLAGS -DVCS \
		   -timescale=1ns/1ps -f filelist.f\
		   $(CM) $(CM_NAME) $(CM_DIR)
SIMV_OPTS = +UVM_VERBOSITY=$(VERBOSITY) \
	           +vcs+dumpvars+Cache.vcd \
		   $(CM) $(CM_NAME) $(CM_DIR) \
		   +UVM_TESTNAME=$(TESTCASE)

BUILD_SR = vsrc/adder.v src/ adder_ports/ filelist.f


all: comp run
gui: comp run_gui

comp:
	@rm -rf build/ && mkdir build && cp -r $(BUILD_SR) build/
	@cd build/ && vcs $(VCS_OPTS) -o simv

run:
	@cd build/ && ./simv $(SIMV_OPTS)

run_gui:
	@cd build/ && ./simv -gui $(SIMV_OPTS) &

stat: clean
	@find . -name '*.sv' | xargs wc -l

clean:
	@rm -rf build/

.PHONY: all gui comp run run_gui stat clean
