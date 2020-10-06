-- --------------------
-- - 3. Predicting
-- --------------------
DROP PROCEDURE IF EXISTS Predict;
DELIMITER //
CREATE PROCEDURE Predict (
	IN _Domain VARCHAR(255),
	IN _Inputs TEXT,
	IN _LimitRows INT
)
BEGIN

	SELECT 
		a.Name AS Category, 
		AVG(b.Length / c.Length) AS Probability
	FROM Categories a
	INNER JOIN InputPerCategory b 	ON a.id = b.CategoryId
	INNER JOIN Inputs c		ON b.InputId = c.id AND JSON_CONTAINS(_Inputs, CONCAT('"',c.Name,'"'))
	WHERE a.Domain = _Domain
	GROUP BY a.id, a.Name
	ORDER BY AVG(b.Length / c.Length) DESC
	LIMIT _LimitRows

	;
END; 
//
DELIMITER ;
