SUBDIRS = manylinux arch debian gitlabci

.PHONY: subdirs $(SUBDIRS) base push

subdirs: $(SUBDIRS)

$(SUBDIRS):
	make -C $@

push:
	docker push dunecommunity/dailywork
	make -C gitlabci push

all: subdirs
