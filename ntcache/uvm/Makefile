ALL_TEST_CASES = test_read test_write test_random_read_write test_read_write_same_addr test_read_write_same_group
TESTCASE = test_read_write_same_group
VERBOSITY = UVM_LOW

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

BUILD_SR = vsrc/Cache.v src/ simplebus/ filelist.f


all: comp run_all_tests

comp:
	@rm -rf build/ && mkdir build && cp -r $(BUILD_SR) build/
	@cd build/ && vcs $(VCS_OPTS) -o simv

run_all_tests:
	@cd build && \
	for test_case in $(ALL_TEST_CASES); do \
		echo "Running $$test_case"; \
		./simv $(SIMV_OPTS) +UVM_TESTNAME=$$test_case -l $$test_case.log; \
	done

run:
	@cd build/ && ./simv $(SIMV_OPTS) +UVM_TESTNAME=$(TESTCASE)

run_gui:
	@cd build/ && ./simv -gui $(SIMV_OPTS) +UVM_TESTNAME=$(TESTCASE) &

stat: clean
	@find . -name '*.sv' | xargs wc -l

clean:
	@rm -rf build/

.PHONY: all gui comp run run_gui run_all_tests stat clean
