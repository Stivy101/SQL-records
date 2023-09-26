WITH a AS (
	SELECT TO_CHAR(entry_at, 'YYYY-MM'), COUNT(DISTINCT user_id) AS cnt_user
	FROM userentry u
	GROUP BY TO_CHAR(entry_at, 'YYYY-MM')
	)
SELECT round(AVG(cnt_user)) AS MAU
FROM a