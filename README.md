# docker for DUNE

## creating a container image

For instance the minimal debian one:

* get the repo, enter the right directory

```bash
git clone https://github.com/ftalbrecht/docker-for-dune.git && \
cd docker-for-dune/debian
```

* build the image, `--rm` removes all intermediate layers, `-t` tags the resulting image

```bash
docker build --rm -t docker-for-dune:minimal -f Dockerfile.minimal .
```

## docker maintenance

### clean up containers

* remove __all__ container:

```bash
for ii in $(docker ps -a | cut -d ' ' -f 1); do [ "$ii" != "CONTAINER" ] && docker rm $ii; done
```

* list images:

```bash
docker images
```

* remove selected images:
```bash
for ii in ...; do docker rmi $ii; done
```
