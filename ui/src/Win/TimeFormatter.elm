module Win.TimeFormatter exposing (timeDifference, winingTime, winingTimeDifference)

import Time exposing (Posix)


timeDifference : Posix -> Posix -> Int
timeDifference startTime endTime =
    Time.posixToMillis endTime - Time.posixToMillis startTime


winingTimeDifference : Posix -> Posix -> String
winingTimeDifference startTime endTime =
    timeDifference startTime endTime |> winingTime


winingTime : Int -> String
winingTime millis =
    hoursFormat millis
        ++ minsFormat millis
        ++ secsFormat millis
        ++ millisFormat millis


type Units
    = Millis
    | Seconds
    | Minutes
    | Hours


unitsToConst : Units -> Float
unitsToConst unit =
    case unit of
        Millis ->
            1

        Seconds ->
            1000

        Minutes ->
            60 * 1000

        Hours ->
            60 * 60 * 1000


parse : Units -> Int -> Int
parse unit millis =
    floor (toFloat millis / unitsToConst unit)


addLeadingZero : Int -> String -> String
addLeadingZero contingentValue value =
    if String.length value == 1 && contingentValue > 0 then
        "0" ++ value

    else
        value


millisFormat : Int -> String
millisFormat millis =
    String.fromInt (millis |> parse Millis |> modBy 1000)


secsFormat : Int -> String
secsFormat millis =
    let
        secs =
            millis |> parse Seconds |> modBy 60
    in
    (secs
        |> String.fromInt
        |> addLeadingZero (millis |> parse Minutes)
    )
        ++ "."


minsFormat : Int -> String
minsFormat millis =
    let
        mins =
            millis |> parse Minutes
    in
    if mins > 0 then
        (mins
            |> modBy 60
            |> String.fromInt
            |> addLeadingZero (millis |> parse Hours)
        )
            ++ ":"

    else
        ""


hoursFormat : Int -> String
hoursFormat millis =
    let
        hours =
            millis |> parse Hours
    in
    if hours > 0 then
        String.fromInt (hours |> modBy 24) ++ ":"

    else
        ""
