-- начало и конец первого диапазона с максимальным кол-вом одновременных процессов

SELECT startDates.cid as cid, start, end
FROM (
    (
        SELECT *
        FROM (
            SELECT cid, date as 'start'
            FROM events
            WHERE type='start'
        )
    ) as 'startDates'
    JOIN (
        SELECT *
        FROM (
            SELECT cid, date as 'end'
            FROM events
            WHERE type='end'
        )
    ) as 'endDates'
    ON startDates.cid = endDates.cid
)


SELECT startDates.cid as cid, start, end
SELECT *, count(endDates.date >= startDates.date) as 'count'
FROM (
    (
        SELECT *
        FROM (
            SELECT cid, date
            FROM events
            WHERE type='end'
        )
    ) as 'endDates'
    LEFT JOIN
    (
        SELECT *
        FROM (
            SELECT cid, date
            FROM events
            WHERE type='start'
        )
    ) as 'startDates'
    ON endDates.date >= startDates.date
)


SELECT count(date)
FROM (
        SELECT cid, date
        FROM events
        WHERE type='start'
    )
GROUP BY cid < 5