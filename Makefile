PLUGIN ?= /go/src/github.com/submariner-io/k8s-multicluster-demo/scripts/plugin/admiralty_hook
CLUSTER_SETTINGS ?=
DAPPER_VERSION ?= devel
BASE_BRANCH ?= devel
export SUBM_VERSION

ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

include $(SHIPYARD_DIR)/Makefile.inc

TARGETS := $(shell ls -p scripts)

ifdef CLUSTER_SETTINGS
override CLUSTER_SETTINGS_FLAG = --cluster_settings $(CLUSTER_SETTINGS)
else
override CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/scripts/cluster_settings
endif

override CLUSTERS_ARGS += --prometheus
override CLUSTERS_ARGS += $(CLUSTER_SETTINGS_FLAG)
override DEPLOY_ARGS += $(CLUSTER_SETTINGS_FLAG)

# Targets to make

.PHONY: $(TARGETS)

else

# Not running in Dapper

Makefile.dapper:
	@echo Downloading $@
	@curl -sfLO https://raw.githubusercontent.com/submariner-io/shipyard/$(BASE_BRANCH)/$@

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.inc: ;
