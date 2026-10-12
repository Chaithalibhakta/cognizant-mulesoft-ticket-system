%dw 2.0
output application/java

fun isHoliday(day, holidays) =
    !isEmpty(
        holidays filter (h) ->
            (h as Date) == (day as Date)
    )

fun isBusinessDay(day, holidays) =
    (day as Date).dayOfWeek >= 1 and
    (day as Date).dayOfWeek <= 5 and
    not isHoliday(day, holidays)

fun nextBusinessStart(dt, holidays) =
    do {
        var day = dt as Date
        var start = day ++ |09:00:00|
        var finish = day ++ |17:00:00|
        ---
        if (not isBusinessDay(day, holidays) or dt >= finish)
            nextBusinessStart(
                ((day + |P1D|) as Date) ++ |09:00:00|,
                holidays
            )
        else if (dt < start)
            start
        else
            dt
    }

fun addBusinessMinutes(start, remaining, holidays) =
    if (remaining <= 0)
        start
    else
        do {
            var current = nextBusinessStart(start, holidays)
            var day = current as Date
            var finish = day ++ |17:00:00|
            var available =
                ((finish as Number) - (current as Number)) / 60000
            ---
            if (remaining <= available)
                current + (
                    ("PT" ++
                    ((remaining as Number) as String {format: "0"})
                    ++ "M") as Period
                )
            else
                addBusinessMinutes(
                    ((day + |P1D|) as Date) ++ |09:00:00|,
                    remaining - available,
                    holidays
                )
        }

fun calculateAckDue(start, priority, ackMinutes, holidays) =
    if (upper(priority default "P3") == "P1")
        start + (
            ("PT" ++
            ((ackMinutes as Number) as String {format: "0"})
            ++ "M") as Period
        )
    else
        addBusinessMinutes(start, ackMinutes, holidays)

---
{
    message: "Business SLA functions ready"
}
