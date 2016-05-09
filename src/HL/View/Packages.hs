{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

-- | Packages page view.

module HL.View.Packages
    ( packagesV
    ) where

import Data.Foldable
import Data.List.Split
import Data.Monoid ((<>))
import HL.Model.Packages
import HL.View
import HL.View.Template
import Prelude hiding (pi)

-- | Packages view.
packagesV :: PackageInfo -> FromLucid App
packagesV pi =
  template []
           "Packages"
           (\_ ->
              (container_
                 (row_ (span12_ [class_ "col-md-12"]
                                (content pi)))))

content :: PackageInfo -> Html ()
content pi =
  do h1_ (toHtml ("Haskell Packages" :: String))
     toHtml (piIntro pi)
     h2_ [id_ "_cores"] "Core"
     toHtml (piFundamentalsIntro pi)
     mapM_ (row_ . mapM_ (span3_ [class_ "col-md-3"] . package False))
           (chunksOf 4 (toList (piFundamentals pi)))
     h2_ [id_ "_commons"] "Common"
     toHtml (piCommonsIntro pi)
     mapM_ (row_ . mapM_ common)
           (chunksOf 2 (toList (piCommons pi)))

package :: Bool -> Package -> Html ()
package isCommon f =
  a_ [class_ "package-big-link"
     ,href_ ("https://www.stackage.org/package/" <> packageName f)]
     (do let heading_ =
               if isCommon
                  then h4_
                  else h3_
         heading_ [id_ (packageName f)]
                  (toHtml (packageName f))
         span_ [class_ "pkg-desc"]
               (toHtml (packageDesc f)))

common :: Common -> Html ()
common c =
  span6_ [class_ "col-md-6"]
         (do do let ident = "_common_" <> commonSlug c
                h3_ [id_ ident]
                    (a_ [href_ ("#" <> ident)]
                        (toHtml (commonTitle c)))
                toHtml (commonDesc c)
                row_ (mapM_ (span6_ [class_ "col-md-6"] . package True)
                            (commonChoices c)))
