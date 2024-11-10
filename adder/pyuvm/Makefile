CWD=$(shell pwd)
export COCOTB_REDUCED_LOG_FMT = 1
SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES =$(CWD)/hdl/Adder.v

WAVE := FST
MODULE := testbench
TOPLEVEL = Adder
GHDL_ARGS := --ieee=synopsys
COCOTB_HDL_TIMEUNIT = 1us
COCOTB_HDL_TIMEPRECISION = 1us
include $(shell cocotb-config --makefiles)/Makefile.sim
include Makefile.dump

stat:
	cloc --include-lang=Python ./*.py
