```shell
docker run \
  --rm \
  --privileged \
  --platform linux/amd64 \
  -v /dev:/dev \
  -v ${PWD}:/build \
  -v ${PWD}/packer_cache:/build/packer_cache \
  -v ${PWD}/output-arm-image:/build/output-arm-image \
  ghcr.io/solo-io/packer-plugin-arm-image build image.json
```