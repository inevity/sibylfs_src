TMP:=_build

#make file cd auto backto highlevle dir
all: 
	mkdir -p $(TMP)
	cd $(TMP) && ln -sf ../src/* ../src/.depend .
	$(MAKE) -C $(TMP)

clean: FORCE
	rm -rf $(TMP) ./result

FORCE:
