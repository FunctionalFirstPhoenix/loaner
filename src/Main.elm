module Main exposing (..)

import Html exposing (beginnerProgram, div, button, text, input, br, p, Html)
import Html.Events exposing (onClick, onCheck)
import Html.Attributes exposing (..)
import Date exposing (Date, fromTime)
import Date.Extra.Config.Config_en_us as EnUs
import Date.Extra.Format as Format
import Dict exposing (Dict, empty, insert)
import Domain exposing (..)
import Debug


model : Model
model =
    { accounts =
        empty
            |> insert 0
                { id = 0
                , owner = { firstName = "Bob", lastName = "Smith" }
                , balance = 100
                , accountType = Platinum
                , status = Suspended (fromTime 1175820019000) Voluntary
                }
            |> insert 1
                { id = 1
                , owner = { firstName = "Janet", lastName = "Smyth" }
                , balance = 3000
                , accountType = Platinum
                , status = Active (fromTime 1175820019000)
                }
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
    beginnerProgram { model = model, view = view, update = update }


accountTypeButtons currentAccountId currentAccountType =
    let
        checkedStatusToMessage : AccountType -> Bool -> Msg
        checkedStatusToMessage accountType status =
            if status then
                ChangeAccountType currentAccountId accountType
            else
                NoOp

        makeInput : AccountType -> Html Msg
        makeInput accountType =
            input
                [ type_ "radio"
                , name <| "account_type_" ++ toString currentAccountId
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
        [ renderAccounts model.accounts
        ]


type Msg
    = ChangeAccountType AccountId AccountType
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAccountType accountId theUpdatedAccountType ->
            case Dict.get accountId model.accounts of
                Nothing ->
                    Debug.crash "Invalid account ID"

                Just account ->
                    let
                        updatedAccounts =
                            Dict.insert accountId { account | accountType = theUpdatedAccountType } model.accounts
                    in
                        { model | accounts = updatedAccounts }

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


renderAccounts : Dict Int Account -> Html Msg
renderAccounts accounts =
    let
        accountList =
            Dict.values accounts |> List.sortBy (\act -> act.id)

        accountSections =
            List.map renderAccount accountList

        radioButtons =
            List.map (\account -> accountTypeButtons account.id account.accountType) accountList

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
