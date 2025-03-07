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
('PlayerThree', '2023-01-25', 'playerthree@example.com', 'Canada', 22, 'Other', 'Console', '2025-03-01 18:30:00'),
('PlayerFour', '2023-01-20', 'playerfour@example.com', 'Germany', 29, 'Male', 'PC', '2025-03-01 10:00:00'),
('PlayerFive', '2023-02-05', 'playerfive@example.com', 'France', 35, 'Female', 'Mobile', '2025-03-01 16:00:00'),
('PlayerSix', '2023-02-15', 'playersix@example.com', 'Italy', 28, 'Non-binary', 'Console', '2025-03-01 20:00:00'),
('PlayerSeven', '2023-01-30', 'playerseven@example.com', 'Spain', 24, 'Male', 'PC', '2025-03-01 12:00:00'),
('PlayerEight', '2023-01-10', 'playereight@example.com', 'Brazil', 32, 'Female', 'Mobile', '2025-03-01 15:30:00'),
('PlayerNine', '2023-02-20', 'playernine@example.com', 'Australia', 27, 'Male', 'Console', '2025-03-01 19:00:00'),
('PlayerTen', '2023-02-25', 'playerten@example.com', 'India', 31, 'Female', 'PC', '2025-03-01 11:00:00'),
('PlayerEleven', '2023-01-28', 'playereleven@example.com', 'Japan', 26, 'Other', 'Mobile', '2025-03-01 14:30:00'),
('PlayerTwelve', '2023-02-12', 'playertwelve@example.com', 'Russia', 29, 'Male', 'Console', '2025-03-01 17:45:00'),
('PlayerThirteen', '2023-01-18', 'playerthirteen@example.com', 'Mexico', 23, 'Female', 'PC', '2025-03-01 09:15:00'),
('PlayerFourteen', '2023-01-22', 'playerfourteen@example.com', 'Netherlands', 34, 'Non-binary', 'Mobile', '2025-03-01 13:00:00'),
('PlayerFifteen', '2023-02-02', 'playerfifteen@example.com', 'Sweden', 30, 'Male', 'Console', '2025-03-01 18:00:00');

-- Insert sample data into Games table
INSERT INTO Games (GameName, ReleaseDate, Genre, Developer, Publisher, Platform, Rating, TotalDownloads, InGameCurrency) VALUES 
('Fortnite', '2017-07-25', 'Battle Royale', 'Epic Games', 'Epic Games', 'PC/Mobile/Console', 9.5, 250000000, 'V-Bucks'),
('Candy Crush Saga', '2012-04-12', 'Puzzle', 'King', 'Activision Blizzard', 'Mobile', 8.0, 500000000, 'Gold Bars'),
('Clash of Clans', '2012-08-02', 'Strategy', 'Supercell', 'Supercell', 'Mobile', 9.0, 250000000, 'Gems'),
('Minecraft', '2011-11-18', 'Sandbox', 'Mojang', 'Mojang', 'PC/Mobile/Console', 9.7, 200000000, 'Coins'),
('Apex Legends', '2019-02-04', 'Battle Royale', 'Respawn Entertainment', 'EA', 'PC/Console', 9.0, 100000000, 'Crafting Materials'),
('League of Legends', '2009-10-27', 'MOBA', 'Riot Games', 'Riot Games', 'PC', 9.2, 1000000000, 'Riot Points'),
('World of Warcraft', '2004-11-23', 'MMORPG', 'Blizzard Entertainment', 'Blizzard', 'PC', 9.3, 150000000, 'Gold'),
('Valorant', '2020-06-02', 'FPS', 'Riot Games', 'Riot Games', 'PC', 8.5, 150000000, 'Valorant Points'),
('The Witcher 3', '2015-05-19', 'RPG', 'CD Projekt Red', 'CD Projekt', 'PC/Console', 9.8, 30000000, 'Crowns'),
('Among Us', '2018-06-15', 'Party', 'InnerSloth', 'InnerSloth', 'PC/Mobile', 8.0, 100000000, 'Beans');

-- Insert sample data into Sessions table (multiple sessions for users)
INSERT INTO Sessions (UserID, GameID, SessionStart, SessionEnd, SessionType, LevelReached, AchievementsUnlocked) VALUES 
(1, 1, '2025-03-01 10:00:00', '2025-03-01 12:00:00', 'Multiplayer', 5, 2),
(1, 2, '2025-03-01 14:00:00', '2025-03-01 15:30:00', 'Single Player', 10, 1),
(2, 2, '2025-03-01 15:00:00', '2025-03-01 15:30:00', 'Single Player', 10, 1),
(3, 3, '2025-03-01 18:00:00', '2025-03-01 19:00:00', 'Multiplayer', 7, 3),
(4, 4, '2025-03-01 09:00:00', '2025-03-01 10:30:00', 'Single Player', 12, 4),
(5, 5, '2025-03-01 11:00:00', '2025-03-01 12:15:00', 'Multiplayer', 8, 3),
(6, 6, '2025-03-01 14:00:00', '2025-03-01 15:30:00', 'Single Player', 15, 2),
(7, 7, '2025-03-01 16:00:00', '2025-03-01 17:45:00', 'Multiplayer', 9, 5),
(8, 8, '2025-03-01 19:00:00', '2025-03-01 20:30:00', 'Single Player', 11, 2),
(9, 9, '2025-03-01 20:00:00', '2025-03-01 21:15:00', 'Multiplayer', 6, 4),
(10, 10, '2025-03-01 21:00:00', '2025-03-01 22:30:00', 'Single Player', 14, 3),
(1, 1, '2025-03-02 08:00:00', '2025-03-02 09:30:00', 'Multiplayer', 6, 2),
(2, 2, '2025-03-02 12:00:00', '2025-03-02 12:45:00', 'Single Player', 8, 1),
(3, 3, '2025-03-02 13:00:00', '2025-03-02 14:30:00', 'Multiplayer', 9, 3),
(4, 4, '2025-03-02 15:00:00', '2025-03-02 16:15:00', 'Single Player', 10, 4),
(5, 5, '2025-03-02 17:00:00', '2025-03-02 18:30:00', 'Multiplayer', 9, 2);

