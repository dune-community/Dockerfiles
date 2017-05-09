TAGS = minimal minimal-interactive

.PHONY: TAGS $(TAGS)

TAGS: $(TAGS)

minimal-interactive: minimal

$(TAGS):
	docker pull dunecommunity/dailywork:arch-$@
	docker build --rm -t dunecommunity/dailywork:arch-$@ $@

all: TAGS
