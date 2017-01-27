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
docker build --rm -t docker-for-dune:minimal -f Dockerfile.minimal
```
