-- Create the database only if it does not exist
DECLARE @val datetime = getdate()

PRINT 'Script Activated' + convert(NVARCHAR,@val)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GamingAnalytics')
BEGIN
    CREATE DATABASE GamingAnalytics;
END
GO
print '-----------------------------------------'
print 'Database set'
print '-----------------------------------------'
-- Use the database
USE GamingAnalytics;
GO

-- Drop existing tables if needed
IF OBJECT_ID('dbo.SocialEngagements', 'U') IS NOT NULL DROP TABLE SocialEngagements;
IF OBJECT_ID('dbo.Feedback', 'U') IS NOT NULL DROP TABLE Feedback;
IF OBJECT_ID('dbo.Purchases', 'U') IS NOT NULL DROP TABLE Purchases;
IF OBJECT_ID('dbo.Sessions', 'U') IS NOT NULL DROP TABLE Sessions;
IF OBJECT_ID('dbo.Games', 'U') IS NOT NULL DROP TABLE Games;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL,
    RegistrationDate DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Country NVARCHAR(50),
    Age INT CHECK (Age >= 0),
    Gender NVARCHAR(10),
    Device NVARCHAR(50),
    LastLogin DATETIME,
    TotalPlayTime INT DEFAULT 0
);
GO

-- Create Games table
CREATE TABLE Games (
    GameID INT PRIMARY KEY IDENTITY(1,1),
    GameName NVARCHAR(100) NOT NULL,
    ReleaseDate DATE NOT NULL,
    Genre NVARCHAR(50),
    Developer NVARCHAR(100),
    Publisher NVARCHAR(100),
    Platform NVARCHAR(50),
    Rating DECIMAL(3,2) CHECK (Rating BETWEEN 0 AND 10),
    TotalDownloads INT DEFAULT 0,
    InGameCurrency NVARCHAR(50)
);
GO

-- Create Sessions table
CREATE TABLE Sessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    SessionStart DATETIME NOT NULL,
    SessionEnd DATETIME NOT NULL,
    SessionLength AS DATEDIFF(MINUTE, SessionStart, SessionEnd),
    SessionType NVARCHAR(50),
    LevelReached INT,
    AchievementsUnlocked INT DEFAULT 0
);
GO

-- Create Purchases table
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    PurchaseDate DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    ItemName NVARCHAR(100),
    ItemType NVARCHAR(50),
    Currency NVARCHAR(50)
);
GO

-- Create Feedback table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    FeedbackDate DATETIME NOT NULL,
    Score INT CHECK (Score BETWEEN 1 AND 10),
    Comments NVARCHAR(255),
    FeatureRequested NVARCHAR(255),
    BugReported NVARCHAR(255)
);
GO

-- Create SocialEngagements table
CREATE TABLE SocialEngagements (
    EngagementID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    GameID INT FOREIGN KEY REFERENCES Games(GameID),
    EngagementDate DATETIME NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    EngagementDetails NVARCHAR(255),
    SharesCount INT DEFAULT 0,
    InvitesCount INT DEFAULT 0
);
GO

print '-----------------------------------------'
print 'Tables set'
print '-----------------------------------------'

-- Insert sample data into Users table
INSERT INTO Users (UserName, RegistrationDate, Email, Country, Age, Gender, Device, LastLogin) VALUES 
('PlayerOne', '2023-01-15', 'playerone@example.com', 'USA', 25, 'Male', 'PC', '2025-03-01 09:00:00'),
('PlayerTwo', '2023-02-10', 'playertwo@example.com', 'UK', 30, 'Female', 'Mobile', '2025-03-01 14:00:00'),
('PlayerThree', '2023-01-25', 'playerthree@example.com', 'Canada', 22, 'Other', 'Console', '2025-03-01 18:30:00');
GO

-- Insert sample data into Games table
INSERT INTO Games (GameName, ReleaseDate, Genre, Developer, Publisher, Platform, Rating, TotalDownloads, InGameCurrency) VALUES 
('Fortnite', '2017-07-25', 'Battle Royale', 'Epic Games', 'Epic Games', 'PC/Mobile/Console', 9.5, 250000000, 'V-Bucks'),
('Candy Crush Saga', '2012-04-12', 'Puzzle', 'King', 'Activision Blizzard', 'Mobile', 8.0, 500000000, 'Gold Bars'),
('Clash of Clans', '2012-08-02', 'Strategy', 'Supercell', 'Supercell', 'Mobile', 9.0, 250000000, 'Gems');
GO

-- Insert sample data into Sessions table (fixed column mismatch)
INSERT INTO Sessions (UserID, GameID, SessionStart, SessionEnd, SessionType, LevelReached, AchievementsUnlocked) VALUES 
(1, 1, '2025-03-01 10:00:00', '2025-03-01 12:00:00', 'Multiplayer', 5, 2),
(2, 2, '2025-03-01 15:00:00', '2025-03-01 15:30:00', 'Single Player', 10, 1),
(3, 3, '2025-03-01 18:00:00', '2025-03-01 19:00:00', 'Multiplayer', 7, 3);
GO

-- Insert sample data into Purchases table
INSERT INTO Purchases (UserID, GameID, PurchaseDate, Amount, ItemName, ItemType, Currency) VALUES 
(1, 1, '2025-03-01 11:00:00', 9.99, 'Epic Skins Pack', 'Cosmetic', 'USD'),
(2, 2, '2025-03-01 15:15:00', 4.99, 'Extra Lives', 'Upgrade', 'USD'),
(3, 3, '2025-03-01 18:30:00', 14.99, 'New Character', 'Character', 'USD');
GO

-- Insert sample data into Feedback table
INSERT INTO Feedback (UserID, GameID, FeedbackDate, Score, Comments, FeatureRequested, BugReported) VALUES 
(1, 1, '2025-03-01 12:30:00', 8, 'Great game!', 'More maps', NULL),
(2, 2, '2025-03-01 15:45:00', 6, 'Fun but repetitive.', 'New game modes', 'Crashes on level 10'),
(3, 3, '2025-03-01 19:30:00', 9, 'Love the strategy involved!', 'More character options', NULL);
GO

-- Insert sample data into SocialEngagements table
INSERT INTO SocialEngagements (UserID, GameID, EngagementDate, Type, EngagementDetails, SharesCount, InvitesCount) VALUES 
(1, 1, '2025-03-01 12:15:00', 'Share', 'Shared a screenshot', 5, 2),
(2, 2, '2025-03-01 15:45:00', 'Invite', 'Invited friends to play', 0, 3),
(3, 3, '2025-03-01 19:00:00', 'Community Event', 'Participated in a tournament', 10, 1);
GO
print '-----------------------------------------'
print 'Values Inserted'
print '-----------------------------------------'


PRINT '-----------------------------------------';
DECLARE @val DATETIME = GETDATE();
PRINT 'End Of Script at ' + CONVERT(NVARCHAR, @val, 120);
PRINT '-----------------------------------------';