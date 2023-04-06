#
# File managed by ModuleSync - Do Not Edit
#
# Additional Makefiles can be added to `.sync.yml` in 'Makefile.includes'
#

# The component name is hard-coded from the template
COMPONENT_NAME ?= backup-k8up

git_dir         ?= $(shell git rev-parse --git-common-dir)
compiled_path   ?= compiled/$(COMPONENT_NAME)/$(COMPONENT_NAME)
root_volume     ?= -v "$${PWD}:/$(COMPONENT_NAME)"
compiled_volume ?= -v "$${PWD}/$(compiled_path):/$(COMPONENT_NAME)"
commodore_args  ?= --search-paths ./dependencies --search-paths . -n $(COMPONENT_NAME)

ifneq "$(git_dir)" ".git"
	git_volume        ?= -v "$(git_dir):$(git_dir):ro"
	antora_git_volume ?= -v "$(git_dir):/preview/antora/.git:ro"
else
	git_volume        ?=
	antora_git_volume ?= -v "${PWD}/.git:/preview/antora/.git:ro"
endif

ifneq "$(shell which docker 2>/dev/null)" ""
	DOCKER_CMD    ?= $(shell which docker)
	DOCKER_USERNS ?= ""
else
	DOCKER_CMD    ?= podman
	DOCKER_USERNS ?= keep-id
endif
DOCKER_ARGS ?= run --rm -u "$$(id -u):$$(id -g)" --userns=$(DOCKER_USERNS) -w /$(COMPONENT_NAME) -e HOME="/$(COMPONENT_NAME)"

JSONNET_FILES   ?= $(shell find . -type f -not -path './vendor/*' \( -name '*.*jsonnet' -or -name '*.libsonnet' \))
JSONNETFMT_ARGS ?= --in-place --pad-arrays
JSONNET_IMAGE   ?= docker.io/bitnami/jsonnet:latest
JSONNET_DOCKER  ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) --entrypoint=jsonnetfmt $(JSONNET_IMAGE)

YAMLLINT_ARGS   ?= --no-warnings
YAMLLINT_CONFIG ?= .yamllint.yml
YAMLLINT_IMAGE  ?= docker.io/cytopia/yamllint:latest
YAMLLINT_DOCKER ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) $(YAMLLINT_IMAGE)

VALE_CMD  ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) --volume "$${PWD}"/docs/modules:/pages ghcr.io/vshn/vale:2.15.5
VALE_ARGS ?= --minAlertLevel=error --config=/pages/ROOT/pages/.vale.ini /pages

ANTORA_PREVIEW_CMD ?= $(DOCKER_CMD) run --rm --publish 35729:35729 --publish 2020:2020 $(antora_git_volume) --volume "${PWD}/docs":/preview/antora/docs ghcr.io/vshn/antora-preview:3.1.2.3 --style=syn --antora=docs

COMMODORE_CMD  ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(git_volume) $(root_volume) docker.io/projectsyn/commodore:latest
COMPILE_CMD    ?= $(COMMODORE_CMD) component compile . $(commodore_args)
JB_CMD         ?= $(DOCKER_CMD) $(DOCKER_ARGS) --entrypoint /usr/local/bin/jb docker.io/projectsyn/commodore:latest install

GOLDEN_FILES    ?= $(shell find tests/golden/$(instance) -type f)

KUBENT_FILES    ?= $(shell echo "$(GOLDEN_FILES)" | sed 's/ /,/g')
KUBENT_ARGS     ?= -c=false --helm3=false -e
KUBENT_IMAGE    ?= ghcr.io/doitintl/kube-no-trouble:latest
KUBENT_DOCKER   ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) --entrypoint=/app/kubent $(KUBENT_IMAGE)

instance ?= v2
test_instances = tests/v2.yml tests/v1.yml
