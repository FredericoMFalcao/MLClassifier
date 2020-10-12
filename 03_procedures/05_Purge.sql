-- --------------------
-- - 5. Purge
--
--   Description: when an input shows up in more than "_Threshold" categories, eliminate it
--                example: threshold = 3,
--                         categories = suppliers,
--                         inputs     = words present in an invoice document
--                         explanation: when the word "invoice" shows up in more than 3 suppliers' invoices, 
--                                      eliminate it because it no longer helps distinguish suppliers
--             
-- --------------------

DROP PROCEDURE IF EXISTS Purge;
CREATE PROCEDURE Purge(IN _Threshold INT)
DELETE FROM Inputs WHERE LengthOfDifferentCategories > _Threshold;
