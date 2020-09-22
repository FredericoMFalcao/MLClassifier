-- --------------------
-- - 1. Calculate Correlations
-- --------------------
DROP PROCEDURE IF EXISTS CalculateCorrelations;
DELIMITER //
CREATE PROCEDURE CalculateCorrelations() 
BEGIN
	UPDATE InputPerCategory ipc
	INNER JOIN Categories y ON y.id = ipc.CategoryId
	INNER JOIN Inputs x     ON x.id = ipc.InputId
	INNER JOIN Domains d    ON d.Name = y.Domain
	--                     n*sum(xi*yi)-sum(x)*sum(y)
	--  corr = ---------------------------------------------------
	--          sqrt( (n*sum(x^2)-sum(x)^2)*(n*sum(y^2)-sum(y)^2)
	--
	--	x - input
	--  y - category
	--  n - domain.Length
	SET Correlation = (d.Length * ipc.Length - x.Length * y.Length) 
						/ sqrt( (d.Length*x.Length-POW(x.Length,2)) * (d.Length*y.Length-POW(y.Length,2)) )
	WHERE (d.Length*x.Length-POW(x.Length,2)) != 0 AND  (d.Length*y.Length-POW(y.Length,2)) != 0
	;

END; //
DELIMITER ;

