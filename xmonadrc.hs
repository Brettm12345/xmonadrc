{-# OPTIONS -fno-warn-missing-signatures #-}

--------------------------------------------------------------------------------
{- This file is part of the xmonadrc package. It is subject to the
license terms in the LICENSE file found in the top-level directory of
this distribution and at git://pmade.com/xmonadrc/LICENSE. No part of
the xmonadrc package, including this file, may be copied, modified,
propagated, or distributed except according to the terms contained in
the LICENSE file. -}

--------------------------------------------------------------------------------
module Main where

--------------------------------------------------------------------------------
import System.Taffybar.Hooks.PagerHints (pagerHints)
import XMonad hiding (config)
import XMonad.Actions.DynamicProjects (dynamicProjects)
import XMonad.Actions.Navigation2D (withNavigation2DConfig)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.UrgencyHook hiding (urgencyConfig)
import qualified XMonad.Local.Action as Local
import qualified XMonad.Local.Keys   as Local
import qualified XMonad.Local.Layout as Local
import qualified XMonad.Local.Log    as Local
import qualified XMonad.Local.Theme  as Local
import qualified XMonad.Local.Workspaces as Workspaces

--------------------------------------------------------------------------------
-- Damn you XMonad and your crazy type signatures!
--
-- config :: XConfig a
config = def
  { terminal           = "urxvtc"
  , layoutHook         = Local.layoutHook
  , manageHook         = Local.manageHook
  , handleEventHook    = Local.handleEventHook
  , workspaces         = Workspaces.names
  , modMask            = mod3Mask
  , keys               = Local.keys
  , logHook            = Local.logHook
  , focusFollowsMouse  = False
  }

--------------------------------------------------------------------------------
main :: IO ()
main = xmonad (ewmh .
               dynamicProjects Workspaces.projects .
               pagerHints .
               withUrgencyHookC urgencyStyle urgencyConfig .
               withNavigation2DConfig def .
               Local.xmonadColors $ config)
  where
    urgencyConfig = UrgencyConfig Focused Dont
    urgencyStyle  = BorderUrgencyHook "#ff0000"
