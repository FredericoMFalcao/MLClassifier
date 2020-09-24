CREATE TABLE ClassifiedDocs (
	id INT PRIMARY KEY AUTO_INCREMENT,
	Domain VARCHAR(255) NOT NULL,
	Classification VARCHAR(255) NOT NULL,
	Words TEXT NOT NULL,
	FOREIGN KEY (Domain) REFERENCES Domains(Name)
);

CREATE TRIGGER TeachMLAlgo AFTER INSERT ON ClassifiedDocs
 FOR EACH ROW CALL Learn(NEW.Domain, New.Classification, NEW.Words);
