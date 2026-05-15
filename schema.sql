CREATE TABLE sectors (
    sector_id   INTEGER,
    sector_name TEXT NOT NULL,
    PRIMARY KEY("sector_id")
);

CREATE TABLE companies (
    company_id  INTEGER,
    ticker      TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    sector_id   INTEGER NOT NULL,
    PRIMARY KEY("company_id"),
    FOREIGN KEY ("sector_id") REFERENCES "sectors"("sector_id")
);

CREATE TABLE daily_prices (
    price_id    INTEGER,
    company_id  INTEGER NOT NULL,
    date        TEXT,
    open        REAL,
    high        REAL,
    low         REAL,
    close       REAL,
    volume      INTEGER,
    adj_close   REAL,
    PRIMARY KEY ("price_id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("company_id")
);

CREATE TABLE users (
    user_id   INTEGER,
    username  TEXT NOT NULL UNIQUE,
    email     TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("user_id")
);

CREATE TABLE portfolios (
    portfolio_id INTEGER,
    user_id      INTEGER NOT NULL,
    company_id   INTEGER NOT NULL,
    shares_held  INTEGER NOT NULL CHECK(shares_held >= 0),
    PRIMARY KEY ("portfolio_id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("user_id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("company_id")
);

CREATE TABLE transactions (
    transaction_id   INTEGER,
    user_id          INTEGER NOT NULL,
    company_id       INTEGER NOT NULL,
    transaction_date TEXT,
    shares           INTEGER CHECK(shares > 0),
    price            REAL NOT NULL CHECK(price >= 0),
    type             TEXT CHECK(type IN ('BUY','SELL')),
    PRIMARY KEY ("transaction_id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("user_id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("company_id")
);

CREATE INDEX idx_companies_sector ON companies(sector_id);
CREATE INDEX idx_prices_company ON daily_prices(company_id);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_prices_company_date ON daily_prices(company_id, date);


-- View to calculate total portfolio value for each user using latest stock prices
CREATE VIEW portfolio_summary AS
SELECT
    users.username,
    companies.ticker,
    portfolios.shares_held,
    daily_prices.close AS latest_price,
    (portfolios.shares_held * daily_prices.close) AS total_value
    FROM portfolios
    JOIN users ON portfolios.user_id = users.user_id
    JOIN companies ON portfolios.company_id = companies.company_id
    JOIN daily_prices
    ON portfolios.company_id = daily_prices.company_id
    WHERE daily_prices.date = (
    SELECT MAX(date)
    FROM daily_prices
    WHERE company_id = daily_prices.company_id
);
