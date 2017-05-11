TAGS = dockerindocker

.PHONY: TAGS $(TAGS)

TAGS: $(TAGS)


$(TAGS):
	docker pull dunecommunity/gitlabci_$@ || echo "no image available to pull for dunecommunity/gitlabci_$@"
	docker build --rm -t dunecommunity/gitlabci_$@ $@

push: dockerindocker
	docker push dunecommunity/gitlabci_dockerindocker

all: TAGS
