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
