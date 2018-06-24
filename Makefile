SUBDIRS = awesome qutebrowser vim ranger mutt weechat conky #ncmpcpp beets

DOTFILES = gitconfig vimrc Xresources Xmodmap zshrc zshrc.local fehbg offlineimaprc offlineimap.py msmtprc conkyrc-date.lua conkyrc-infos.lua synergy.conf xinitrc
DEST_LINKS = $(addprefix $(HOME)/.,$(DOTFILES))

.PHONY: all links subdirs clean
all: links subdirs

links: $(DEST_LINKS) subdirs

$(HOME)/.%: %
	ln -s $(CURDIR)/$< $@ ; true

subdirs:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir; \
	done

clean:
	rm -irf $(DEST_LINKS)
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

# vim:set noet sts=0 sw=2 ts=2 tw=80:

