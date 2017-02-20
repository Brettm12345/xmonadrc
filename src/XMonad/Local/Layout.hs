{-# OPTIONS -fno-warn-missing-signatures #-}

--------------------------------------------------------------------------------
{- This file is part of the xmonadrc package. It is subject to the
license terms in the LICENSE file found in the top-level directory of
this distribution and at git://pmade.com/xmonadrc/LICENSE. No part of
the xmonadrc package, including this file, may be copied, modified,
propagated, or distributed except according to the terms contained in
the LICENSE file. -}

--------------------------------------------------------------------------------
-- | Layout configuration and hook.
module XMonad.Local.Layout (layoutHook, selectLayoutByName) where

--------------------------------------------------------------------------------
import XMonad hiding ((|||), layoutHook, float)
import XMonad.Layout.Accordion (Accordion(..))
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.ComboP (Property(..), combineTwoP)
import XMonad.Layout.Drawer (drawer, onTop)
import XMonad.Layout.Gaps (Gaps, gaps)
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Master (mastered)
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.Renamed (Rename(..), renamed)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.ThreeColumns (ThreeCol(..))
import XMonad.Layout.ToggleLayouts (toggleLayouts)
import XMonad.Layout.TwoPane (TwoPane(..))
import XMonad.Local.Prompt (aListCompFunc)
import XMonad.Local.Theme (topBarTheme)
import XMonad.Prompt
import XMonad.Util.Types (Direction2D(..))

--------------------------------------------------------------------------------
-- | XMonad layout hook.  No type signature because it's freaking
-- nasty and I can't come up with a way to make it generic.
layoutHook =
    toggleLayouts fullscreen (addDeco $ addSpace allLays)
  where
    addDeco  = renamed [CutWordsLeft 1] . noFrillsDeco shrinkText topBarTheme
    addSpace = renamed [CutWordsLeft 2] . spacing 4

    fullscreen :: ModifiedLayout Rename (ModifiedLayout Gaps Full) Window
    fullscreen = renamed [Replace "Full"] (gaps (uniformGaps 60) Full)
    uniformGaps n = [(U, n), (D, n), (L, n), (R, n)] :: [(Direction2D,Int)]

    threeCols = renamed [Replace "3C"]   (ThreeColMid 1 (1/20) (1/2))
    twoCols   = renamed [Replace "2C"]   (mastered (1/100) (1/2) Accordion)
    twoPane   = renamed [Replace "2P"]   (TwoPane (3/100) (1/2))
    bspace    = renamed [Replace "BSP"]  emptyBSP
    tall      = renamed [Replace "Tall"] (ResizableTall 1 (1.5/100) (3/5) [])

    -- Emacs windows on the left, everything else on the right.
    emacsCombo = renamed [Replace "Emacs Split"] $
                 combineTwoP twoPane Accordion Accordion (ClassName "Emacs")

    -- Chrome windows on the left, everything else on the right.
    -- Note: Chrome pop-up windows are forced to the right.
    chromeCombo = renamed [Replace "Chrome Split"] $
                  combineTwoP twoPane Accordion Accordion
                  (ClassName "Chromium-browser" `And` Not (Role "pop-up"))

    -- Place Emacs windows into a BSP layout, all other windows go off
    -- the screen and can't be used.
    emacsDrawer = renamed [Replace "Emacs Only"] $
                  drawer (1/10) 1 (Not $ ClassName "Emacs") Accordion `onTop` bspace

    -- Place Chrome windows into a BSP layout, all other windows go
    -- off the screen and can't be used.
    chromeDrawer = renamed [Replace "Chrome Only"] $
                   combineTwoP (TwoPane 0 1) bspace Full (ClassName "Chromium-browser")

    -- Place any windows with the "focus" tag into a BSP layout.  All
    -- other windows go into a drawer (also managed by BSP).
    focusDrawer = renamed [Replace "Focus"] $
                  combineTwoP (TwoPane 0 1) bspace Full (Tagged "focus")

    -- When I'm teaching a class I start with a weird layout before
    -- focusing on specific windows using another layout.
    projector = renamed [Replace "Projector"] topHalf where
      topHalf    = combineTwoP (Mirror twoPane) bspace bottomHalf (ClassName "Emacs")
      bottomHalf = combineTwoP (reflectHoriz twoPane) Full Full (ClassName ".zathura-wrapped")

    -- All layouts put together.
    allLays = bspace       ||| twoCols     ||| threeCols   ||| tall    |||
              emacsCombo   ||| chromeCombo ||| emacsDrawer ||| twoPane |||
              chromeDrawer ||| focusDrawer ||| projector

--------------------------------------------------------------------------------
-- | A data type for the @XPrompt@ class.
data LayoutByName = LayoutByName

instance XPrompt LayoutByName where
  showXPrompt LayoutByName = "Layout: "

--------------------------------------------------------------------------------
-- | Use @Prompt@ to choose a layout.
selectLayoutByName :: XPConfig -> X ()
selectLayoutByName conf =
  mkXPrompt LayoutByName conf (aListCompFunc conf layoutNames) go

  where
    go :: String -> X ()
    go selected = case lookup selected layoutNames of
                    Just name -> sendMessage (JumpToLayout name)
                    Nothing   -> return ()

    layoutNames :: [(String, String)]
    layoutNames = [ ("Tall",                         "Tall")
                  , ("Binary Space Partition (BSP)", "BSP")
                  , ("Two Columns (2C)",             "2C")
                  , ("Two Pane (2P)",                "2P")
                  , ("Three Columns (3C)",           "3C")
                  , ("Emacs Split (E2C)",            "Emacs Split")
                  , ("Emacs Only (EDR)",             "Emacs Only")
                  , ("Chrome Split (C2C)",           "Chrome Split")
                  , ("Chrome Only (CMDR)",           "Chrome Only")
                  , ("Projector",                    "Projector")
                  , ("Focus",                        "Focus")
                  ]
