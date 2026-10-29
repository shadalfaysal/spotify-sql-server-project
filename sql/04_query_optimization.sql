/*=====================================================================
  Query Optimization (indexing)
  Run in SSMS with "Include Actual Execution Plan" (Ctrl + M) turned on
=====================================================================*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- 1) BEFORE the index
SELECT TOP 25
    artist, track, album, views, stream, most_played_on
FROM dbo.spotify
WHERE artist = 'Gorillaz'
  AND most_played_on = 'Youtube'
ORDER BY stream DESC;
-- note down: logical reads, CPU time, elapsed time, and the plan operator
-- (it should be a Clustered/Table Scan because there is no index)

-- 2) create the index on artist
CREATE NONCLUSTERED INDEX idx_spotify_artist
ON dbo.spotify (artist);

-- 3) AFTER the index (same query)
SELECT TOP 25
    artist, track, album, views, stream, most_played_on
FROM dbo.spotify
WHERE artist = 'Gorillaz'
  AND most_played_on = 'Youtube'
ORDER BY stream DESC;
-- note down the same numbers again

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- to run the test again from the start
-- DROP INDEX idx_spotify_artist ON dbo.spotify;
