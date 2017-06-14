module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date, fromTime)
import Date.Extra.Config.Config_en_us as EnUs
import Date.Extra.Format as Format
import Domain exposing (..)


testAccount : Account
testAccount =
    { owner = { firstName = "Bob", lastName = "Smith" }
    , balance = 100
    , accountType = Gold
    , status = Suspended (fromTime 1175820019000) Voluntary

    -- , status = Closed (fromTime 1175820019000)
    }


fullName : Person -> String
fullName person =
    person.firstName ++ " " ++ person.lastName


dateToString : Date -> String
dateToString =
    Format.format EnUs.config Format.isoFormat


statusToString : AccountStatus -> String
statusToString status =
    case status of
        Active date ->
            "Activated on " ++ dateToString date

        Closed date ->
            "Closed on " ++ dateToString date

        Suspended date reason ->
            "Suspended on "
                ++ dateToString date
                ++ " for "
                ++ case reason of
                    PastDue ->
                        "expiration"

                    RulesViolation ->
                        "breaking the rules"

                    Voluntary ->
                        "voluntary"


main =
    div [ id "Title", style [ ( "backgroundColor", "yellow" ) ] ]
        [ p []
            [ text <| "Account Owner: " ++ (fullName testAccount.owner)
            ]
        , p []
            [ text <| "Balance: " ++ (toString testAccount.balance)
            ]
        , p []
            [ text <| "Account Type: " ++ (toString testAccount.accountType)
            ]
        , p []
            [ text <| "Status: " ++ (statusToString testAccount.status)
            ]
        ]
