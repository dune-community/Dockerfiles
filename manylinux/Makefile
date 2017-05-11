TAGS = full-interactive minimal minimal-interactive

.PHONY: TAGS $(TAGS)

TAGS: $(TAGS)

minimal-interactive: minimal
full-interactive: minimal-interactive

$(TAGS):
	docker pull dunecommunity/dailywork:manylinux-$@ || echo "no image available to pull for dunecommunity/dailywork:manylinux-$@"
	docker build --rm -t dunecommunity/dailywork:manylinux-$@ $@

all: TAGS
