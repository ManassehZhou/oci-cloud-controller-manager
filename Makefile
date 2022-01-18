# Copyright 2018 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

COMPONENT ?= oci-cloud-controller-manager oci-volume-provisioner oci-flexvolume-driver oci-csi-controller-driver oci-csi-node-driver

ifeq "$(VERSION)" ""
    BUILD := $(shell git describe --exact-match 2> /dev/null || git describe --match=$(git rev-parse --short=8 HEAD) --always --dirty --abbrev=8)
    # Allow overriding for release versions else just equal the build (git hash)
    VERSION ?= ${BUILD}
else
    VERSION ?= ${VERSION}
endif

.PHONY: build-dirs
build-dirs:
	@mkdir -p dist/

.PHONY: build
build: build-dirs
	@for component in $(COMPONENT); do \
		CGO_ENABLED=0 go build -o dist/$$component -ldflags "-X main.version=$(VERSION) -X main.build=$(BUILD)" ./cmd/$$component ; \
    done

.PHONY: clean
clean:
	@rm -rf dist
