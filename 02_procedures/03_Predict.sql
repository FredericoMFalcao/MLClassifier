-- --------------------
-- - 3. Predict
-- --------------------
DROP PROCEDURE IF EXISTS Predict;
DELIMITER //
CREATE PROCEDURE Predict (
	IN _Domain VARCHAR(255),
	IN _Inputs VARCHAR(4096)
)
BEGIN

	SELECT SUM(a.Correlation), c.Name
	FROM InputPerCategory a
	INNER JOIN Inputs b ON a.InputId = b.id
	INNER JOIN Categories c ON a.CategoryId = c.id
	WHERE JSON_CONTAINS(_Inputs, CONCAT('"',b.Name,'"'))
	GROUP BY a.CategoryId, c.Name
	ORDER BY SUM(a.Correlation) DESC
	;
END; 
//
DELIMITER ;

