# Technical prelude
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DIST := dist
OCI_TAR := $(DIST)/oci.tar

$(OCI_TAR): |$(DIST)
	docker buildx build -o type=oci,dest=$@ .

$(DIST):
	mkdir "$@"

.PHONY: clean
clean:
	rm -rf $(DIST)
