.PHONY: all server webapp server-corredor server-builder webapp-builder

# All known outputs (output = directory on root)
BUILDERS         = server-builder webapp-builder
CORTEZA_OUTPOUTS = server webapp server-corredor

# webapp needs to be build before server as server
# includes images from it
all: webapp server server-corredor

$(CORTEZA_OUTPOUTS):
	$(MAKE) -C $@
