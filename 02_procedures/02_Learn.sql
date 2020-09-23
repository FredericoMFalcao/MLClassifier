-- --------------------
-- - 2. LEARNING
-- --------------------
DROP PROCEDURE IF EXISTS Learn;
DELIMITER //
CREATE PROCEDURE Learn (
	IN _Domain VARCHAR(255),
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
	IF NOT EXISTS (SELECT * FROM Domains WHERE Name = _Domain) THEN
		INSERT INTO Domains (Name) VALUES (_Domain);
	ELSE
		UPDATE Domains SET Length = Length + 1 WHERE Name = _Domain;
	END IF;
	
	-- 2. Create new or update a "category"
	-- ------------------------------------
	IF NOT EXISTS (SELECT * FROM Categories WHERE Domain = _Domain AND Name = Category) THEN
		INSERT INTO Categories (Domain, Name) VALUES (_Domain, Category);
		SET _CategoryId = LAST_INSERT_ID();
		INSERT INTO InputPerCategory (CategoryId, InputId) 
			SELECT _CategoryId, id FROM Inputs WHERE Domain = _Domain;		
	ELSE
		UPDATE Categories SET Length = Length + 1 WHERE Domain = _Domain AND Name = Category;
	END IF;
	SET _CategoryId = (SELECT id FROM Categories WHERE Domain = _Domain AND Name = Category);
	
	-- 3. For each input, create new or update "InputPerCategory"
	-- ------------------------------------
	SET i = 0; WHILE i != JSON_LENGTH(Inputs) DO
		-- 3.1 Extract current "input"
		-- ------------------------------------
		SET Input = JSON_VALUE(Inputs, CONCAT("$[",i,"]"));

		-- 3.2 Create new or update each "input";
		-- ------------------------------------
		IF NOT EXISTS (SELECT * FROM Inputs WHERE Domain = _Domain AND Name = Input) THEN
			INSERT INTO Inputs (Domain, Name) VALUES (_Domain, Input);
			SET _InputId = LAST_INSERT_ID();
			INSERT INTO InputPerCategory (CategoryId, InputId) 
				SELECT id, _InputId FROM Categories WHERE Domain = _Domain;
		ELSE
			UPDATE Inputs SET Length = Length + 1 WHERE Domain = _Domain AND Name = Input;
		END IF;
		SET _InputId = (SELECT id FROM Inputs WHERE Domain = _Domain AND Name = Input);		
		
		-- 3.3 Create new or update each "InputPerCategory"
		-- ------------------------------------
		UPDATE InputPerCategory SET Length = Length + 1 WHERE CategoryId = _CategoryId AND InputId = _InputId;

	SET i = i + 1; END WHILE;
	
	CALL CalculateCorrelations();
	
END;
//
DELIMITER ;
