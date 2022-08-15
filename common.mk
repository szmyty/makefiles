# Common variables and functions for Makefile.
empty:=
space:=$(empty) $(empty)
null:=\0
ROOT_DIR:=$(CURDIR)

# Dependencies for commands.
DEPENDENCIES:= sed grep hadolint sed fgrep xargs

# Docker-related files.
DOCKER_COMPOSE_FILE:=$(ROOT_DIR)/docker-compose.yml
DOCKER_COMPOSE_DEV_FILE:=$(ROOT_DIR)/docker-compose.dev.yml
DOCKER_COMPOSE_TESTING_FILE:=$(ROOT_DIR)/docker-compose.testing.yml
ENV_FILE:=$(ROOT_DIR)/.env
ENV_TESTING_FILE:=$(ROOT_DIR)/.env.testing
ENV_DEVELOPMENT_FILE:=$(ROOT_DIR)/.env.development

# Docker SSL/TLS files.
SSL_DIR=$(ROOT_DIR)/ssl
CA_FILE=$(SSL_DIR)/ca.pem
CERT_FILE=$(SSL_DIR)/cert.pem
KEY_FILE=$(SSL_DIR)/key.pem

# Configuration Files
HADOLINT_CONFIG:=$(ROOT_DIR)/.hadolint.yml
HADOLINT_IGNORE:=$(ROOT_DIR)/.hadolintignore

# Escape provided string path by replacing spaces with null character.
define escape
$(subst $(space),$(null),$1)
endef

# Unescape provided string path by replacing null character with spaces.
define unescape
$(subst $(null),$(space),$1)
endef

# Replacement for dir function that handles whitespaces.
define dirx
$(call unescape,$(dir $(call escape,$1)))
endef

# Replacement for dir function that handles whitespaces.
define notdirx
$(call unescape,$(notdir $(call escape,$1)))
endef

# Detect OS.
ifeq ($(OS),Windows_NT)
	OPERATING_SYSTEM=WIN32
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		CPU_ARCHITECTURE=AMD64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		CPU_ARCHITECTURE=IA32
	endif
else
	UNAME_S:=$(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OPERATING_SYSTEM=LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		OPERATING_SYSTEM=OSX
	endif
		UNAME_P:=$(shell uname -p)
	ifeq ($(UNAME_P),x86_64)
		CPU_ARCHITECTURE=AMD64
	endif
		ifneq ($(filter %86,$(UNAME_P)),)
	CPU_ARCHITECTURE=IA32
		endif
	ifneq ($(filter arm%,$(UNAME_P)),)
		CPU_ARCHITECTURE=ARM
	endif
endif

define check_npm_install
npm list | grep --quiet $(1)
endef

# Initialization depending on OS. Also, checks dependencies for each OS.
ifeq (${OPERATING_SYSTEM},WIN32)	## Windows
	# Check dependencies for Windows. TODO

	hadolint = for /R "${ROOT_DIR}" %%f in (*Dockerfile?) do echo %%f | \
	findstr /vig:"${HADOLINT_IGNORE}" | \
	xargs -0 -I{} cmd /c hadolint --config "${HADOLINT_CONFIG}" {} | \
	sed "s/\"//g"
else
	test=echo $(OPERATING_SYSTEM)
endif

#define check_executable
#    if
#endef
