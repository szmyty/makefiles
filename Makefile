include common.mk

.DEFAULT_GOAL := all

all:
	@echo "Hello World!"

.PHONY: help
help:		## Show the help.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep

.PHONY: hadolint
hadolint:		## Show the help.
	@echo "Running hadolint Dockerfile linter..."
	@$(call hadolint)


