# Hair Salon Management System

Midterm project for **Introduction to Database (TOKT11120.AI67A)**
National Economics University, Faculty of Data Science and Artificial Intelligence.

Instructor: Mr. Tran Duc Minh

Team:

| Student | Student ID |
|---|---|
| Ung Hoang Anh | 11251042 |
| Nguyen Phuc Long | 11254989 |
| Nguyen Doan Hoang Linh | 11254505 |

## Overview

A relational database in MySQL for a hair salon. It manages service teams,
stylists, customers, appointments, service records and payments (six tables),
with ten SQL queries and three views for reporting.

## Repository contents

| File | Description |
|---|---|
| `schema.sql` | Creates database `salon_mini`, tables, keys, indexes and constraints |
| `seed.sql` | Inserts sample data and runs data-integrity validation queries |
| `queries.sql` | Ten required queries |
| `views.sql` | Views `v_detail`, `v_group_summary`, `v_debt` |
| `SQL_Project.pdf` | Final project report |

## Requirements

- MySQL **8.0.16 or later** (earlier versions parse `CHECK` constraints but do not enforce them)
- InnoDB storage engine, `utf8mb4` character set

## How to run

Run the files **in this order** on MySQL:

```bash
mysql -u <user> -p < schema.sql
mysql -u <user> -p < seed.sql
mysql -u <user> -p < queries.sql
mysql -u <user> -p < views.sql
```

Or, inside the `mysql` client:

```sql
SOURCE schema.sql;
SOURCE seed.sql;
SOURCE queries.sql;
SOURCE views.sql;
```

> **Warning:** `schema.sql` begins with `DROP DATABASE IF EXISTS salon_mini;`.
> Running it deletes any existing database with that name.

`seed.sql` ends with validation queries: every error count should be `0`
and every scenario check should return `Đạt`.
