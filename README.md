# MLClassifier (SQL)

**Description:** A purely SQL machine learning system. Designed to handle OCR(ed) business documents (invoices, contracts, ...) under supervised conditions.

*Tested on MariaDB 10.5.4.*

- The system assumes that you have your own way of converting a document (e.g. PDF) into a list of unique (relevant) words.

## Requirements

Running Ubuntu or Debian like Linux run:
`sudo apt install mariadb-server mariadb-client`

## Instalation

Run make install to deploy the schema into your MySQL/MariaDB server. The script will ask you for the name of the database.
`make install`

## Usage

### Learn 
1. Train the algorithm by associating words that appear in documents (e.g. invoices) with a provided category (e.g. company name)
  - `Learn(d,c,w)` stored procedure will "associate" a list of words with the known human-classified category. Expects: 
  - 1. *domain* - generic name of the type of documents being handled (e.g. invoices, salaryReceipts, etc...)
  - 2. *category* - name of the human-verified classified category of this document
  - 3. *words* - a JSON array with a list of (relevant) words contained in this document. Relevant words make the algorithm more effective.
  - examples:
  - `CALL Learn('Invoices', 'CocaCola', '["Drink", "Invoice","September"]');`
  - `CALL Learn('Invoices', 'Dell', '["Computer","September"]');`
  - `CALL Learn('Invoices', 'McDonalds', '["Hamburger", "Invoice"]');`
  
### Predict
1. Ask the algorithm to predict a given document's (e.g. invoice) category (e.g. issue company) based on a list of words present in the document
  - `Predict(d,w)` returns a table with the probability of a document belonging to each known category. Expects:
  - 1. *domain* - generic name of the type of documents being handled (e.g. invoices, salaryReceipts, etc...)
  - 2. *words* - a JSON array with a list of (relevant) words contained in this document. Relevant words make the algorithm more effective.
  - example:
  - `CALL Predict('Invoices', '["Drink", "dummy2"]');`

| Name | Correlation |
| ----------- | ----------- |
| CocaCola | 1.00 |
