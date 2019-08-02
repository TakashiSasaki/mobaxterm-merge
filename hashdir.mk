.ONESHELL:
SHELL=/bin/bash

ifndef PRIMARYKEY_SUFFIX
  PRIMARYKEY_SUFFIX:=primarykey
endif

ifndef HASH_STRING_LENGTH
  HASH_STRING_LENGTH:=4
endif

ifndef .DEFAULT_GOAL
  ifeq ($(MAKELEVEL),0)
    .DEFAULT_GOAL=debug-hashdir
  else
    .DEFAULT_GOAL=make-hashdir
  endif
endif

MD5_HASH_COMMAND=md5sum | sed -n -r -e 's/^([0-9a-z]+) .+/\1/p')
GIT_HASH_COMMAND=git hash-object --stdin
HASH_COMMAND=$(MD5_HASH_COMMAND)
#HASH_COMMAND=$(GIT_HASH_COMMAND)


PRIMARYKEY_FILES:=$(wildcard ./*.$(PRIMARYKEY_SUFFIX))

PRIMARYKEY_FILES_ALLINONE:=$(shell mktemp -u)
PRIMARYKEY_FILES_ALLINONE_HASH:=$(shell mktemp -u)
PRIMARYKEY_FILES_ALLINONE_HASH_SHORT:=$(shell mktemp -u)

$(PRIMARYKEY_FILES_ALLINONE): $(PRIMARYKEY_FILES)
	cat $^ | sort -u | sed -r -e '/^$$/d' | tee $@

$(PRIMARYKEY_FILES_ALLINONE_HASH): $(PRIMARYKEY_FILES_ALLINONE)
	cat $< | (while read line; do (echo -n "$$line" | $(MD5_HASH_COMMAND); done) | tee $@

$(PRIMARYKEY_FILES_ALLINONE_HASH_SHORT): $(PRIMARYKEY_FILES_ALLINONE_HASH)
	cat $< | sed -n -r -e 's/^([0-9a-f]{$(HASH_STRING_LENGTH)}).*/\1/p' | tee $@

debug-hashdir: make-hashdir

make-hashdir: $(PRIMARYKEY_FILES_ALLINONE_HASH_SHORT) 
	exec 3<$(PRIMARYKEY_FILES_ALLINONE_HASH_SHORT)
	exec 4<$(PRIMARYKEY_FILES_ALLINONE)
	(while read -u 3 md5; do (mkdir -p $${md5}; read -u 4 path; echo -n $${path} > $${md5}/dir.txt); done)
	exec 3<&-
	exec 4<&-

help-hashdir:
	$(info "It makes directories with hash value string as their names.")
	$(info "Each hash value is calculated line by line from source text files.")
	$(info "Empty lines are ignored.")

