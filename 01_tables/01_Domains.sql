CREATE TABLE Domains (
	Name VARCHAR(255), -- e.g. "Invoices", "SalaryReceipts"
	Length INT DEFAULT 1, -- i.e. no of learning data points for this domain
	PRIMARY KEY (Name)
);

