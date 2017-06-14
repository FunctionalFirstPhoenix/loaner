module Main exposing (..)

import Html exposing (beginnerProgram, div, button, text, input, br, p)
import Html.Events exposing (onClick)
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
    beginnerProgram { model = testAccount, view = view, update = update }


accountTypeButtons currentAccountType =
    div []
        [ input
            [ type_ "radio"
            , name "account_type"
            , checked (currentAccountType == Normal)
            ]
            []
        , text "Normal"
        , br [] []
        , input
            [ type_ "radio"
            , name "account_type"
            , checked (currentAccountType == Gold)
            ]
            []
        , text "Gold"
        , br [] []
        , input
            [ type_ "radio"
            , name "account_type"
            , checked (currentAccountType == Platinum)
            ]
            []
        , text "Platinum"
        ]


view model =
    div []
        [ renderAccount model
        , accountTypeButtons model.accountType
        ]


type Msg
    = Increment
    | Decrement


update msg model =
    model


renderAccount account =
    div [ id "Title", style [ ( "backgroundColor", "yellow" ) ] ]
        [ p []
            [ text <| "Account Owner: " ++ (fullName account.owner)
            ]
        , p []
            [ text <| "Balance: " ++ (toString account.balance)
            ]
        , p []
            [ text <| "Account Type: " ++ (toString account.accountType)
            ]
        , p []
            [ text <| "Status: " ++ (statusToString account.status)
            ]
        ]
