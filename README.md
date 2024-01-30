# Twitter Database Management System

This repository contains a solution for a Twitter-like Database Management System using SQL. The system includes tables for users, tweets, retweets, likes, and follows. Additionally, it provides sample data and queries for various operations on the database.

## Database Schema

### `tbl_user`

- `user_id` (Primary Key): Unique identifier for each user.
- `name`: Name of the user.
- `email`: Email address of the user.
- `phone_number`: Phone number of the user.
- `timestamp`: Date and time when the user record was created.

### `tbl_tweet`

- `tweet_id` (Primary Key): Unique identifier for each tweet.
- `comment_id`: Identifier for comments on a tweet (NULL for simple tweets).
- `user_id` (Foreign Key): User identifier for the tweet author.
- `content`: Main content of the tweet.
- `commented_content`: Content when a tweet is commented on.
- `parent_tweet_id` (Foreign Key): Identifier for the parent tweet (if it's a reply).
- `timestamp`: Timestamp of tweet creation.

### `tbl_retweet`

- `retweet_id` (Primary Key): Unique identifier for each retweet.
- `original_tweet_id` (Foreign Key): Identifier for the original tweet being retweeted.
- `user_id` (Foreign Key): User identifier for the retweeting user.
- `timestamp`: Timestamp of the retweet.

### `tbl_like`

- `like_id` (Primary Key): Unique identifier for each like.
- `tweet_id` (Foreign Key): Identifier for the liked tweet.
- `retweet_id` (Foreign Key): Identifier for the liked retweet.
- `user_id` (Foreign Key): User identifier for the liking user.

### `tbl_follow`

- `follow_id` (Primary Key): Unique identifier for each follow relationship.
- `follower_user_id` (Foreign Key): User identifier for the follower.
- `followed_user_id` (Foreign Key): User identifier for the followed user.

## Sample Data

The system includes sample data for users, tweets, retweets, likes, and follows. The sample data can be found in the [SQL script](twitter_db.sql).

## Queries

### Fetch all users' names
```sql
SELECT name FROM tbl_user;
```
###  Fetch all tweets of user by user id most recent tweets first.
```sql
SELECT content as tweet,commented_content as comment_tweet,timestamp
FROM tbl_tweet
WHERE user_id =2
ORDER BY timestamp DESC;
``` 
###  Fetch like count of particular tweet by tweet id.
```sql
SELECT COUNT(*) AS like_count
FROM tbl_like
WHERE tweet_id = 1; 
``` 
###  Fetch retweet count of particular tweet by tweet id.   
```sql
SELECT COUNT(*) AS retweet_count
FROM tbl_retweet
WHERE original_tweet_id = 1; 
``` 
###  Fetch comment count of particular tweet by tweet id.  
```sql
SELECT COUNT(*) AS comment_count
FROM tbl_tweet
WHERE parent_tweet_id = 1; 
``` 
###  Fetch all user’s name who have retweeted particular tweet by tweet id. 
```sql
SELECT U.name
FROM tbl_user U
JOIN tbl_retweet R ON U.user_id = R.user_id
WHERE R.original_tweet_id = 1; 
``` 
###  Fetch all commented tweet’s content for particular tweet by tweet id. 
```sql
SELECT T.content
FROM tbl_tweet T
JOIN tbl_tweet C ON T.tweet_id = C.parent_tweet_id
WHERE T.tweet_id = 2; 
``` 
###  Fetch user’s timeline (All tweets from users whom I am following with tweet content and user name who has tweeted it)
```sql
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
``` 
