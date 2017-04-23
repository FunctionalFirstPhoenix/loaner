module App.View.Homepage where

import App.Events (Event(..))
import App.State (State(..))
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onClick)
import Text.Smolder.HTML (a, div, h1, button)
import Text.Smolder.HTML.Attributes (href, onclick)
import Text.Smolder.Markup ((!), text, withEvent, on)
import Prelude (bind, show)
import Utils (debug)

view :: State -> HTML Event
view (State st) =
  div do
    h1 $ a ! href "https://www.purescript-pux.org" $ text st.title
    button `withEvent` onClick (\_ -> ButtonClicked) $ text "Click me"
    div $ text $ show (debug st).clicks
