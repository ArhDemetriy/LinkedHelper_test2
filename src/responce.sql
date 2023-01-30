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


SELECT startedDates.cid as 'cid', startedDates.date as 'start', endestDates.date as 'end', startedDates.count, endestDates.count
FROM (
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
) as 'startedDates'
LEFT JOIN
(
    -- количество тасков окончившихся до окончания указанного таска
    SELECT endDates.cid as 'cid', endDates.date as 'date', count(longTimeEnded.cid) as 'count'
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
                WHERE type='end'
            )
        ) as 'longTimeEnded'
        ON endDates.date > longTimeEnded.date
    )
    GROUP BY endDates.cid
) as 'endestDates'
ON startedDates.cid = endestDates.cid
