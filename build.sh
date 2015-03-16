#!/bin/sh -e

################################################################################
# This is a helper script that will prepare any necessary dependencies
# then run `make'.

################################################################################
VENDOR_DIR=vendor
CABAL_ADD_SOURCE=""

################################################################################
# Get the source code for a dependency.
#
# $1: The directory (under VENDOR_DIR) where the dependency goes.
# $@: Everything else is the command to run to fetch the dependency.
get_src () {
  mkdir -p $VENDOR_DIR
  dir=$1; shift

  if [ ! -d $VENDOR_DIR/$dir ]; then
    (cd $VENDOR_DIR && "$@")
  fi

  CABAL_ADD_SOURCE="${CABAL_ADD_SOURCE}${CABAL_ADD_SOURCE:+ }${VENDOR_DIR}/$dir"
}

################################################################################
# When using xmonad from darcs.
get_xmonad_src () {
  hash="74d690b962f1ac9dee3d424dc7c6a1a13922af6d"
  url="pjones@dracula.pmade.com:darcs/oss/xmonad"
  get_src xmonad darcs get --lazy --to-match "hash $hash" "$url"
}

################################################################################
# When using xmonad-contrib from darcs.
get_xmonad_contrib_src () {
  hash="4ada2fc454f82a16f5746942c176cc615a3725d9"
  url="pjones@dracula.pmade.com:darcs/oss/XMonadContrib"
  get_src XMonadContrib darcs get --lazy --to-match "hash $hash" "$url"
}

################################################################################
# I'm currently using a custom version of taffybar.
get_taffybar_src () {
  repo=https://github.com/pjones/taffybar.git
  get_src taffybar git clone -b feature/mpris-config $repo
}

################################################################################
# Install dependencies and build.
get_xmonad_src
get_xmonad_contrib_src
get_taffybar_src
make CABAL_ADD_SOURCE="$CABAL_ADD_SOURCE" install
