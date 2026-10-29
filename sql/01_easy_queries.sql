/*=====================================================================
  Easy Queries
=====================================================================*/

-- Q1. Retrieve the names of all tracks that have more than 1 billion streams
SELECT track, artist, stream
FROM dbo.spotify
WHERE stream > 1000000000
ORDER BY stream DESC;

-- Q2. List all albums along with their respective artists
SELECT DISTINCT album, artist
FROM dbo.spotify
ORDER BY album;

-- Q3. Total number of comments for tracks where licensed = TRUE
SELECT SUM(comments) AS total_comments
FROM dbo.spotify
WHERE licensed = 1;

-- Q4. Find all tracks that belong to the album type single
SELECT track, artist, album
FROM dbo.spotify
WHERE album_type = 'single';

-- Q5. Count the total number of tracks by each artist
SELECT artist, COUNT(*) AS total_tracks
FROM dbo.spotify
GROUP BY artist
ORDER BY total_tracks DESC;
