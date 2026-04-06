# Spendora

Spendora is a finance companion app built using Flutter, helping you track your spending patterns through clear insights and goal-driven financial habits.

---

## Overview

Spendora is designed to simplify personal finance management. It helps you understand your money, control your spending, and stay consistent with your financial goals through a clean and intuitive experience.

---

## Features

### Home Dashboard

Get a quick overview of your financial health:

* Current balance
* Total income
* Total expenses
* Savings progress indicator
* Spending visualization chart
* Top spending categories
* Recent transactions

---

### Transaction Tracking

Manage your transactions efficiently:

* Add, update, and delete transactions
* Dedicated transaction history page
* Search and filter by:

  * Transaction type
  * Category
  * Notes

---

### Goals and Challenges

Stay disciplined with structured financial goals:

* Monthly savings goals
* Expense limit tracking
* No-spend day challenges
* Progress tracking over time

---

### Insights Screen

Understand your financial behavior with deeper analytics:

* Highest spending category
* Weekly comparison (this week vs last week)
* Monthly trends
* Spending by category
* Frequent transaction types

---

## Tech Stack

* Flutter – Cross-platform UI development
* Riverpod – State management with proper handling of loading, empty, and error states
* Drift (SQLite) – Local database for offline-first functionality
* GoRouter – Centralized and scalable navigation

---

## Architecture

The app follows a clean and scalable structure:

```text
Screens → Riverpod Controllers → Data Layer
```

* Clear separation of concerns
* Improved maintainability and scalability
* Better code readability and reusability

---

## UI and UX

* Clean and minimal interface
* Easily customizable theme and color scheme
* Designed for clarity and ease of use

---

## Dark Mode

* Fully supported dark mode
* User preference persisted using SharedPreferences

---

## Multi-Currency Support

* Users select a default currency during onboarding
* Data is stored consistently in the selected currency
* Transactions can be added in other currencies with conversion
* Exchange rates are fetched in real time from an API

---

## Offline Support

* Fully functional offline (except currency conversion)
* Ensures uninterrupted usage

---

## Setup

### Environment Variables

Create a `.env` file in the root of the project and add the following:

```env
EXCHANGE_RATE_API_KEY=fa16138efcb3c10adcb17718
```

---

## Installation

```bash
git clone https://github.com/sowban-mohd/spendora.git
cd spendora
flutter pub get
flutter run
```

---

## License

This project is licensed under the MIT License.

##
