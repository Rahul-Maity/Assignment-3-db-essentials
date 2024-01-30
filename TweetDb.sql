create database TwitterDb;
use TwitterDb;

-- This SQL code creates a table named 'tbl_user' to store user information.

CREATE TABLE tbl_user(
    -- 'user_id' is the primary key, ensuring each user has a unique identifier.
    user_id INT PRIMARY KEY,

    -- 'name' field stores the name of the user, with a maximum length of 255 characters.
    name VARCHAR(255),

    -- 'email' field stores the email address of the user, with a maximum length of 255 characters.
    email VARCHAR(255),

    -- 'phone_number' field stores the phone number of the user, with a maximum length of 15 characters.
    phone_number VARCHAR(15),

    -- 'timestamp' field stores the date and time when the user record was created.
    timestamp DATETIME
);


-- Table 'tbl_tweet' for storing tweet information, including user interactions.

CREATE TABLE tbl_tweet (
    tweet_id INT PRIMARY KEY,             -- Unique identifier for each tweet.
    comment_id INT,                       -- Identifier for comments on a tweet,in case of a simple tweet this will be NULL.
    user_id INT,                          -- User identifier for the tweet author.
    content TEXT,                         -- Main content of the tweet.
    commented_content TEXT,               -- Content when a tweet is commented on.
    parent_tweet_id INT,                  -- Identifier for the parent tweet (if it's a reply).
    timestamp DATETIME,                   -- Timestamp of tweet creation.

    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id),          -- Foreign key referencing the user table.
    FOREIGN KEY (parent_tweet_id) REFERENCES tbl_tweet(tweet_id)  -- Foreign key referencing the parent tweet.
);

-- Table 'tbl_retweet' for tracking retweets and their associated information.

CREATE TABLE tbl_retweet (
    retweet_id INT PRIMARY KEY,             -- Unique identifier for each retweet.
    original_tweet_id INT,                 -- Identifier for the original tweet being retweeted.
    user_id INT,                           -- User identifier for the retweeting user.
    timestamp DATETIME,                    -- Timestamp of the retweet.

    FOREIGN KEY (original_tweet_id) REFERENCES tbl_tweet(tweet_id),  -- Foreign key referencing the original tweet.
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id)              -- Foreign key referencing the user table.
);

-- Table 'tbl_like' to track user likes on tweets and retweets.

CREATE TABLE tbl_like (
    like_id INT PRIMARY KEY,       -- Unique identifier for each like.
    tweet_id INT,                 -- Identifier for the liked tweet.
    retweet_id INT,               -- Identifier for the liked retweet.
    user_id INT,                  -- User identifier for the liking user.

    FOREIGN KEY (tweet_id) REFERENCES tbl_tweet(tweet_id),       -- Foreign key referencing the tweet being liked.
    FOREIGN KEY (retweet_id) REFERENCES tbl_retweet(retweet_id),  -- Foreign key referencing the retweet being liked.
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id)            -- Foreign key referencing the user who liked.
);

-- Table 'tbl_follow' to establish relationships between followers and followed users.
CREATE TABLE tbl_follow (
    follow_id INT PRIMARY KEY,           -- Unique identifier for each follow relationship.
    follower_user_id INT,               -- User identifier for the follower.
    followed_user_id INT,               -- User identifier for the followed user.

    FOREIGN KEY (follower_user_id) REFERENCES tbl_user(user_id),    -- Foreign key referencing the follower user.
    FOREIGN KEY (followed_user_id) REFERENCES tbl_user(user_id)     -- Foreign key referencing the followed user.
);


-- Insert user data into 'tbl_user'
INSERT INTO tbl_user (user_id, name, email, phone_number, timestamp)
VALUES
    (1, 'Rahul', 'rahul@example.com', '111-222-3333', '2024-01-28 12:00:00'),   -- User 1
    (2, 'Arindam', 'arindam@example.com', '444-555-6666', '2024-01-28 12:15:00'), -- User 2
    (3, 'Rohandip', 'rohandip@example.com', '777-888-9999', '2024-01-28 12:30:00'),-- User 3
    (4, 'Sourav', 'sourav@example.com', '123-456-7890', '2024-01-28 12:45:00');   -- User 4
    
