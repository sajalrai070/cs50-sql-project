-- Find all companies
SELECT name FROM companies;

-- Find all users
SELECT username FROM users;



-- Find all transactions given user's username
SELECT *
FROM transactions
WHERE user_id = (
    SELECT user_id
    FROM users
    WHERE username = 'sankalp'
);

-- Find all daily prices for a company given its ticker
SELECT *
FROM daily_prices
WHERE company_id = (
    SELECT company_id
    FROM companies
    WHERE ticker = 'JPM'
);

-- Find all companies in a given sector name
SELECT *
FROM companies
WHERE sector_id = (
    SELECT sector_id
    FROM sectors
    WHERE sector_name = 'Financial'
);




-- Find all daily prices for a company ordered by latest date
SELECT *
FROM daily_prices
ORDER BY date DESC;

-- Find all BUY transactions
SELECT *
FROM transactions
WHERE type = 'BUY';




-- Find all companies along with their sector names
SELECT companies.name, sectors.sector_name
FROM companies
JOIN sectors ON companies.sector_id = sectors.sector_id;

-- Find all transactions with username and company ticker
SELECT transactions.transaction_id, users.username, companies.ticker
FROM transactions
JOIN users ON transactions.user_id = users.user_id
JOIN companies ON transactions.company_id = companies.company_id;

-- Find all portfolio holdings with company name
SELECT portfolios.shares_held, companies.name
FROM portfolios
JOIN companies ON portfolios.company_id = companies.company_id;





-- Find total shares held by each user for each company
SELECT users.username, companies.name, SUM(shares_held)
FROM portfolios
JOIN users ON portfolios.user_id = users.user_id
JOIN companies ON portfolios.company_id = companies.company_id
GROUP BY users.username, companies.name;

-- Find total number of transactions per user
SELECT users.username, COUNT(transaction_id)
FROM transactions
JOIN users ON users.user_id = transactions.user_id
GROUP BY users.username;






-- Find total portfolio value for a user
SELECT users.username, SUM(portfolios.shares_held * daily_prices.close) AS total_value
FROM portfolios
JOIN users ON portfolios.user_id = users.user_id
JOIN daily_prices ON portfolios.company_id = daily_prices.company_id
WHERE users.username = 'sankalp'
GROUP BY users.username;

-- Find top 5 most traded companies (by number of transactions)
SELECT companies.name, COUNT(*) AS total_trades
FROM transactions
JOIN companies ON transactions.company_id = companies.company_id
GROUP BY companies.name
ORDER BY total_trades DESC
LIMIT 5;






-- Add a new user
INSERT INTO users (user_id, username, email)
VALUES (2, 'abhijeet123', 'abhijeet123@gmail.com');

-- Add a new transaction (BUY or SELL)
INSERT INTO transactions (transaction_id, user_id, company_id, transaction_date, shares, price, type)
VALUES (2, 2, 9, '2026-03-30', 10, 500, 'BUY');

-- Update a user's email given username
UPDATE users
SET email = 'abhijeet123@gmail.com'
WHERE username = 'abhijeet123';

-- Delete a transaction given transaction_id
DELETE FROM transactions
WHERE transaction_id = 2;
