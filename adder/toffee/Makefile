VSRC_DIR    = ./vsrc
PICKER      = picker
NAME        = Adder
NAME_L      = adder
SIM         = verilator
WAVE_FORMAT = fst
TARGET_LANG = python

run:
	pytest -v .

dut:
	$(PICKER) export --autobuild=true $(VSRC_DIR)/$(NAME).v \
		-w $(NAME).$(WAVE_FORMAT) \
		--sname $(NAME) \
		--tdir picker_out_$(NAME_L) \
		--lang $(TARGET_LANG) \
		--sim $(SIM) \
		-e -c
	@cp -r picker_out_$(NAME_L)/UT_$(NAME) .

clean:
	rm -rf UT_$(NAME) picker_out_$(NAME_L) reports *.fst *.fst.hier *.dat
