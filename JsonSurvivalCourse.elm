
import Html exposing (div, pre, text, Html)
import Json.Decode as Decode exposing (Decoder, bool, int, float, string, null, list, dict, field, at, oneOf, map)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, requiredAt)

main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


-- MODEL


type alias Model =
    { piesAndCakes : String
    }


type alias Pie =
    { filling : String
    , goodWithIceCream : Bool
    , madeBy : String
    }


type alias Cake =
    { flavor : String
    , forABirthday : Bool
    , madeBy : String
    }


type BakedGood
    = PieValue Pie
    | CakeValue Cake


pie : Decoder Pie
pie =
    decode Pie
        |> required "filling" string
        |> required "goodWithIceCream" bool
        |> required "madeBy" string


cake : Decoder Cake
cake =
    decode Cake
        |> required "flavor" string
        |> required "forABirthday" bool
        |> required "madeBy" string


bakedGood : Decoder BakedGood
bakedGood =
    oneOf
        [ map PieValue pie
        , map CakeValue cake
        ]


init =
    { piesAndCakes =
        """
        {
          "cherry": {
            "filling": "cherries and love",
            "goodWithIceCream": true,
            "madeBy": "my grandmother"
          },
          "odd": {
            "filling": "rocks, I think?",
            "goodWithIceCream": false,
            "madeBy": "a child, maybe?"
          },
          "super-chocolate": {
            "flavor": "german chocolate with chocolate shavings",
            "forABirthday": false,
            "madeBy": "the charming bakery up the street"
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
              [ Decode.decodeString (dict bakedGood) model.piesAndCakes
                |> toString
                |> text
              ]
        ]


