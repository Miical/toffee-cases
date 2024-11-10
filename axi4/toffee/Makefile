VSRC_DIR    = ./vsrc
PICKER      = picker
NAME        = AXI4RAM
NAME_L      = axi4ram
SIM         = verilator
WAVE_FORMAT = fst
TARGET_LANG = python

run:
	pytest --toffee-report -n=6 -sv .

dut:
	$(PICKER) export --autobuild=false $(VSRC_DIR)/$(NAME).v \
		-w $(NAME).$(WAVE_FORMAT) \
		--sname $(NAME) \
		--tdir picker_out_$(NAME_L) \
		--lang $(TARGET_LANG) \
		--sim $(SIM) \
		-e -c

stat:
	cloc --include-lang=Python axi4_agent/ ./*.py

clean:
	rm -rf UT_$(NAME) picker_out_$(NAME_L) reports *.fst *.fst.hier *.dat
