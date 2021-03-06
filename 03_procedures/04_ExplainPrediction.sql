-- --------------------
-- - 4. Explaining Prediction 
-- --------------------
DROP PROCEDURE IF EXISTS ExplainPrediction;
DELIMITER //
CREATE PROCEDURE ExplainPrediction (
	IN _Domain VARCHAR(255),
	IN _CategoryName TEXT,
	IN _Inputs TEXT
)
BEGIN


        WITH ProbabilityPerWord AS ( 
           SELECT 
              c.Name as InputName, 
              a.Length / c.Length AS Probability
           FROM InputPerCategory a
           INNER JOIN Categories b ON a.CategoryId = b.id
           INNER JOIN Inputs c     ON a.InputId = c.id 
           WHERE JSON_CONTAINS(_Inputs, CONCAT('"',c.Name,'"'))  AND b.Name = _CategoryName
        )
          SELECT  InputName, Probability
          FROM ProbabilityPerWord
        UNION ALL 
	  SELECT '__AVERAGE', AVG(Probability)
	  FROM ProbabilityPerWord
	  GROUP BY 1
          ORDER BY Probability DESC;
        

END;
//
DELIMITER ;
