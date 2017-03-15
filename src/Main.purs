module Main where

import Prelude
import Control.Monad.Aff (Aff, launchAff, runAff)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Foldable (maximum)
import Data.Function (apply, applyFlipped)
import Data.List (foldl)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (length)
import Data.String.Utils (lines)
import Node.Encoding (Encoding(..))
import Node.FS (FS)
import Node.FS.Aff (readTextFile)

infixr 0 apply as <|
infixl 1 applyFlipped as |>

main :: forall e. Eff (console :: CONSOLE, fs :: FS, err :: EXCEPTION | e) Unit
main = do
  canceller <- launchAff do
    fileText <- readTextFile UTF8 "bower.json"
    log <| processText fileText

    -- let fileByLines = lines fileText
    -- let linesByLength = map length fileByLines
    -- let maxLineLength = fromMaybe 0 (maximum linesByLength)
    -- log <| show maxLineLength
  pure unit

processText :: String -> String
processText text =
  lines text
    |> map length
    |> maximum
    |> fromMaybe 0
    |> show
    

foo :: forall a. a -> a
foo value = value

-- comment
type UserAccount =
  { name :: String
  , amount :: Number
  , id :: Int
  }

user :: UserAccount
user = { name: "Alfredo", amount: 100.0, id: 1}

maybeInt :: Maybe Int
maybeInt = Just 5

maybeToString :: Maybe Int -> String
maybeToString Nothing = "0"
maybeToString (Just n) = show (n * 100)

data AccountStatus
  = Closed
  | Open
  | Behind Number

x :: Int
x = 5

double :: Int -> Int
double n = n * 2

calculateInterest :: Number -> Number -> Number
calculateInterest a b = a * b

calculateInterestOn100 :: Number -> Number
calculateInterestOn100 = calculateInterest 100.0
