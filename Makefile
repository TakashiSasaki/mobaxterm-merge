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
	(while read -u 3 md5; do (mkdir -p configs/$${md5}; read -u 4 path; echo -n $${path} > configs/$${md5}/dir.txt); done)
	exec 3<&-
	exec 4<&-
	find configs -maxdepth 1 -name "????????????????????????????????" -type d -exec $(MAKE) -f ../../Makefile -C {} mobaxterm.ini bookmark.ini bookmark1.ini bookmark2.ini bookmark3.ini bookmark4.ini bookmark5.ini bookmark6.ini bookmark7.ini bookmark8.ini bookmark9.ini \;

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

hello:
	echo hello

mobaxterm.ini: dir.txt
	exec 3<$<
	read -u 3 dir
	cp $${dir}/MobaXterm.ini $@

bookmark.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark1.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_1\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark2.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_2\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark3.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_3\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark4.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_4\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark5.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_5\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark6.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_6\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark7.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_7\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark8.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_8\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@

bookmark9.ini: mobaxterm.ini
	sed -n -r -e '/^\[Bookmarks_9\]/{pn {:LOOP /^\[/q pnb LOOP }}' <$< >$@