-- Insert original tweets into 'tbl_tweet'
INSERT INTO tbl_tweet (tweet_id, comment_id, user_id, content, parent_tweet_id, commented_content, timestamp)
VALUES
    (1, NULL, 1, 'This is the first tweet by User 1', NULL, NULL, '2024-01-28 12:00:00'),  -- Tweet 1
    (2, NULL, 2, 'Hello Twitter! User 2 here.', NULL, NULL, '2024-01-28 12:15:00'),       -- Tweet 2
    (3, NULL, 3, 'Tweet from User 3. Exciting times!', NULL, NULL, '2024-01-28 12:30:00'),-- Tweet 3
    (4, NULL, 4, 'Another original tweet by User 4', NULL, NULL, '2024-01-28 12:45:00'),  -- Tweet 4
    (5, 1, 2, NULL, 1, 'Replying to User 1\'s tweet. Cool!', '2024-01-28 13:00:00'),      -- Reply to Tweet 1
    (6, 2, 3, NULL, 2, 'Replying to User 2\'s tweet. Hey there!', '2024-01-28 13:15:00'), -- Reply to Tweet 2
    (7, 5, 4, NULL, 1, 'Replying to User 1\'s tweet. Interesting!', '2024-01-28 13:30:00'), -- Reply to Reply 1
    (8, 6, 1, NULL, 2, 'Replying to User 2\'s tweet. Nice!', '2024-01-28 13:45:00');     -- Reply to Reply 2

INSERT INTO tbl_retweet (retweet_id, original_tweet_id, user_id, timestamp)
VALUES
    (1, 1, 3, '2024-01-28 15:00:00'),    -- User 3 retweets Tweet 1
    (2, 2, 4, '2024-01-28 15:30:00');   -- User 4 retweets Tweet 2
    
-- Inserting records into Likes table
INSERT INTO tbl_like (like_id, tweet_id, retweet_id, user_id)
VALUES
    (1, 1, NULL, 2),    -- User 2 likes Tweet 1
    (2, NULL, 1, 3),    -- User 3 likes Retweet 1
    (3, 2, NULL, 1),    -- User 1 likes Tweet 2
    (4, 3, NULL, 4);    -- User 4 likes Tweet 3
    
-- Follow table 
INSERT INTO tbl_follow (follow_id, follower_user_id, followed_user_id)
VALUES
    (1, 1, 2),    -- User 1 follows User 2
    (2, 2, 3),    -- User 2 follows User 3
    (3, 3, 4);    -- User 3 follows User 4


-- Fetch all users name from database.
SELECT name FROM tbl_user;

-- Fetch all tweets of user by user id most recent tweets first.
-- Approach:
-- This SQL query retrieves tweets of a specific user (User ID = 2) from the 'tbl_tweet' table.
-- It selects the tweet content, commented content (if any), and timestamp.
-- The WHERE clause filters tweets based on the specified user ID.
-- The ORDER BY clause arranges the results by timestamp in descending order, displaying the most recent tweets first.

SELECT content as tweet,commented_content as comment_tweet,timestamp
FROM tbl_tweet
WHERE user_id =2
ORDER BY timestamp DESC;


-- Fetch like count of particular tweet by tweet id.
-- Approach:
-- This SQL query retrieves the like count for a particular tweet (Tweet ID = 1) from the 'tbl_like' table.
-- It uses the COUNT(*) function to count the number of rows that satisfy the condition.
-- The WHERE clause filters the rows based on the specified tweet ID.
-- The result is a single value representing the total number of likes for the given tweet.

SELECT COUNT(*) AS like_count
FROM tbl_like
WHERE tweet_id = 1; 


