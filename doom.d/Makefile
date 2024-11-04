TARGETS    = config.el init.el package.el
DEST_DIR   = $(HOME)/.doomd
DEST_LINKS = $(addprefix $(DEST_DIR)/,$(TARGETS))

.PHONY: all links
all: links

links: dirs $(DEST_LINKS)

dirs:
	@mkdir -p $(DEST_DIR)

$(DEST_DIR)/%: %
	ln -s $(CURDIR)/$< $@ ; true

clean:
	rm -irf $(DEST_LINKS)

# vim:set noet sts=0 sw=2 ts=2 tw=80:

