module Main exposing (..)

import Html exposing (program, div, button, text, input, br, p, Html)
import Html.Events exposing (onClick, onCheck)
import Html.Attributes exposing (style, id, type_, name, checked)
import Date exposing (Date, fromTime)
import Date.Extra.Config.Config_en_us as EnUs
import Date.Extra.Format as Format
import Dict exposing (Dict, empty, insert)
import Domain exposing (..)
import Debug
import Http exposing (Error)
import Json.Decode exposing (list, int, string, float, nullable, Decoder, andThen, field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


model : Model
model =
    { accounts = empty
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


accountDecoder =
    decode Account
        |> required "id" int
        |> required "owner" personDecoder
        |> required "balance" int
        |> required "accountType" accountTypeDecoder
        |> hardcoded (Active (fromTime 1175820019000))



-- |> required "status" accountStatusDecoder


accountTypeDecoder =
    let
        typeNameToAccountType typeName =
            case typeName of
                "Platinum" ->
                    Json.Decode.succeed Platinum

                "Gold" ->
                    Json.Decode.succeed Gold

                "Normal" ->
                    Json.Decode.succeed Normal

                _ ->
                    Json.Decode.fail <| "Invalid account type" ++ typeName
    in
        string
            |> andThen typeNameToAccountType


personDecoder : Decoder Person
personDecoder =
    decode Person
        |> required "firstName" string
        |> required "lastName" string



{-
   -- FIXME: TBD
   accountStatusDecoder :
   accountStatusDecoder =
       -- field "type" (string |> andThen stringToStatusType)
       field "type" string
-}


parseSuspensionReason : String -> Maybe SuspensionReason
parseSuspensionReason reasonString =
    case reasonString of
        "PastDue" ->
            Just PastDue

        "RulesViolation" ->
            Just RulesViolation

        "Voluntary" ->
            Just Voluntary

        _ ->
            Nothing



--suspentionReason
--  hardcoded (Active (fromTime 1175820019000))


loadAccountData =
    Http.send AccountDataRecieved (Http.get "http://localhost:8000/src/accounts.json" (list accountDecoder))


main =
    program
        { init = ( model, loadAccountData )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }


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
    | AccountDataRecieved (Result Error (List Account))
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
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
                        ( { model | accounts = updatedAccounts }, Cmd.none )

        AccountDataRecieved result ->
            case result of
                Err error ->
                    Debug.crash (toString error)

                Ok accounts ->
                    let
                        accountDict =
                            List.foldl
                                (\account d -> Dict.insert account.id account d)
                                Dict.empty
                                accounts

                        -- refactored to List.foldl
                        -- Dict.fromList <|
                        --     List.map (\account -> ( account.id, account )) accounts
                    in
                        ( { model | accounts = accountDict }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


accountBackgroundColor : AccountType -> String
accountBackgroundColor accountType =
    case accountType of
        Normal ->
            "white"

        Gold ->
            "gold"

        Platinum ->
            "#E5E4E2"


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
