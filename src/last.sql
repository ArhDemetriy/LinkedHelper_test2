-- начало и конец последнего диапазона с максимальным кол-вом одновременных процессов

CREATE TEMP TABLE IF NOT EXISTS startDates AS
SELECT cid, date
FROM events
WHERE type='start';

CREATE TEMP TABLE IF NOT EXISTS endDates AS
SELECT cid, date
FROM events
WHERE type='end';

SELECT startEndIntervals.start as 'start', startEndIntervals.end as 'end', count
FROM (
    (
        -- количество тасков работавших на момент окончания указанного таска
        SELECT startedDates.cid as 'cid', (startedDates.count - endestDates.count) as 'count'
        FROM (
            -- количество тасков начавшихся на момент окончания указанного таска
            SELECT endDates.cid as 'cid', count() as 'count'
            FROM endDates LEFT JOIN startDates
            ON endDates.date >= startDates.date
            GROUP BY endDates.cid
        ) as 'startedDates'
        LEFT JOIN
        (
            -- количество тасков окончившихся до окончания указанного таска
            SELECT endDates.cid as 'cid', count(longTimeEnded.cid) as 'count'
            FROM endDates LEFT JOIN endDates as 'longTimeEnded'
            ON endDates.date > longTimeEnded.date
            GROUP BY endDates.cid
        ) as 'endestDates'
        ON startedDates.cid = endestDates.cid
    ) as 'countTasks'
    LEFT JOIN (
        SELECT endDates.cid AS 'cid', startDates.date AS 'start', endDates.date AS 'end'
        FROM endDates LEFT JOIN startDates
        ON endDates.date >= startDates.date
        GROUP BY endDates.cid
    ) as 'startEndIntervals'
    ON countTasks.cid = startEndIntervals.cid
)
ORDER BY count DESC, start DESC
LIMIT 1;