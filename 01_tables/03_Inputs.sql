CREATE TABLE Inputs (
	id INT PRIMARY KEY AUTO_INCREMENT,
	DomainId INT,
	Name VARCHAR(255) NOT NULL, -- e.g. "Drink", "Computer", "Hamburger"
	Length INT DEFAULT 1,
	LengthOfDifferentCategories INT DEFAULT 1,
	FOREIGN KEY (DomainId) REFERENCES Domains(id) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (DomainId, Name),
	INDEX USING HASH (Name)
);

