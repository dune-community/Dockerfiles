TAGS = full full-clion full-interactive minimal minimal-interactive

.PHONY: TAGS $(TAGS)

TAGS: $(TAGS)

minimal-interactive: minimal
full: minimal
full-interactive: full
full-clion: full-interactive

$(TAGS):
	docker build --rm -t dunecommunity/dailywork:debian-$@ $@

all: TAGS
