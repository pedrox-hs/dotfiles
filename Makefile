# https://stackoverflow.com/a/36226832
OS := $(shell uname -s)
SHELL := env PATH="$(PATH):$(PWD)/bin" /bin/bash

# Define environment variables
ENV_FILES := $(wildcard .env.default .env)
ifneq ($(ENV_FILES),)
include $(ENV_FILES)
export $(shell grep -he '^[^\#;]' $(ENV_FILES) | sed 's/=.*//' | sort | uniq)
endif

# Include custom makefiles
MAK_FILES := $(wildcard bin/mak/*.mak)
ifneq ($(MAK_FILES),)
include $(MAK_FILES)
endif


help: ## Show this help
	@echo -e "usage: make [target]\n\ntarget:"
	@grep -Fh "##" $(MAKEFILE_LIST) | grep -Fv fgrep | sed -e 's/\\$$//' | sed -e 's/: ##\s*/\t/' | expand -t 20 | pr -to2


phony: ## Regenerate .PHONY
	sed-i -e "s/^\.PHONY:.*$$/.PHONY: `grep -hE '^[a-z-]+: #' $(MAKEFILE_LIST) \
		| sed -e 's/:.*//' \
		| uniq \
		| paste -sd \" \" -`/g" Makefile


ifndef VERBOSE
.SILENT:
endif


.PHONY: help phony install link shell
