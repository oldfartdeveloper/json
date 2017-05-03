module JsonSurvivalCourse exposing (..)

import Html exposing (div, pre, text, Html)
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


init : ( Model, Cmd Msg )
init =
    ( { user =  Loading }
    , Cmd.none
    )


type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    }


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string


getUser : Int -> Cmd Msg
getUser id =
    ("https://jsonplaceholder.typicode.com/users/" ++ toString id)
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson userDecoder)
        |> HttpBuilder.send RemoteData.fromResult
        |> Cmd.map UserResponse



-- UPDATE


type Msg
    = UserResponse (WebData User)
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        UserResponse response ->
            ( { model | user = response }
            , Cmd.none
            )

        Tick time ->
            ( model
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    case model.user of
        NotAsked ->
            text "Initializing."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success user ->
            viewUser user


viewUser : User -> Html msg
viewUser user =
    div []
        [ pre []
            [ user
                |> toString
                |> text
            ]
        ]
