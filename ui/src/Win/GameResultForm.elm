module Win.GameResultForm exposing (isFormValid, submitGame)

import Html exposing (button, div, label, text, textarea)
import Html.Attributes exposing (disabled, for, maxlength, name, placeholder, style, title)
import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Rating
import RemoteData
import Requests exposing (errorToString)
import Win.Score exposing (GameResult)


submitGame { class, submittedScoreResponse, ratingState, formData } =
    div
        []
        (case submittedScoreResponse of
            RemoteData.NotAsked ->
                [ div
                    [ class "submit-score-form" ]
                    [ div [] [ text "Please rate Your Experience" ]
                    , Html.map RatingMsg
                        (Rating.styleView
                            [ ( "color", "gold" )
                            , ( "font-size", "2.5rem" )
                            , ( "cursor", "pointer" )
                            ]
                            ratingState
                        )
                    , label [ style "margin" ".5rem", for "suggestion" ] [ text "Give us feedback or tell us what squares you’d like to add!" ]
                    , div []
                        [ textarea
                            [ name "suggestion"
                            , class "suggestion-input"
                            , placeholder "I loved it! I want to add..."
                            , title "Enter a suggestion (max 100 characters)"
                            , maxlength 100
                            , onInput Suggestion
                            ]
                            []
                        ]
                    , div []
                        [ let
                            disable =
                                not (isFormValid formData)
                          in
                          button
                            [ class "submitScoreButton"
                            , disabled disable
                            , onClick SubmitGame
                            ]
                            [ text "Play Again!" ]
                        ]
                    ]
                ]

            RemoteData.Success _ ->
                [ div
                    [ style "font-size" "1.5rem" ]
                    [ text "😀Thanks for your feedback!😀" ]
                ]

            RemoteData.Failure error ->
                [ text ("Failed to submit " ++ errorToString error) ]

            RemoteData.Loading ->
                [ text "Submitting" ]
        )


isFormValid : GameResult -> Bool
isFormValid gameResult =
    let
        initialsLength =
            String.length gameResult.player
    in
    initialsLength > 1 && initialsLength < 5 && gameResult.rating > 0
