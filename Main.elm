module Main exposing (..)

import Window
import AnimationFrame
import Time exposing (Time)
import Html.App exposing (program)
import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)


main : Program Never
main =
    program
        { init = ( init, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { particles : List Particle
    , windowSize : Window.Size
    }


type alias Particle =
    { r : Float
    , x : Float
    , y : Float
    , vx : Float
    , vy : Float
    }


init : Model
init =
    { windowSize = Window.Size 500 500
    , particles =
        [ { r = 10, x = 10, y = 10, vx = 3, vy = 2 }
        , { r = 25, x = 10, y = 10, vx = 4, vy = 2 }
        ]
    }


type Msg
    = Tick Time
    | Resize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick dt ->
            physics dt model ! []

        Resize size ->
            { model | windowSize = size } ! []


physics : Time -> Model -> Model
physics dt model =
    let
        particles' =
            List.map
                (\p ->
                    p
                        |> gravity dt
                        |> move dt
                        |> bounce model.windowSize
                )
                model.particles
    in
        { model | particles = particles' }


move : Time -> Particle -> Particle
move dt p =
    { p
        | x = p.x + p.vx * dt
        , y = p.y + p.vy * dt
    }


gravity : Time -> Particle -> Particle
gravity dt p =
    { p | vy = p.vy - 0.05 }


bounce : Window.Size -> Particle -> Particle
bounce { width, height } p =
    let
        width' =
            toFloat width

        height' =
            toFloat height

        ( x', vx' ) =
            applyBoundaries ( p.x, p.vx ) ( 0, width' )

        ( y', vy' ) =
            applyBoundaries ( p.y, p.vy ) ( 0, height' )
    in
        { p
            | x = x'
            , y = y'
            , vx = vx'
            , vy = vy'
        }


applyBoundaries : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
applyBoundaries ( pos, vel ) ( minBound, maxBound ) =
    if pos >= maxBound then
        ( maxBound, flipVelocity vel )
    else if pos <= 0 then
        ( 0, flipVelocity vel )
    else
        ( pos, vel )


flipVelocity : Float -> Float
flipVelocity =
    (*) -0.6


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick
        , Window.resizes Resize
        ]


view : Model -> Html Msg
view model =
    div [] (List.map renderParticle model.particles)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


renderParticle : Particle -> Html msg
renderParticle { x, y, r } =
    let
        addUnits =
            (\x -> x ++ "px")

        left =
            toString (x - r) |> addUnits

        bottom =
            toString (y - r) |> addUnits

        size =
            toString (r * 2) |> addUnits
    in
        div
            [ style
                [ "position" => "fixed"
                , "left" => left
                , "bottom" => bottom
                , "width" => size
                , "height" => size
                , "border-radius" => "50%"
                , "background" => "black"
                ]
            ]
            []
