CREATE TABLE Domains (
	id INT PRIMARY KEY AUTO_INCREMENT,
	Name VARCHAR(255), -- e.g. "Invoices", "SalaryReceipts"
	Length INT DEFAULT 1, -- i.e. no of learning data points for this domain

	-- AutoCalculateCorrelations:
	-- switch to either auto recalculate or not recalculate on every data insert
	-- useful to bath insert data on first upload and not being slowed down by a recalculation on every row
	AutoCalculateCorrelations INT DEFAULT 1, 
	UNIQUE (Name)
);

