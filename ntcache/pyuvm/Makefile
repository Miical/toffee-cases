CWD=$(shell pwd)
export COCOTB_REDUCED_LOG_FMT = 1
SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES =$(CWD)/hdl/Cache.v

WAVES=FST
MODULE := testbench
TOPLEVEL = Cache
GHDL_ARGS := --ieee=synopsys
COCOTB_HDL_TIMEUNIT = 1us
COCOTB_HDL_TIMEPRECISION = 1us
include $(shell cocotb-config --makefiles)/Makefile.sim
include Makefile.dump
