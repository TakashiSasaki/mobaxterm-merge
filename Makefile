tmp1:=$(shell mktemp -u)
tmp2:=$(shell mktemp -u)
tmp3:=$(shell mktemp -u)
tmp4:=$(shell mktemp -u)
tmp5:=$(shell mktemp -u)
tmp6:=$(shell mktemp -u)

ini-dirs-.txt: ini-dirs.txt
	cat $^ | tr ": /" - | tee $@

mkdir-configs: ini-dirs-.txt
	-cat $< | xargs.exe -i mkdir configs/{}
	ls configs

ini-dirs.txt: $(tmp2) $(tmp3) $(tmp4)
	@cat $^ | sort -u | tee $@

$(tmp4):
	$(foreach x,$(wildcard /drives/*/*/*/MobaXterm.ini),$(file >> $@,$x))
	$(foreach x,$(wildcard /drives/*/Users/*/Documents/MobaXterm/MobaXterm.ini),$(file >> $@,$x))
	sed -n -r -e 's/(.+)\/MobaXterm\.ini$$/\1/gp' $@ | tee $@

$(tmp2):
	ps -W | grep -i mobaxterm | sed -n -r -e 's/.+ ([A-Z]:.+)\\MobaXterm.exe/\1/gp' >>$(tmp1)
	cygpath `cat $(tmp1)` >$@

$(tmp3):
	$(foreach x,$(wildcard /drives/*/*/*/MobaXterm.exe),$(file >> $@,$x))
	sed -n -r -e 's/(.+)\/MobaXterm\.exe$$/\1/gp' $@ | tee $@



configs:
	mkdir $@

