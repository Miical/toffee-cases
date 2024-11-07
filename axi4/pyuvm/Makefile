CWD=$(shell pwd)
export COCOTB_REDUCED_LOG_FMT = 1
SIM ?= verilator
SIM_ARGS ?= --x-initial 0
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES =$(CWD)/hdl/AXI4RAM.v

WAVES=VCD
MODULE := testbench
TOPLEVEL = AXI4RAM
GHDL_ARGS := --ieee=synopsys
COCOTB_HDL_TIMEUNIT = 1us
COCOTB_HDL_TIMEPRECISION = 1us
include $(shell cocotb-config --makefiles)/Makefile.sim
include Makefile.dump
