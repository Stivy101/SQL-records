WITH A AS (
	SELECT dr_ndrugs AS product,
		   SUM(dr_kol) as amount,
		   SUM(dr_kol*(dr_croz - dr_czak) - dr_sdisc) as profit,
		   SUM(dr_kol*dr_croz - dr_sdisc) as revenue
	FROM sales s
	GROUP BY dr_ndrugs
	)
SELECT product,
	   CASE WHEN SUM(amount) OVER(ORDER BY amount DESC) / SUM(amount) OVER() <= 0.8 THEN 'A'
	   		WHEN SUM(amount) OVER(ORDER BY amount DESC) / SUM(amount) OVER() <= 0.95 THEN 'B'
	   		ELSE 'C'
	   END AS amount_ABC,
	   CASE WHEN SUM(profit) OVER(ORDER BY profit DESC) / SUM(profit) OVER() <= 0.8 THEN 'A'
	        WHEN SUM(profit) OVER(ORDER BY profit DESC) / SUM(profit) OVER() <= 0.95 THEN 'B'
	        ELSE 'C'
	   END AS profit_ABC,
	   CASE WHEN SUM(revenue) OVER(ORDER BY revenue DESC) / SUM(revenue) OVER() <= 0.8 THEN 'A'
	   		WHEN SUM(revenue) OVER(ORDER BY revenue DESC) / SUM(revenue) OVER() <= 0.95 THEN 'B'
	   		ELSE 'C'
	   END AS revenue_ABC
FROM A 
ORDER BY product
	   