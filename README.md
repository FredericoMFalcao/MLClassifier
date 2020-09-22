# MLClassifier (SQL)

**Description:** A purely SQL machine learning system to classify OCR(ed) documents.

*Tested on MariaDB 10.5.4.*

- The system assumes that you have your own way of converting a document (e.g. PDF) into a list of unique (relevant) words.

## Learn 
1. Train the algorithm by associating words that appear in documents (e.g. invoices) with a provided category (e.g. company name)
  - `learn` stored procedure will associate a list of JSON words with the provided category 
  - examples:
  - `CALL Learn('Invoices', 'CocaCola', '["Drink", "Invoice","September"]');`
  - `CALL Learn('Invoices', 'Dell', '["Computer","September"]');`
  - `CALL Learn('Invoices', 'McDonalds', '["Hamburger", "Invoice"]');`
  
## Predict
1. Ask the algorithm to predict a given document's (e.g. invoice) category (e.g. issue company) based on a list of words present in the document
  - `Predict` stored procedure needs a *domain* and a JSON list of words
  - it will output a table with a probability of a document being of each of the known categories
  - `CALL Predict('Invoices', '["Drink", "dummy2"]');`
  - output:

| Name | Correlation |
| ----------- | ----------- |
| CocaCola | 1.00 |
