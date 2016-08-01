import Html.App
import Html.Events exposing (onClick)
import Html exposing (Html, div, button, text)


main : Program Never
main =
    Html.App.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { x : Float
    , y : Float
    }

model : Model
model =
    { x = 0
    , y = 0
    }


type Msg = Move

update : Msg -> Model -> Model
update msg model =
    case msg of

        Move ->
            { model
            | x = model.x + 1
            , y = model.y + 1
            }


view : Model -> Html Msg
view model =
    let
        coords = "(" ++ toString model.x ++ ", " ++ toString model.y ++ ")"
    in
        div []
            [ text coords
            , button [ onClick Move ]
                [ text "Move!" ]
            ]
