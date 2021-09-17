# Technical prelude
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DIST := dist
OCI_TAR := $(DIST)/oci.tar
OCI_UNTAR_DIR := $(DIST)/oci
DOCKER_TAR := $(DIST)/docker.tar
DOCKER_UNTAR_DIR := $(DIST)/docker
DOCKER_LEGACY_TAR := $(DIST)/docker_legacy.tar
DOCKER_LEGACY_UNTAR_DIR := $(DIST)/docker_legacy
DOCKER_LEGACY_IMAGE_NAME := docker_legacy

.PHONY: all
all: $(OCI_UNTAR_DIR) $(DOCKER_UNTAR_DIR) $(DOCKER_LEGACY_UNTAR_DIR)

$(DOCKER_LEGACY_TAR): | $(DIST)
	docker build --no-cache -t $(DOCKER_LEGACY_IMAGE_NAME) .
	docker save $(DOCKER_LEGACY_IMAGE_NAME) -o "$@"

$(DOCKER_LEGACY_UNTAR_DIR): $(DOCKER_LEGACY_TAR) | $(DIST)
	mkdir -p "$@"
	tar -C "$@" -xvf "$<"

$(DOCKER_UNTAR_DIR): $(DOCKER_TAR) | $(DIST)
	mkdir -p "$@"
	tar -C "$@" -xvf "$<"

$(OCI_UNTAR_DIR): $(OCI_TAR) | $(DIST)
	mkdir -p "$@"
	tar -C "$@" -xvf "$<"

$(DOCKER_TAR): |$(DIST)
	docker buildx build -o type=docker,dest=$@ .

$(OCI_TAR): |$(DIST)
	docker buildx build -o type=oci,dest=$@ .

$(DIST):
	mkdir "$@"

.PHONY: clean
clean:
	rm -rf $(DIST)
