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

   WITH WordList AS ( 
           SELECT a.id 
           FROM Inputs a 
           WHERE JSON_CONTAINS(_Inputs, CONCAT('"',a.Name,'"'))
   ),
   UnNormalizedProbabilities AS (
      SELECT 
                   a.Name AS Category, 
                   AVG(b.Length / c.Length) AS Probability
              FROM Categories a
              INNER JOIN InputPerCategory b   ON a.id = b.CategoryId
              INNER JOIN Inputs c             ON b.InputId = c.id 
              INNER JOIN WordList d           ON c.id = d.id
	      INNER JOIN Domains e            ON a.DomainId = e.id
              WHERE e.Name = _Domain
              GROUP BY a.id, a.Name
   ),
    TotalOfSum AS (
       SELECT SUM(Probability) as Total FROM UnNormalizedProbabilities
    )
   SELECT
      a.Category,
      a.Probability / b.Total
   FROM UnNormalizedProbabilities a
   INNER JOIN TotalOfSum b
   ORDER BY a.Probability DESC
   LIMIT _LimitRows
   ;


END; 
//
DELIMITER ;
