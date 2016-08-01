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
    { points : List Point
    }

type alias Point =
    { x : Float
    , y : Float
    }

model : Model
model =
    { points =
        [ Point 0 0
        , Point 10 10
        , Point 20 20
        , Point 30 30
        ]
    }


type Msg = Move

update : Msg -> Model -> Model
update msg model =
    case msg of

        Move ->
            let
                movePoint = (\{x, y} -> { x = x + 1, y = y + 1 })
            in
                { model | points = List.map movePoint model.points }


view : Model -> Html Msg
view model =
    div []
        [ div [] (List.map coord model.points)
        , button [ onClick Move ]
            [ text "Move!" ]
        ]

coord : Point -> Html msg
coord point =
    let
        coords = "(" ++ toString point.x ++ ", " ++ toString point.y ++ ")"
    in
        text coords
