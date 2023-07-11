
-- What are the most liked videos?
SELECT Title,
       SUM(Likes) AS total_likes
FROM videos_stats
GROUP BY Title
ORDER BY total_likes DESC

--What are the most the most commented-upon videos?
SELECT Title,
       SUM(Comments) AS total_comments
FROM videos_stats
GROUP BY Title
ORDER BY total_comments DESC

-- How many total views does each category have? How many likes?
SELECT Keyword,
       SUM(Views) AS total_views,
       SUM(Likes) AS total_likes
FROM videos_stats
GROUP BY Keyword
ORDER BY total_views DESC, total_likes

-- What are the most-liked comments?
SELECT Comment,
       SUM(Likes) AS total_likes_comments
FROM comments
GROUP BY Comment
ORDER BY total_likes_comments DESC

-- What is the ratio of views/likes per each category?
SELECT Keyword,
       (SUM(Views) / SUM(Likes)) AS ratio_views_to_likes
FROM videos_stats
GROUP BY Keyword
ORDER BY ratio_views_to_likes DESC

-- What is the average sentiment score in each keyword category?
SELECT v.Keyword,
       AVG(c.Sentiment) AS avg_sentiment_per_category
FROM comments c
INNER JOIN videos_stats v
ON c.Video_ID = v.Video_ID
GROUP BY v.Keyword

-- How many times do company names apple or google appear in each keyword category?
SELECT 
Keyword,
COUNT(Keyword) AS category_count
FROM videos_stats
WHERE 
Keyword = 'google' OR
Keyword = 'apple'
GROUP BY Keyword



