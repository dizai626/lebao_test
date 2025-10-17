WITH usr_count AS (
    SELECT
        user_id,
        COUNT(*) AS cnt
    FROM
        event_log
    WHERE
        FROM_UNIXTIME(event_timestamp, '%Y-%m-%d') > '2020-08-31'
        AND FROM_UNIXTIME(event_timestamp, '%Y-%m-%d') < '2020-10-01'
    GROUP BY
        user_id
    HAVING
        COUNT(*) >= 1000
        AND COUNT(*) < 2000
)
SELECT
    COUNT(DISTINCT user_id) AS qualified_user_count
FROM
    usr_count;













