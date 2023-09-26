WITH A AS (
	SELECT user_id, created_at AS dt
	FROM coderun c
	UNION ALL
	SELECT user_id, created_at AS dt
	FROM codesubmit c2 
	UNION ALL
	SELECT user_id, created_at AS dt
	FROM teststart t 
	)
SELECT TO_CHAR(dt, 'ID'),
	   COUNT(*) AS cnt
FROM A 
GROUP BY TO_CHAR(dt, 'ID') 
	