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
SELECT *, count() as 'count'
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

-- количество тасков начавшихся на момент окончания указанного таска
SELECT endDates.cid as 'cid', endDates.date as 'date', count() as 'count'
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
GROUP BY endDates.cid
ORDER BY endDates.date