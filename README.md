# 🎮 Gaming Analytics Project

## 📌 Overview

The **Gaming Analytics Project** is designed to analyze player behavior, engagement, and revenue across multiple games. By leveraging SQL queries, this project extracts **key performance indicators (KPIs)** to generate **business-driven insights** for improving player retention, monetization strategies, and user experience. The dataset includes user sessions, in-game purchases, feedback, and social interactions.

This project follows a structured approach:

- **Data Modeling:** Setting up an optimized database schema.
- **KPIs Implementation:** Defining metrics for player engagement, revenue, and retention.
- **Data Analysis & Business Insights:** Extracting actionable insights for growth strategies.

---

## 🚀 Key Performance Indicators (KPIs)

### 🎯 **1. Game Popularity by Player Count**

**Objective:** Identify which games attract the most unique players.

```sql
SELECT *, RANK() OVER (ORDER BY NoOfPlayers DESC) 'Rank'
FROM (
    SELECT GameID, GameName, COUNT(DISTINCT UserID) 'NoOfPlayers'
    FROM #quickaccess
    GROUP BY GameID, GameName
) t1;
```

✅ **Good:** Counts unique players per game and ranks games by popularity.  
⚡ **Improvement:** Filter by active users in the last 30 days to avoid bias from inactive players.

---

### 🌍 **2. Top Gaming Countries by Player Count**

**Objective:** Identify regions with the highest player base.

```sql
SELECT *, RANK() OVER (ORDER BY NoOfPlayers DESC) 'Rank'
FROM (
    SELECT Country, COUNT(DISTINCT UserID) 'NoOfPlayers'
    FROM #quickaccess
    GROUP BY Country
) t1;
```

✅ **Good:** Highlights top-performing markets.  
⚡ **Improvement:** Track **retention by country** to measure long-term engagement.

---

### 👶 **3. Average Player Age by Game**

**Objective:** Understand the demographics of each game’s player base.

```sql
SELECT GameID, GameName, AVG(Age) 'Average Age'
FROM #quickaccess
GROUP BY GameID, GameName;
```

✅ **Good:** Calculates average player age per game.  
⚡ **Improvement:** Segment by **age groups** to refine marketing strategies.

---

### ⏳ **4. Total Playtime Per Player Per Game**

**Objective:** Measure total engagement time per player.

```sql
SELECT GameID, UserID, UserName,
       SUM(DATEDIFF(MINUTE, SessionStart, SessionEnd)) 'SessionDuration'
FROM #quickaccess
GROUP BY GameID, UserID, UserName;
```

✅ **Good:** Accurately tracks total playtime.  
⚡ **Improvement:** Add session count per player to monitor engagement trends.

---

### 📊 **5. Daily Active Users (DAU)**

**Objective:** Track daily player engagement across games.

```sql
SELECT GameID, GameName, DATETRUNC(DAY, SessionStart) 'Daily',
       COUNT(UserID) 'SESSIONCount',
       COUNT(DISTINCT UserID) 'USERCount'
FROM #quickaccess
GROUP BY GameID, GameName, DATETRUNC(DAY, SessionStart)
ORDER BY GameID, DATETRUNC(DAY, SessionStart);
```

✅ **Good:** Monitors DAU trends.  
⚡ **Improvement:** Add **7-day moving averages** to smooth fluctuations.

---

### 💰 **6. Total Revenue by Game**

**Objective:** Rank games based on their revenue generation.

```sql
SELECT *, DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) 'Rank'
FROM (
    SELECT g.GameID, g.GameName, SUM(Amount) 'TotalRevenue'
    FROM Purchases p
    JOIN Games g ON p.GameID = g.GameID
    GROUP BY g.GameID, g.GameName
) t1;
```

✅ **Good:** Identifies top-grossing games.  
⚡ **Improvement:** Track **revenue per item type** (e.g., cosmetics vs. upgrades).

---

### 💬 **7. Player Feedback & Game Ratings**

**Objective:** Measure player satisfaction through feedback scores.

```sql
SELECT g.GameID, g.GameName,
       AVG(f.Score) AS 'AvgScore',
       COUNT(f.FeedbackID) AS 'TotalReviews',
       RANK() OVER (ORDER BY AVG(f.Score) DESC) AS 'Rank'
FROM Feedback f
JOIN Games g ON g.GameID = f.GameID
GROUP BY g.GameID, g.GameName;
```

✅ **Good:** Ranks games by player ratings.  
⚡ **Improvement:** Include **total number of reviews** to prevent bias from low-sample feedback.

---

## 📈 Business-Driven Insights & Additional Approaches

### ✅ **Cohort Analysis (User Retention)**

Track player retention over time.

```sql
SELECT DATETRUNC(MONTH, RegistrationDate) AS CohortMonth,
       COUNT(DISTINCT UserID) AS NewUsers
FROM Users
GROUP BY DATETRUNC(MONTH, RegistrationDate)
ORDER BY CohortMonth;
```

📌 Helps in identifying new user acquisition trends.

---

### ✅ **Churn Rate Analysis (Inactive Users)**

Identify player drop-off trends.

```sql
SELECT DATETRUNC(MONTH, LastLogin) AS LastActiveMonth,
       COUNT(DISTINCT UserID) AS ActiveUsers
FROM Users
GROUP BY DATETRUNC(MONTH, LastLogin)
ORDER BY LastActiveMonth;
```

📌 Helps reduce churn by implementing targeted retention strategies.

---

### ✅ **LTV (Lifetime Value) Analysis**

Measure average revenue per user.

```sql
SELECT UserID, SUM(Amount) / COUNT(DISTINCT UserID) AS 'LTV'
FROM Purchases
GROUP BY UserID;
```

📌 Determines high-value players and optimizes monetization strategies.

---

## 🎯 Final Thoughts

This project provides deep insights into player behavior, revenue generation, and engagement trends. The structured approach allows for data-driven decision-making, making it a **valuable asset for game developers and publishers** looking to optimize user retention and monetization.

📌 **Key Learnings:**

- Identified top-performing games & regions.
- Analyzed revenue trends & purchase behaviors.
- Evaluated player satisfaction & engagement metrics.
- Suggested actionable business strategies for growth.

🚀 **Next Steps:** Turn this into a full-fledged data dashboard to provide real-time analytics for business stakeholders!
