CREATE TABLE Categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
	Domain VARCHAR(255),
	Name VARCHAR(255), -- e.g. "CocaCola", "Dell", "McDonalds"
	Length INT DEFAULT 1,
	FOREIGN KEY (Domain) REFERENCES Domains(Name) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (Domain, Name)
);

