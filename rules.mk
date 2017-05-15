TAGS = $(patsubst %/,%,$(dir $(wildcard */Dockerfile)))

.PHONY: push $(TAGS)

$(TAGS):
	docker pull dunecommunity/$(NAME)-$@ || echo "no image available to pull for dunecommunity/$(NAME)-$@"
	docker build --rm -t dunecommunity/$(NAME)-$@ $@

push_%: %
	docker push dunecommunity/$(NAME)-$<

push: $(addprefix push_,$(TAGS))

all: $(TAGS)
