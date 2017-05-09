TAGS = full-interactive minimal minimal-interactive

.PHONY: TAGS $(TAGS)

TAGS: $(TAGS)

minimal-interactive: minimal
full-interactive: minimal-interactive

$(TAGS):
	docker pull dunecommunity/dailywork:manylinux-$@
	docker build --rm -t dunecommunity/dailywork:manylinux-$@ $@

all: TAGS
