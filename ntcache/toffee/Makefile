VSRC_DIR    = ./vsrc
PICKER      = picker
NAME        = Cache
NAME_L      = cache
SIM         = verilator
WAVE_FORMAT = fst
TARGET_LANG = python

run:
	pytest -sv .

dut:
	$(PICKER) export --autobuild=true $(VSRC_DIR)/$(NAME).v \
		-w $(NAME).$(WAVE_FORMAT) \
		--sname $(NAME) \
		--tdir picker_out_$(NAME_L) \
		--lang $(TARGET_LANG) \
		--sim $(SIM) \
		-e -c
	@cp -r picker_out_$(NAME_L)/UT_$(NAME) .

stat:
	cloc --include-lang=Python simplebus_agent/ ./*.py

clean:
	rm -rf UT_$(NAME) picker_out_$(NAME_L) reports *.fst *.fst.hier *.dat
