CREATE TABLE Categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
	DomainId INT,
	Name VARCHAR(255), -- e.g. "CocaCola", "Dell", "McDonalds"
	Length INT DEFAULT 1,
	FOREIGN KEY (DomainId) REFERENCES Domains(id) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (Domain, Name),
	INDEX USING HASH (Name)
);

