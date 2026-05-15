# Design Document

By Sankalp Pandey

Video overview: (https://drive.google.com/file/d/1F_f_348UEGfDzvIzwc40juf8K2LjMzBs/view?usp=sharing)

## Scope

The purpose of this database is to support a "quantitative analysis system for stock market tracking and portfolio management". It enables users to store stock data, track transactions, and calculate portfolio performance over time.

* Users, including their usernames and email addresses
* Companies, including ticker symbols, company names, and their associated sectors
* Sectors, representing industry classifications such as finance, technology, etc.
* Daily stock prices, including open, high, low, close, and trading volume
* Portfolios, representing the number of shares held by users in different companies
* Transactions, including buy and sell operations performed by users

These entities allow the system to track investments, analyze stock performance, and compute portfolio values.

Outside the scope of this database are:

* Real-time stock price updates or API integrations
* Advanced financial modeling such as risk analysis or prediction models
* User authentication, security, or password management systems
* Multi-user collaboration or shared portfolios
* Support for derivatives, options, or other complex financial instruments

The database focuses on core portfolio tracking and analysis rather than full-scale trading or financial services.

## Functional Requirements

This database supports the following functionality:

* Users can be created, updated, and deleted
* Companies and sectors can be added and queried
* Daily stock price data can be stored and retrieved
* Users can perform buy and sell transactions
* Users can track their portfolio holdings
* The system can calculate portfolio value using stock prices
* Queries allow users to analyze trading activity and stock performance

This database does not support:

* Automated trading or algorithmic execution
* Real time data streaming
* Portfolio optimization strategies
* Visualization or frontend interaction
## Representation

Entities in this database are represented using SQLite tables, where each table corresponds to a real world concept in the stock market and portfolio system. These tables are designed to store structured data and maintain relationships between different components of the system.

## Entities

The database includes the following entities:

## sectors
## The sectors table includes:

* sector_id, which is a unique identifier for each sector as an 'INTEGER', serving as the 'PRIMARY KEY'
* sector_name, stored as 'TEXT', representing the name of the sector

## Companies

## The companies table includes:

* company_id, an 'INTEGER' serving as the 'PRIMARY KEY'
* ticker, stored as 'TEXT' with a UNIQUE constraint to ensure no duplicate stock symbols
* name, stored as 'TEXT' representing the company name
* sector_id, an 'INTEGER' referencing the sectors table

## Daily Prices

## The daily_prices table includes:

* price_id, an 'INTEGER' serving as the 'PRIMARY KEY'
* company_id, an 'INTEGER' referencing the companies table
* date, stored as 'TEXT', representing the trading date
* open, high, low, close, stored as REAL for price values
* volume, stored as 'INTEGER'
* adj_close, stored as REAL

## Users

## The users table includes:

* user_id, an 'INTEGER' serving as the 'PRIMARY KEY'
* username, stored as 'TEXT' with a 'UNIQUE' constraint
* email, stored as 'TEXT' with a 'UNIQUE' constraint

## Portfolios

## The portfolios table includes:

* portfolio_id, an 'INTEGER' serving as the 'PRIMARY KEY'
* user_id, referencing the users table
* company_id, referencing the companies table
* shares_held, stored as 'INTEGER' with a 'CHECK' constraint ensuring non negative values

## Transactions

## The transactions table includes:

* transaction_id, an 'INTEGER' serving as the 'PRIMARY KEY'
* user_id, referencing the users table
* company_id, referencing the companies table
* transaction_date, stored as 'TEXT'
* shares, stored as 'INTEGER' with a 'CHECK' constraint ensuring positive values
* price, stored as 'REAL' with a constraint ensuring non negative values
* type, stored as 'TEXT' with a 'CHECK' constraint limiting values to 'BUY' or 'SELL'
* Design Choices
* 'INTEGER' is used for 'IDs' for efficient indexing and relationships
* 'TEXT'is used for names and dates due to SQLite flexibility
* 'REAL' is used for price related values to support decimals
* Constraints such as 'UNIQUE' and 'CHECK' ensure data integrity

### Relationships

The relationships between entities are as follows:

* A sector can have many companies, but each company belongs to one sector (one-to-many)
* A company can have many daily price records, but each record belongs to one company (one-to-many)
* A user can have many portfolio entries, but each portfolio entry belongs to one user (one-to-many)
* A company can appear in many portfolios (many-to-one relationship from portfolios)
* A user can perform many transactions, but each transaction belongs to one user (one-to-many)
* A company can be involved in many transactions (one-to-many)

An entity relationship diagram (ERD) visually represents these connections.

## Optimizations

To improve query performance, several indexes were created:

* An index on companies(sector_id) to speed up filtering companies by sector
* An index on daily_prices(company_id) to optimize price lookups
* A composite index on daily_prices(company_id, date) to efficiently retrieve latest prices
* An index on users(username) to speed up user lookup

Additionally, a VIEW (portfolio_summary) was created to simplify complex queries involving portfolio value calculations. This view combines multiple tables and computes total value using the latest stock prices, reducing query complexity and improving readability.

## Limitations

This database has several limitations:

* It does not enforce real-time stock price updates
* Historical portfolio value tracking is limited without storing snapshots
* It assumes all transactions are valid and does not handle errors such as insufficient shares
* It does not support multiple currencies or global markets
* It lacks support for advanced financial instruments such as options or futures
* It does not include authentication or user security mechanisms

Future improvements could include real time data integration, portfolio performance analytics, and machine learning-based predictions.
