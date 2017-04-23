module App.Events where

import App.Routes (Route)
import App.State (State(..))
import Data.Function (($))
import Network.HTTP.Affjax (AJAX)
import Pux (EffModel, noEffects)
import Prelude ((+))

data Event
  = PageView Route
  | ButtonClicked

type AppEffects fx = (ajax :: AJAX | fx)

foldp :: forall fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView route) (State st) =
  noEffects $ State $ st { route = route, loaded = true }
foldp ButtonClicked (State st) =
  noEffects $ State $ st { clicks = st.clicks + 1 }
