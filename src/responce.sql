-- начало и конец первого диапазона с максимальным кол-вом одновременных процессов
SELECT startDates.date as 'start', endDates.date as 'end', count
FROM (
    (
        -- количество тасков работавших на момент окончания указанного таска
        SELECT startedDates.cid as 'cid', (startedDates.count - endestDates.count) as 'count'
        FROM (
            -- количество тасков начавшихся на момент окончания указанного таска
            SELECT endDates.cid as 'cid', count() as 'count'
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
            SELECT endDates.cid as 'cid', count(longTimeEnded.cid) as 'count'
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
    ) as 'countTasks'
    LEFT JOIN
    (
        SELECT *
        FROM (
            SELECT cid, date
            FROM events
            WHERE type='end'
        )
    ) as 'endDates'
    ON countTasks.cid = endDates.cid
    LEFT JOIN
    (
        SELECT *
        FROM (
            SELECT cid, date
            FROM events
            WHERE type='start'
        )
    ) as 'startDates'
    ON countTasks.cid = startDates.cid
)
ORDER BY count DESC, end ASC
LIMIT 1