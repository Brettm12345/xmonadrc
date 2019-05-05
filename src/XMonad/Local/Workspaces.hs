--------------------------------------------------------------------------------
{- This file is part of the xmonadrc package. It is subject to the
license terms in the LICENSE file found in the top-level directory of
this distribution and at git://pmade.com/xmonadrc/LICENSE. No part of
the xmonadrc package, including this file, may be copied, modified,
propagated, or distributed except according to the terms contained in
the LICENSE file. -}

--------------------------------------------------------------------------------
-- | Workspace configuration and utilities.
module XMonad.Local.Workspaces
       ( projects
       , names
       , asKey
       , viewPrevWS
       ) where

--------------------------------------------------------------------------------
import Control.Monad (unless)
import XMonad
import XMonad.Actions.DynamicProjects
import qualified XMonad.StackSet as StackSet

--------------------------------------------------------------------------------
projects :: [Project]
projects =
  [ Project { projectName      = "scratch"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do
                spawn "e -c"
                spawn "konsole"
                spawn "konsole"
            }

  , Project { projectName      = "browsers"
            , projectDirectory = "~/download"
            , projectStartHook = Just $ spawn "firefox"
            }

  , Project { projectName      = "mail"
            , projectDirectory = "~/"
            , projectStartHook = Just $ spawn "e -cs mail"
            }

  , Project { projectName      = "rc"
            , projectDirectory = "~/src/rc"
            , projectStartHook = Nothing
            }

  , Project { projectName      = "rfa"
            , projectDirectory = "~/src/rfa"
            , projectStartHook = Nothing
            }

  , Project { projectName      = "mint"
            , projectDirectory = "~/src/mint"
            , projectStartHook = Nothing
            }

  ]

--------------------------------------------------------------------------------
-- | Names of my workspaces.
names :: [WorkspaceId]
names = ["scratch", "browsers", "agenda", "music", "mail", "chat"]

--------------------------------------------------------------------------------
-- | Helper function to translate workspace names into key names for
-- using in @EZConfig@ key bindings.
asKey :: String -> String
asKey ('F':xs) = "<F" ++ xs ++ ">" -- Function key (i.e. "F1" -> "<F1>")
asKey x        = x                 -- Any other key.

--------------------------------------------------------------------------------
-- | Toggle between the current and previous workspaces.
viewPrevWS :: X ()
viewPrevWS = do
  ws <- gets windowset
  let hs = filter (\w -> StackSet.tag w /= "NSP") $ StackSet.hidden ws
  unless (null hs) (windows . StackSet.view . StackSet.tag $ head hs)
