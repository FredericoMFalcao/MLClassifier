-- --------------------
-- - 3. Predicting
-- --------------------
DROP PROCEDURE IF EXISTS Predict;
DELIMITER //
CREATE PROCEDURE Predict (
	IN _Domain VARCHAR(255),
	IN _Inputs VARCHAR(4096)
)
BEGIN

	SELECT a.Name as Category, SUM(CASE WHEN b.Correlation IS NULL THEN 0 ELSE b.Correlation END) AS Probability
	FROM Categories a
	INNER JOIN InputPerCategory b 	ON a.id = b.CategoryId
	INNER JOIN Inputs c		ON b.InputId = c.id AND JSON_CONTAINS(_Inputs, CONCAT('"',c.Name,'"'))
	WHERE a.Domain = _Domain
	GROUP BY a.id, a.Name

	;
END; 
//
DELIMITER ;