-- Fetch retweet count of particular tweet by tweet id.
-- Approach: 
-- This SQL query calculates the retweet count for a specific tweet (Original Tweet ID = 1) from the 'tbl_retweet' table.
-- It utilizes the COUNT(*) function to count the number of rows where the original_tweet_id matches the specified tweet ID.
-- The WHERE clause filters the rows based on the original tweet ID.
-- The result is a single value representing the total number of retweets for the given tweet.

SELECT COUNT(*) AS retweet_count
FROM tbl_retweet
WHERE original_tweet_id = 1; 


-- Fetch comment count of particular tweet by tweet id.
-- Approach:
-- This SQL query determines the comment count for a particular tweet (Parent Tweet ID = 1) from the 'tbl_tweet' table.
-- It utilizes the COUNT(*) function to count the number of rows where the parent_tweet_id matches the specified tweet ID.
-- The WHERE clause filters the rows based on the parent tweet ID.
-- The result is a single value representing the total number of comments for the given tweet.

SELECT COUNT(*) AS comment_count
FROM tbl_tweet
WHERE parent_tweet_id = 1; 

-- Fetch all user’s name who have retweeted particular tweet by tweet id.
-- Approach:
-- This SQL query retrieves the names of users who have retweeted a particular tweet (Original Tweet ID = 1).
-- It uses a JOIN operation between the 'tbl_user' and 'tbl_retweet' tables based on the user_id.
-- The SELECT statement extracts the 'name' column from the 'tbl_user' table.
-- The JOIN condition ensures that the user_id in 'tbl_user' matches the user_id in 'tbl_retweet'.
-- The WHERE clause filters the rows based on the original tweet ID in 'tbl_retweet'.
-- The result is a list of user names who have retweeted the specified tweet.

SELECT U.name
FROM tbl_user U
JOIN tbl_retweet R ON U.user_id = R.user_id
WHERE R.original_tweet_id = 1; 


-- Fetch all commented tweet’s content for particular tweet by tweet id. ( can use group by for eliminate duplicasy )
-- Approach:
-- This SQL query retrieves the content of all comments on a particular tweet (Tweet ID = 2).
-- It uses a JOIN operation between the 'tbl_tweet' table (aliased as T) and itself (aliased as C),
-- linking the original tweet to its comments using tweet_id and parent_tweet_id.
-- The SELECT statement extracts the 'content' column from the 'tbl_tweet' table.
-- The WHERE clause filters rows to select comments related to the specified tweet ID (T.tweet_id = 2).
-- The result is a list of commented tweet contents.

SELECT T.content
FROM tbl_tweet T
JOIN tbl_tweet C ON T.tweet_id = C.parent_tweet_id
WHERE T.tweet_id = 2; 

-- Fetch user’s timeline (All tweets from users whom I am following with tweet content and user name who has tweeted it)
-- Approach:
-- This SQL query retrieves a user's timeline, including tweets from users they are following.
-- It involves three tables: 'tbl_tweet' (T), 'tbl_user' (U), and 'tbl_follow' (F).
-- The SELECT statement extracts tweet information, user name, and timestamp.
-- The INNER JOIN operations connect tweets to their respective users and ensure they are followed by the user (User ID = 1).
-- The WHERE clause filters rows based on the follower_user_id in 'tbl_follow'.
-- The ORDER BY clause arranges the results by timestamp in descending order.
-- The result is a user's timeline with tweet content, commented tweet content, user names, and timestamps.

SELECT 
    T.tweet_id,
    T.content AS tweet_content,
    T.commented_content AS comment_tweet_content,
    U.name AS user_name,
    T.timestamp
FROM 
    tbl_tweet AS T
INNER JOIN 
    tbl_user AS U ON T.user_id = U.user_id
INNER JOIN 
    tbl_follow AS F ON U.user_id = F.followed_user_id
WHERE 
    F.follower_user_id =1
ORDER BY 
    T.timestamp DESC;
