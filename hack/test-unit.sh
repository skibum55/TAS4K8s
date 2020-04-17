#!/bin/bash

set -e -u

mkdir -p ./tmp/
rm -f ./tmp/values.yml

echo "--> Generating dummy values"
./config/cf-for-k8s/hack/generate-values.sh -d foo.example.com > ./tmp/values.yml
./hack/generate-values.sh >> ./tmp/values.yml

echo "--> Building templates"
ytt -f config/ -f custom-overlays/ \
	-v system_registry.hostname=dummy \
	-v system_registry.username=dummy \
	-v system_registry.password=dummy \
	-f ./tmp/values.yml

echo UNIT TEST SUCCESS
