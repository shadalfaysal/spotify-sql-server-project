# Spotify Data Analysis with SQL Server

![Spotify Logo](https://www.image2url.com/r2/default/images/1793296297276-67bb797f-219b-4097-83a7-a1048bdce777.jpg)

A SQL project on a Spotify + YouTube tracks dataset (20,594 rows). I practiced easy, medium and advanced queries, and then tested how an index changes query performance.

The project idea and the practice questions are from my instructor's PostgreSQL version. I redid the whole thing in **SQL Server (SSMS)**, so the syntax is different in some places (see the table below).

Dataset: [Spotify Dataset on Kaggle](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Tools
- SQL Server + SQL Server Management Studio (SSMS)
- T-SQL: aggregations, subqueries, CTE, window functions, indexing

## Project Structure
```
Spotify_SQL_Project/
├── data/cleaned_dataset.csv
├── sql/
│   ├── 00_create_and_load_table.sql
│   ├── 01_easy_queries.sql
│   ├── 02_medium_queries.sql
│   ├── 03_advanced_queries.sql
│   └── 04_query_optimization.sql
├── images/
└── README.md
```

## Dataset Columns
`artist, track, album, album_type, danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo, duration_min, title, channel, views, likes, comments, licensed, official_video, stream, energy_liveness, most_played_on`

## Setup
1. Put `cleaned_dataset.csv` in a folder and change the path inside `00_create_and_load_table.sql`.
2. Run the file. It loads the csv into a staging table first (`licensed` and `official_video` come as text), then inserts into the final `dbo.spotify` table with those two columns converted to `BIT`.
3. Check the data: total rows should be **20,594**, licensed = 1 should be **14,060** and licensed = 0 should be **6,534**.

## Queries

### Easy
1. Tracks with more than 1 billion streams
2. All albums with their artists
3. Total comments for licensed tracks
4. All tracks of album type `single`
5. Number of tracks by each artist

### Medium
6. Average danceability per album
7. Top 5 tracks by energy
8. Views and likes of tracks where `official_video = 1`
9. Total views per album
10. Tracks streamed more on Spotify than on YouTube

### Advanced
11. Top 3 most viewed tracks for each artist (`DENSE_RANK`)
12. Tracks with liveness above the average
13. Energy difference (max - min) per album using a CTE
14. Tracks where energy / liveness > 1.2
15. Cumulative sum of likes ordered by views (`SUM() OVER`)

All the queries are in the `sql/` folder.

## Query Optimization

I tested this query, which looks for the YouTube-most-played tracks of one artist:

```sql
SELECT TOP 25 artist, track, album, views, stream, most_played_on
FROM dbo.spotify
WHERE artist = 'Gorillaz'
  AND most_played_on = 'Youtube'
ORDER BY stream DESC;
```

Then I created an index on the `artist` column:

```sql
CREATE NONCLUSTERED INDEX idx_spotify_artist
ON dbo.spotify (artist);
```

I measured both runs with `SET STATISTICS IO ON` and `SET STATISTICS TIME ON`, and looked at the actual execution plan.

| | Before index | After index |
|---|---|---|
| Plan operator | Table Scan (heap) | Index Seek + RID Lookup |
| Logical reads | 1037 | 12 |
| CPU time (ms) | 16 | 0 |
| Elapsed time (ms) | 51 | 46 |

Logical reads went from 1037 to 12, which is about 99% less. The elapsed time did not change much because the table is small (about 20k rows) and these were first runs, so logical reads are the better number to compare here.

**Execution plan before index**

![Before](H:\DATA\project\Sopify Data\clude ai\images/execution_plan_before_index.jpg)

**Execution plan after index**

![After]((https://www.image2url.com/r2/default/images/1793296675595-e7654c4a-5292-4708-99bc-5a67d9ecdbf4.jpg))

**What I learned:** without an index SQL Server has to read the whole table to find one artist's rows. With the index on `artist` it can jump straight to those rows, so the reads go down a lot. The table has no clustered index, so SQL Server also does a RID Lookup on the heap to get the remaining columns for those few rows.

## PostgreSQL vs SQL Server (what I had to change)

| PostgreSQL (instructor) | SQL Server (mine) |
|---|---|
| `LIMIT n` | `SELECT TOP n` |
| `BOOLEAN` | `BIT` (1 / 0) |
| `GROUP BY 1` | column name must be written |
| `EXPLAIN ANALYZE` | `SET STATISTICS IO, TIME ON` + Actual Execution Plan |
| Seq Scan / Bitmap Index Scan | Table (Clustered Index) Scan / Index Seek |
| `COPY` / import wizard | `BULK INSERT` |

## Next Steps
- Build a Power BI dashboard on this data
- Try a composite index on `(artist, most_played_on)`

## Credits
Project idea and practice questions: my instructor. Dataset: Kaggle.
