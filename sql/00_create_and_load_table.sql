/*=====================================================================
  Spotify SQL Project (SQL Server)
  Step 1: create the tables and load the CSV
=====================================================================*/

-- staging table: everything is loaded as it comes, licensed and
-- official_video are text in the csv (TRUE / FALSE / 0)
DROP TABLE IF EXISTS dbo.spotify_stg;
CREATE TABLE dbo.spotify_stg (
    artist           NVARCHAR(255),
    track            NVARCHAR(255),
    album            NVARCHAR(255),
    album_type       NVARCHAR(50),
    danceability     FLOAT,
    energy           FLOAT,
    loudness         FLOAT,
    speechiness      FLOAT,
    acousticness     FLOAT,
    instrumentalness FLOAT,
    liveness         FLOAT,
    valence          FLOAT,
    tempo            FLOAT,
    duration_min     FLOAT,
    title            NVARCHAR(255),
    channel          NVARCHAR(255),
    views            BIGINT,
    likes            BIGINT,
    comments         BIGINT,
    licensed         NVARCHAR(10),
    official_video   NVARCHAR(10),
    stream           BIGINT,
    energy_liveness  FLOAT,
    most_played_on   NVARCHAR(50)
);

-- change the path to where the csv is on your pc
BULK INSERT dbo.spotify_stg
FROM 'H:\DATA\project\Spotify Data\data\cleaned_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);

-- final table (licensed and official_video converted to BIT)
DROP TABLE IF EXISTS dbo.spotify;
CREATE TABLE dbo.spotify (
    artist           NVARCHAR(255),
    track            NVARCHAR(255),
    album            NVARCHAR(255),
    album_type       NVARCHAR(50),
    danceability     FLOAT,
    energy           FLOAT,
    loudness         FLOAT,
    speechiness      FLOAT,
    acousticness     FLOAT,
    instrumentalness FLOAT,
    liveness         FLOAT,
    valence          FLOAT,
    tempo            FLOAT,
    duration_min     FLOAT,
    title            NVARCHAR(255),
    channel          NVARCHAR(255),
    views            BIGINT,
    likes            BIGINT,
    comments         BIGINT,
    licensed         BIT,
    official_video   BIT,
    stream           BIGINT,
    energy_liveness  FLOAT,
    most_played_on   NVARCHAR(50)
);

INSERT INTO dbo.spotify
SELECT
    artist, track, album, album_type,
    danceability, energy, loudness, speechiness, acousticness,
    instrumentalness, liveness, valence, tempo, duration_min,
    title, channel, views, likes, comments,
    CASE WHEN UPPER(LTRIM(RTRIM(licensed))) = 'TRUE' THEN 1 ELSE 0 END,
    CASE WHEN UPPER(LTRIM(RTRIM(official_video))) = 'TRUE' THEN 1 ELSE 0 END,
    stream, energy_liveness, most_played_on
FROM dbo.spotify_stg;

DROP TABLE dbo.spotify_stg;

-- quick check
SELECT COUNT(*) AS total_rows FROM dbo.spotify;                       -- 20594
SELECT licensed, COUNT(*) AS cnt FROM dbo.spotify GROUP BY licensed;  -- 1 = 14060, 0 = 6534
