-- --------------------
-- - 5. PurgeIrrelevantInputs
--
--   Description: when an input shows up in more than "_Threshold" categories, eliminate it
--                example: threshold = 3,
--                         categories = suppliers,
--                         inputs     = words present in an invoice document
--                         explanation: when the word "invoice" shows up in more than 3 suppliers' invoices, 
--                                      eliminate it because it no longer helps distinguish suppliers
--             
-- --------------------

DROP PROCEDURE IF EXISTS PurgeIrrelevantInputs;
CREATE PROCEDURE PurgeIrrelevantInputs(IN _Threshold INT)
DELETE FROM Inputs 
WHERE id IN (
	SELECT b.InputId
	FROM InputPerCategory b
	GROUP BY b.InputId
	HAVING COUNT(b.CategoryId) > _Threshold
);
