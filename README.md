# rhel8ubi-julia

## Run Notebook on mybinder.org
- [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/rlinfati/rhel8ubi-julia/master)

## Build container
- sudo podman build --tag rhel8ubi-julia:2021-xx github.com/rlinfati/rhel8ubi-julia
- sudo podman run --rm -itd -p 8888:8888 -v julia-home:/home/luser/ rhel8ubi-julia:2021-xx

## Publish container
- sudo podman login docker.io
- sudo podman push 123456789abc docker.io/rlinfati/rhel8ubi-julia:2021-xx

## Run Notebook
- sudo podman image pull docker.io/rlinfati/rhel8ubi-julia:2021-xx
- sudo podman run --rm -itd -p 8888:8888 -v julia-home:/home/luser/ docker.io/rlinfati/rhel8ubi-julia:2021-xx
