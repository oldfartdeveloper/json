
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
    { user : String
    }


type alias User =
     { id : Int
     , name : String
     , username : String
     , email : String
     }


user : Decoder User
user =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string


init =
    { user =
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
              [ Decode.decodeString user model.user
                |> toString
                |> text
              ]
        ]