-- Insert sample data into Purchases table (multiple purchases for users)
INSERT INTO Purchases (UserID, GameID, PurchaseDate, Amount, ItemName, ItemType, Currency) VALUES 
(1, 1, '2025-03-01 11:00:00', 9.99, 'Epic Skins Pack', 'Cosmetic', 'USD'),
(1, 2, '2025-03-01 14:15:00', 4.99, 'Extra Lives', 'Upgrade', 'USD'),
(1, 3, '2025-03-01 18:30:00', 14.99, 'New Character', 'Character', 'USD'),
(2, 2, '2025-03-01 15:15:00', 4.99, 'Extra Lives', 'Upgrade', 'USD'),
(3, 3, '2025-03-01 19:30:00', 9.99, 'New Map Pack', 'Expansion', 'USD'),
(4, 4, '2025-03-01 10:00:00', 19.99, 'Premium Access', 'Subscription', 'USD'),
(5, 5, '2025-03-01 14:00:00', 5.99, 'Starter Pack', 'Bundle', 'USD'),
(1, 6, '2025-03-02 12:30:00', 29.99, 'Season Pass', 'Upgrade', 'USD'),
(2, 7, '2025-03-02 13:45:00', 7.99, 'Character Skins', 'Cosmetic', 'USD'),
(3, 8, '2025-03-02 14:00:00', 11.99, 'Game Currency', 'In-Game', 'USD'),
(4, 9, '2025-03-02 15:00:00', 24.99, 'Special Edition', 'Bundle', 'USD'),
(5, 10, '2025-03-02 16:30:00', 9.99, 'Epic Skins Pack', 'Cosmetic', 'USD');

-- Insert sample data into Feedback table (multiple feedback entries for users)
INSERT INTO Feedback (UserID, GameID, FeedbackDate, Score, Comments, FeatureRequested, BugReported) VALUES 
(1, 1, '2025-03-01 12:30:00', 8, 'Great game!', 'More maps', NULL),
(1, 2, '2025-03-01 14:45:00', 6, 'Fun but repetitive.', 'New game modes', 'Crashes on level 10'),
(2, 2, '2025-03-01 15:45:00', 7, 'Interesting mechanics!', 'More levels', NULL),
(3, 3, '2025-03-01 19:30:00', 9, 'Love the strategy involved!', 'More character options', NULL),
(4, 4, '2025-03-01 10:15:00', 7, 'Interesting mechanics!', 'More levels', NULL),
(5, 5, '2025-03-01 14:45:00', 5, 'Could use improvement.', 'Better graphics', 'Lag issues'),
(1, 6, '2025-03-02 12:00:00', 10, 'Best game ever!', NULL, NULL),
(2, 7, '2025-03-02 13:00:00', 8, 'Really enjoyed it!', 'More modes', NULL),
(3, 8, '2025-03-02 14:30:00', 4, 'Not my favorite.', 'More tutorials', NULL),
(4, 9, '2025-03-02 15:30:00', 7, 'Fun with friends!', NULL, NULL),
(5, 10, '2025-03-02 16:00:00', 9, 'Loved the story!', 'More character development', NULL);

-- Insert sample data into SocialEngagements table (multiple engagements for users)
INSERT INTO SocialEngagements (UserID, GameID, EngagementDate, Type, EngagementDetails, SharesCount, InvitesCount) VALUES 
(1, 1, '2025-03-01 12:15:00', 'Share', 'Shared a screenshot', 5, 2),
(1, 2, '2025-03-01 14:00:00', 'Invite', 'Invited friends to play', 1, 3),
(2, 2, '2025-03-01 15:45:00', 'Community Event', 'Participated in a tournament', 10, 1),
(3, 3, '2025-03-01 19:00:00', 'Share', 'Posted on social media', 2, 1),
(4, 4, '2025-03-01 10:30:00', 'Invite', 'Invited friends to join', 1, 4),
(5, 5, '2025-03-01 14:00:00', 'Community Event', 'Joined a live stream', 8, 2),
(1, 6, '2025-03-02 12:30:00', 'Share', 'Shared a game clip', 3, 0),
(2, 7, '2025-03-02 13:15:00', 'Invite', 'Recommended to friends', 0, 5),
(3, 8, '2025-03-02 14:45:00', 'Community Event', 'Participated in a contest', 6, 2),
(4, 9, '2025-03-02 15:45:00', 'Share', 'Shared game tips', 7, 3),
(5, 10, '2025-03-02 16:00:00', 'Invite', 'Invited friends to play', 4, 1);


print '-----------------------------------------'
print 'Values Inserted'
print '-----------------------------------------'


PRINT '-----------------------------------------';
DECLARE @val DATETIME = GETDATE();
PRINT 'End Of Script at ' + CONVERT(NVARCHAR, @val, 120);
PRINT '-----------------------------------------';