module App.State where

import App.Config (config)
import App.Routes (Route, match, toURL)
import Control.Applicative (pure)
import Control.Bind (bind)
import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, jsonEmptyObject, (.?), (:=), (~>))
import Data.Function (($))

data State = State
  { title :: String
  , route :: Route
  , loaded :: Boolean
  , clicks :: Int
  }

instance decodeJsonState :: DecodeJson State where
  decodeJson json = do
    obj <- decodeJson json
    title <- obj .? "title"
    url <- obj .? "route"
    loaded <- obj .? "loaded"
    clicks <- obj .? "clicks"
    pure $ State
      { title
      , loaded
      , route: match url
      , clicks
      }

instance encodeJsonState :: EncodeJson State where
  encodeJson (State st) =
       "title" := st.title
    ~> "route" := toURL st.route
    ~> "loaded" := st.loaded
    ~> "clicks" := st.clicks
    ~> jsonEmptyObject

init :: String -> State
init url = State
  { title: config.title
  , route: match url
  , loaded: false
  , clicks: 0
  }
