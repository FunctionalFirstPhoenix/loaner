module Main exposing (..)

import Html exposing (beginnerProgram, div, button, text, input, br, p, Html)
import Html.Events exposing (onClick, onCheck)
import Html.Attributes exposing (..)
import Date exposing (Date, fromTime)
import Date.Extra.Config.Config_en_us as EnUs
import Date.Extra.Format as Format
import Domain exposing (..)


accounts : List Account
accounts =
    [ { owner = { firstName = "Bob", lastName = "Smith" }
      , balance = 100
      , accountType = Platinum
      , status = Suspended (fromTime 1175820019000) Voluntary
      }
    , { owner = { firstName = "Janet", lastName = "Smyth" }
      , balance = 3000
      , accountType = Platinum
      , status = Active (fromTime 1175820019000)
      }
    ]


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
    beginnerProgram { model = accounts, view = view, update = update }


accountTypeButtons currentAccountType =
    let
        checkedStatusToMessage : AccountType -> Bool -> Msg
        checkedStatusToMessage accountType status =
            if status then
                ChangeAccountType accountType
            else
                NoOp

        makeInput : AccountType -> Html Msg
        makeInput accountType =
            input
                [ type_ "radio"
                , name "account_type"
                , checked (currentAccountType == accountType)
                , onCheck (checkedStatusToMessage accountType)
                ]
                []
    in
        div []
            [ makeInput Normal
            , text "Normal"
            , br [] []
            , makeInput Gold
            , text "Gold"
            , br [] []
            , makeInput Platinum
            , text "Platinum"
            ]


view : Model -> Html Msg
view model =
    div []
        [ renderAccounts model
        ]


type Msg
    = ChangeAccountType AccountType
    | NoOp


type alias Model =
    List Account


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAccountType theUpdatedAccountType ->
            { model | accountType = theUpdatedAccountType }

        NoOp ->
            model


accountBackgroundColor : AccountType -> String
accountBackgroundColor accountType =
    case accountType of
        Normal ->
            "white"

        Gold ->
            "yellow"

        Platinum ->
            "grey"


renderAccounts : List Account -> Html Msg
renderAccounts accounts =
    let
        accountSections =
            List.map renderAccount accounts

        radioButtons =
            List.map (\account -> accountTypeButtons account.accountType) accounts

        finalSections =
            List.map2 (\a b -> div [] [ a, b ]) accountSections radioButtons
    in
        div [] finalSections


renderAccount account =
    div
        [ id "Title"
        , style
            [ ( "backgroundColor"
              , accountBackgroundColor account.accountType
              )
            ]
        ]
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
