targets := $(shell find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v .git)

default: $(targets)

$(targets):
	stow $@

.PHONY: $(targets)