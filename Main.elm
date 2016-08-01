import Html.App
import Html exposing (..)


main : Program Never
main =
    Html.App.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model = String

model : Model
model = "\"Hello, World!\""


type Msg = None

update : Msg -> Model -> Model
update msg model =
    case msg of
        _ -> model


view : Model -> Html msg
view model = text model
