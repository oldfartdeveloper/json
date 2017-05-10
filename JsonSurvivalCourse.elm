module JsonSurvivalCourse exposing (..)

import Html exposing (div, pre, text, button, Html)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, bool, int, float, string, null, list, dict, field, at, oneOf, map, andThen)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, requiredAt, optional)
import Http
import HttpBuilder
import RemoteData exposing (WebData, RemoteData(..))
import Time exposing (second, Time)


main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }



-- MODEL
-- Shouldn't need this for chapter 4


fakeUser =
    """
    {
      "id": 1,
      "name": "Leanne Graham",
      "username": "Bret",
      "email": "Sincere@april.biz",
      "address": {
        "street": "Kulas Light",
        "suite": "Apt. 556",
        "city": "Gwenborough",
        "zipcode": "92998-3874",
        "geo": {
          "lat": "-37.3159",
          "lng": "81.1496"
        }
      },
      "phone": "1-770-736-8031 x56442",
      "website": "hildegard.org",
      "company": {
        "name": "Romaguera-Crona",
        "catchPhrase": "Multi-layered client-server neural-net",
        "bs": "harness real-time e-markets"
      }
    }
    """


type alias Model =
    { user : WebData User
    }


type Msg
    = UserResponse (WebData User)
    | RequestUser
    | Tick Time


type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    }


getUser : Int -> Cmd Msg
getUser id =
    ("http://localhost:3000/users/" ++ toString id)
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson userDecoder)
        |> HttpBuilder.send RemoteData.fromResult
        |> Cmd.map UserResponse


init : ( Model, Cmd Msg )
init =
    ( { user =  Loading }
    , Cmd.none
    )


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        RequestUser ->
            ( model
            , getUser 1
            )

        UserResponse response ->
            ( { model | user = response }
            , Cmd.none
            )

        Tick time ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


view : Model -> Html Msg
view model =
    div[]
        [button[ onClick RequestUser ][ text "Request User"]
        ,
        case model.user of
            NotAsked ->
                text "Initializing."

            Loading ->
                text "Loading."

            Failure err ->
                text ("Error: " ++ toString err)

            Success user ->
                viewUser user
        ]


viewUser : User -> Html msg
viewUser user =
    div []
        [ pre []
            [ user
                |> toString
                |> text
            ]
        ]
