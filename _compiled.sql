CREATE TABLE Domains (
	Name VARCHAR(255), -- e.g. "Invoices", "SalaryReceipts"
	Length INT DEFAULT 1, -- i.e. no of learning data points for this domain
	PRIMARY KEY (Name)
);

CREATE TABLE Categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
	Domain VARCHAR(255),
	Name VARCHAR(255), -- e.g. "CocaCola", "Dell", "McDonalds"
	Length INT DEFAULT 1,
	FOREIGN KEY (Domain) REFERENCES Domains(Name) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (Domain, Name)
);

CREATE TABLE Inputs (
	id INT PRIMARY KEY AUTO_INCREMENT,
	Domain VARCHAR(255),
	Name VARCHAR(255), -- e.g. "Drink", "Computer", "Hamburger"
	Length INT DEFAULT 1,
	FOREIGN KEY (Domain) REFERENCES Domains(Name) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (Domain, Name)
);

CREATE TABLE InputPerCategory (
	CategoryId INT,
	InputId INT,
	Length INT DEFAULT 1,
	Correlation DOUBLE DEFAULT 0,
	FOREIGN KEY (CategoryId) REFERENCES Categories(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (InputId) REFERENCES Inputs(id)
);

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

-- --------------------
-- - 2. LEARNING
-- --------------------
DROP PROCEDURE IF EXISTS Learn;
DELIMITER //
CREATE PROCEDURE Learn (
	IN _Domain VARCHAR(255),
	IN Category VARCHAR(255),
	IN Inputs TEXT
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
-- --------------------
-- - 3. Predicting
-- --------------------
DROP PROCEDURE IF EXISTS Predict;
DELIMITER //
CREATE PROCEDURE Predict (
	IN _Domain VARCHAR(255),
	IN _Inputs TEXT
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
-- --------------------
-- - 10. Testing
-- --------------------

-- TEST CASE:
-- Document #1: CocaCola's Invoice with keywords: "Drink"
CALL Learn('Invoices', 'CocaCola', '["Drink", "Invoice","September"]');
-- Document #2: Dell's Invoice with keywords: "Computer"
CALL Learn('Invoices', 'Dell', '["Computer","September"]');
-- Document #3: McDonalds' Invoice with keywords: "Hamburger"
CALL Learn('Invoices', 'McDonalds', '["Hamburger", "Invoice"]');

-- Document #4: CocaCola's Invoices with keywords: "Drink", "dummy1", "dummy2"
CALL Predict('Invoices', '["Drink", "Hamburger", "dummy2"]');
