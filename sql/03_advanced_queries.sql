/*=====================================================================
  Advanced Queries
=====================================================================*/

-- Q11. Top 3 most viewed tracks for each artist (window function)
WITH ranking_artist AS (
    SELECT
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rnk
    FROM dbo.spotify
    GROUP BY artist, track
)
SELECT artist, track, total_views, rnk
FROM ranking_artist
WHERE rnk <= 3
ORDER BY artist, rnk;

-- Q12. Tracks where the liveness score is above the average
SELECT
    track,
    artist,
    liveness
FROM dbo.spotify
WHERE liveness > (SELECT AVG(liveness) FROM dbo.spotify)
ORDER BY liveness DESC;

-- Q13. WITH clause: difference between highest and lowest energy in each album
WITH cte AS (
    SELECT
        album,
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM dbo.spotify
    GROUP BY album
)
SELECT
    album,
    highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC;

-- Q14. Tracks where the energy-to-liveness ratio is greater than 1.2
SELECT
    track,
    artist,
    energy,
    liveness,
    energy / NULLIF(liveness, 0) AS energy_liveness_ratio
FROM dbo.spotify
WHERE energy / NULLIF(liveness, 0) > 1.2
ORDER BY energy_liveness_ratio DESC;

-- Q15. Cumulative sum of likes for tracks ordered by views (window function)
SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_likes
FROM dbo.spotify
ORDER BY views;
