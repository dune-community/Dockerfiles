SUBDIRS = manylinux arch debian

.PHONY: subdirs $(SUBDIRS) base push

subdirs: $(SUBDIRS)

$(SUBDIRS):
	make -C $@

push:
	docker push dunecommunity/dailywork

all: subdirs
