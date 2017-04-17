
import Html exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, int, float, string, null, list, dict, field, at, oneOf)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, requiredAt)

main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


-- MODEL


type alias GithubUser =
    { login : String
    , id : Int
    , avatarUrl : String
    , gravatarId : String
    , url : String
    , htmlUrl : String
    , followersUrl : String
    , followingUrl : String
    , gistsUrl : String
    , starredUrl : String
    , subscriptionsUrl : String
    , organizationsUrl : String
    , reposUrl : String
    , eventsUrl : String
    , receivedEventsUrl : String
    , type_ : String
    , siteAdmin : Bool
    , name : String
    , company : String
    , blog : String
    , location : String
    , email : String
    , hireable : Maybe Bool
    , bio : Maybe String
    , publicRepos : Int
    , publicGists : Int
    , followers : Int
    , following : Int
--    , createdAt : String
--    , updatedAt : String
    }


type alias Model =
    { github : String
    , nested : String
    , pies : String
    , piesAndCakes : String
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
    { github =
            """
            {
              "login": "octocat",
              "id": 583231,
              "avatar_url": "https://avatars.githubusercontent.com/u/583231?v=3",
              "gravatar_id": "",
              "url": "https://api.github.com/users/octocat",
              "html_url": "https://github.com/octocat",
              "followers_url": "https://api.github.com/users/octocat/followers",
              "following_url": "https://api.github.com/users/octocat/following{/other_user}",
              "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
              "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
              "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
              "organizations_url": "https://api.github.com/users/octocat/orgs",
              "repos_url": "https://api.github.com/users/octocat/repos",
              "events_url": "https://api.github.com/users/octocat/events{/privacy}",
              "received_events_url": "https://api.github.com/users/octocat/received_events",
              "type": "User",
              "site_admin": false,
              "name": "The Octocat",
              "company": "GitHub",
              "blog": "http://www.github.com/blog",
              "location": "San Francisco",
              "email": "octocat@github.com",
              "hireable": true,
              "bio": "a bio",
              "public_repos": 7,
              "public_gists": 8,
              "followers": 1667,
              "following": 6,
              "created_at": "2011-01-25T18:44:36Z",
              "updated_at": "2016-12-23T05:44:24Z"
            }
            """
    , nested =
        """
        {
          "x": {
            "y": {
              "z": "Hello, World!"
            }
          }
        }
        """
    , pies =
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
          }
        }
        """
    , piesAndCakes =
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
              [ text model.github
              ]
        , pre []
              [ Decode.decodeString githubUser model.github
                |> toString
                |> text
              ]
        , pre []
              [ Decode.decodeString (at ["x", "y", "z"] string) model.nested
                |> toString
                |> text
              ]
        , pre []
              [ Decode.decodeString (dict pie) model.pies
                |> toString
                |> text
              ]
        , pre []
              [ Decode.decodeString (dict bakedGood) model.piesAndCakes
                |> toString
                |> text
              ]
        ]


gravatarId : Decoder (Maybe String)
gravatarId =
    Decode.map (\id -> if id == "" then Nothing else Just id) string


loginAndName : Decoder (String, String)
loginAndName =
    Decode.map2 (,)
        (field "login" string)
        (field "name" string)


githubUser : Decoder GithubUser
githubUser =
    Pipeline.decode GithubUser
        |> Pipeline.required "login" (string)
        |> Pipeline.required "id" (int)
        |> Pipeline.required "avatar_url" (string)
        |> Pipeline.required "gravatar_id" (string)
        |> Pipeline.required "url" (string)
        |> Pipeline.required "html_url" (string)
        |> Pipeline.required "followers_url" (string)
        |> Pipeline.required "following_url" (string)
        |> Pipeline.required "gists_url" (string)
        |> Pipeline.required "starred_url" (string)
        |> Pipeline.required "subscriptions_url" (string)
        |> Pipeline.required "organizations_url" (string)
        |> Pipeline.required "repos_url" (string)
        |> Pipeline.required "events_url" (string)
        |> Pipeline.required "received_events_url" (string)
        |> Pipeline.required "type" (string)
        |> Pipeline.required "site_admin" (bool)
        |> Pipeline.required "name" (string)
        |> Pipeline.required "company" (string)
        |> Pipeline.required "blog" (string)
        |> Pipeline.required "location" (string)
        |> Pipeline.required "email" (string)
        |> Pipeline.required "hireable" (Decode.maybe bool)
        |> Pipeline.required "bio" (Decode.maybe string)
        |> Pipeline.required "public_repos" (int)
        |> Pipeline.required "public_gists" (int)
        |> Pipeline.required "followers" (int)
        |> Pipeline.required "following" (int)
--        |> Pipeline.required "createdAt" (string)
--        |> Pipeline.required "updatedAt" (string)


