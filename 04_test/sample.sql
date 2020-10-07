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
CALL Predict('Invoices', '["Drink", "Hamburger", "dummy2"]',3);
