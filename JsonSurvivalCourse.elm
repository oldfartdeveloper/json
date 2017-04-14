
import Html exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, int, float, string, null, list, dict, field, at)


main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


-- MODEL


type alias GithubUser =
    { id : Int
    , login : String
    , name : String
    , gravatarId : Maybe String
    }


type alias Model =
    { github : String
    , nested : String
    }


init : Model
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
              "hireable": null,
              "bio": null,
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
              [ Decode.decodeString (at ["login"] string) model.github
                |> toString
                |> text
              ]
        , pre []
              [ Decode.decodeString (at ["x", "y", "z"] string) model.nested
                |> toString
                |> text
              ]
        ]
