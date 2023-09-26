WITH abc AS (
		SELECT dr_ndrugs AS product,
		   	SUM(dr_kol) as amount,
		   	SUM(dr_kol*(dr_croz - dr_czak) - dr_sdisc) as profit,
		   	SUM(dr_kol*dr_croz - dr_sdisc) as revenue
		FROM sales s
		GROUP BY dr_ndrugs
		),
	xyz_sales AS (
		SELECT dr_ndrugs AS product,
		   	TO_CHAR(dr_dat, 'YYYY-WW') AS ym,
		   	SUM(dr_kol) AS sales
    	FROM sales
    	GROUP BY product, ym
    	),
    xyz_a AS (
    	SELECT product,
    		   CASE WHEN STDDEV_SAMP(sales)/AVG(sales) >= 0.25 THEN 'Z'
    		   		WHEN STDDEV_SAMP(sales)/AVG(sales) >= 0.1 THEN 'Y'
    		   		ELSE 'X'
    		   END xyz_cat
        FROM xyz_sales
        GROUP BY product
        )
SELECT abc.product,
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
	   END AS revenue_ABC,
	   xyz_a.xyz_cat
FROM abc
LEFT JOIN xyz_a ON abc.product = xyz_a.product 
ORDER BY product
	   