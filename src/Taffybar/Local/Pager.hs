{- This file is part of the xmonadrc package. It is subject to the
license terms in the LICENSE file found in the top-level directory of
this distribution and at git://pmade.com/xmonadrc/LICENSE. No part of
the xmonadrc package, including this file, may be copied, modified,
propagated, or distributed except according to the terms contained in
the LICENSE file. -}

--------------------------------------------------------------------------------
-- | Custom pager configuration for Taffybar.
module Taffybar.Local.Pager
       ( pagerConfig
       ) where

--------------------------------------------------------------------------------
-- Library imports.
import System.Taffybar.Pager

--------------------------------------------------------------------------------
-- Local imports.
import Taffybar.Local.Host

--------------------------------------------------------------------------------
-- | Per-host pager configuration.
pagerConfig :: Host -> PagerConfig
pagerConfig host = PagerConfig
  { activeLayout     = escape
  , activeWindow     = colorize "white" "" . escape . shorten (maxWindowTitle host)
  , activeWorkspace  = colorize "#88b324" "" . wrap "[" "]" . escape
  , visibleWorkspace = wrap "(" ")" . escape
  , hiddenWorkspace  = escape
  , emptyWorkspace   = const ""
  , urgentWorkspace  = colorize "#1c1c1c" "#d33682" . wrap " " " " . escape
  , widgetSep        = colorize "#5c5c5c" "" " | "
  }
