SUBDIRS = manylinux arch debian gitlabci

.PHONY: subdirs $(SUBDIRS) base push

subdirs: $(SUBDIRS)

$(SUBDIRS):
	make -C $@

push: push_debian push_gitlabci

push_%: %
	make -C $<

all: subdirs
