
import Html exposing (div, pre, text, Html)
import Json.Decode as Decode exposing (Decoder, bool, int, float, string, null, list, dict, field, at, oneOf, map, andThen)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, requiredAt, optional)

main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


-- MODEL


type alias Model =
    { duckula : String
    }


type alias User =
     { id : Int
     , name : String
     , username : String
     , email : String
     , age : Maybe Int
     }


user : Decoder User
user =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string
        |> optional "age" (map Just int) Nothing


userList : Decoder (List User)
userList =
    oneOf
        [ list user
        , user |> map (\user -> [ user ])
        ]

init =
    { duckula =
        """
          [
                {
                  "id": 1,
                  "name": "Count Duckula",
                  "username": "feathersandfangs",
                  "email": "quack@countduckula.com"
                }
          ]
        """
    }


-- UPDATE


type Msg
    = Reset


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset ->
      model


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ pre []
              [ Decode.decodeString userList model.duckula
                |> toString
                |> text
              ]
        ]


