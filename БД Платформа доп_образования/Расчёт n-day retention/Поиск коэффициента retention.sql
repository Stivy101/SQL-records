WITH a AS (
	SELECT u.user_id AS user_id,
		   DATE(u.entry_at) AS entry_at,
		   DATE(users.date_joined) AS date_joined,
		   EXTRACT(DAYS FROM u.entry_at - users.date_joined) AS diff,
		   TO_CHAR(users.date_joined, 'YYYY-MM') AS cohort
	FROM userentry u
	INNER JOIN users ON u.user_id = users.id
	WHERE TO_CHAR(users.date_joined, 'YYYY') = '2022'
	)
SELECT cohort,
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 0 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 1 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 1 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 3 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 3 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 7 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 7 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 14 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 14 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 30 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 30 (%)",
	   ROUND(COUNT(DISTINCT CASE WHEN diff = 60 THEN user_id END) * 100.00 / COUNT(DISTINCT CASE WHEN diff = 0 THEN user_id END), 2) AS "day 60 (%)"
FROM a
GROUP BY cohort