-- --------------------
-- - 2. LEARN
-- --------------------
DROP PROCEDURE IF EXISTS Learn;
DELIMITER //
CREATE PROCEDURE Learn (
	IN Domain VARCHAR(255),
	IN Category VARCHAR(255),
	IN Inputs VARCHAR(4096)
)
BEGIN
	DECLARE _CategoryId INT;
	DECLARE _InputId INT;
	DECLARE i INT;
	DECLARE Input VARCHAR(255);

	-- 1. Create new or update a "domain"
	-- ------------------------------------
	IF NOT EXISTS (SELECT * FROM Domains WHERE Name = Domain) THEN
		INSERT INTO Domains (Name) VALUES (Domain);
	ELSE
		UPDATE Domains SET Length = Length + 1 WHERE Name = Domain;
	END IF;
	
	-- 2. Create new or update a "category"
	-- ------------------------------------
	IF NOT EXISTS (SELECT * FROM Categories WHERE Domain = Domain AND Name = Category) THEN
		INSERT INTO Categories (Domain, Name) VALUES (Domain, Category);
	ELSE
		UPDATE Categories SET Length = Length + 1 WHERE Domain = Domain AND Name = Category;
	END IF;
	SET _CategoryId = (SELECT id FROM Categories WHERE Domain = Domain AND Name = Category);
	
	-- 3. For each input, create new or update "InputPerCategory"
	-- ------------------------------------
	SET i = 0; WHILE i != JSON_LENGTH(Inputs) DO
		-- 3.1 Extract current "input"
		-- ------------------------------------
		SET Input = JSON_VALUE(Inputs, CONCAT("$[",i,"]"));

		-- 3.2 Create new or update each "input";
		-- ------------------------------------
		IF NOT EXISTS (SELECT * FROM Inputs WHERE Domain = Domain AND Name = Input) THEN
			INSERT INTO Inputs (Domain, Name) VALUES (Domain, Input);
		ELSE
			UPDATE Inputs SET Length = Length + 1 WHERE Domain = Domain AND Name = Input;
		END IF;
		SET _InputId = (SELECT id FROM Inputs WHERE Domain = Domain AND Name = Input);		
		
		-- 3.3 Create new or update each "InputPerCategory"
		-- ------------------------------------
		IF NOT EXISTS (SELECT * FROM InputPerCategory WHERE CategoryId = _CategoryId AND InputId = _InputId) THEN
			INSERT INTO InputPerCategory (CategoryId, InputId) VALUES (_CategoryId, _InputId);
		ELSE
			UPDATE InputPerCategory SET Length = Length + 1 WHERE CategoryId = _CategoryId AND InputId = _InputId;
		END IF;						
	SET i = i + 1; END WHILE;
	
	CALL CalculateCorrelations();
	
END;
//
DELIMITER ;
