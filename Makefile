.ONESHELL:
tmp1:=$(shell mktemp -u)
tmp2:=$(shell mktemp -u)
tmp3:=$(shell mktemp -u)
tmp4:=$(shell mktemp -u)
tmp5:=$(shell mktemp -u)
tmp6:=$(shell mktemp -u)

mkdir-configs: ini-dirs.md5 ini-dirs.txt
	exec 3<$(word 1,$^)
	exec 4<$(word 2,$^)
	(while read -u 3 md5; do (mkdir -p configs/$${md5}; read -u 4 path; echo -n $${path} > configs/$${md5}/path.txt); done)
	ls configs
	exec 3<&-
	exec 4<&-

ini-dirs.md5: ini-dirs.txt
	cat $< | (while read line; do (echo -n "$$line" | md5sum | sed -n -r -e 's/^([0-9a-z]+) .+/\1/p'); done) | tee $@

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

