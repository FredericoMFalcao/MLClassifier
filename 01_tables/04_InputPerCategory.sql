CREATE TABLE InputPerCategory (
	CategoryId INT,
	InputId INT,
	Length INT DEFAULT 1,
	Correlation DOUBLE DEFAULT 0.5,
	FOREIGN KEY (CategoryId) REFERENCES Categories(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (InputId) REFERENCES Inputs(id)
);

