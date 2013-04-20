################################################################################
ARCH   = $(shell uname -m)
OS     = $(shell uname -s | tr '[A-Z]' '[a-z]')
TARGET = $(HOME)/.xmonad/xmonad-$(ARCH)-$(OS)
SRC    = $(shell find . -type f -name '*.hs')
BIN    = cabal-dev/bin/xmonadrc
XMONAD = cabal-dev/bin/xmonad
CHECK  = cabal-dev/bin/checkrc

################################################################################
.PHONEY: install restart

################################################################################
all: $(BIN)

################################################################################
install: $(TARGET)

################################################################################
restart: install
	$(XMONAD) --restart

################################################################################
$(BIN): $(SRC)
	cabal-dev install
	$(CHECK)

################################################################################
$(TARGET): $(BIN)
	if [ -r $@ ]; then mv $@ $@.prev; fi
	cp -p $< $@
	cd $(dir $@) && ln -nfs $(notdir $@) xmonad
