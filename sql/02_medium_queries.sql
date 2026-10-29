/*=====================================================================
  Medium Queries
=====================================================================*/

-- Q6. Average danceability of tracks in each album
SELECT
    album,
    AVG(danceability) AS avg_danceability
FROM dbo.spotify
GROUP BY album
ORDER BY avg_danceability DESC;

-- Q7. Top 5 tracks with the highest energy values
SELECT TOP 5
    track,
    MAX(energy) AS highest_energy
FROM dbo.spotify
GROUP BY track
ORDER BY highest_energy DESC;

-- Q8. List all tracks along with their views and likes where official_video = TRUE
SELECT
    track,
    views,
    likes
FROM dbo.spotify
WHERE official_video = 1
ORDER BY views DESC;

-- Q9. For each album, calculate the total views of all associated tracks
SELECT
    album,
    SUM(views) AS total_views
FROM dbo.spotify
GROUP BY album
ORDER BY total_views DESC;

-- Q10. Tracks that have been streamed on Spotify more than on YouTube
SELECT *
FROM (
    SELECT
        track,
        SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) AS streamed_on_youtube,
        SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) AS streamed_on_spotify
    FROM dbo.spotify
    GROUP BY track
) t
WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube > 0;
