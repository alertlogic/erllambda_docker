#
REV=$(shell git describe)

ORG          := alertlogic
BASE         := erllambda
BASE_LABEL   := 21.3
ELIXIR_LABEL := 21.3-elixir

REGIONS=("us-east-1" "us-west-2" "eu-west-1" "eu-west-2")

all: base-image

base-image:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(ORG)/$(BASE):$(MULTI_LABEL) ./21 --push

elixir-image:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(ORG)/$(BASE):$(ELIXIR_LABEL) ./elixir --push
