import configparser


# CONFIG
config = configparser.ConfigParser()
config.read('dwh.cfg')

# DROP TABLES

#staging_events_table_drop = "DROP TABLE IF EXISTS staging_events"
#staging_songs_table_drop = "DROP TABLE IF EXISTS staging_songs"

songplay_table_drop = "DROP TABLE IF EXISTS songplays"
user_table_drop = "DROP TABLE IF EXISTS users"
song_table_drop = "DROP TABLE IF EXISTS songs"
artist_table_drop = "DROP TABLE IF EXISTS artists"
time_table_drop = "DROP TABLE IF EXISTS time"

# CREATE TABLES

staging_events_table_create= ("""CREATE TABLE IF NOT EXISTS staging_events
                                (artist text,
                                auth text,
                                firstName text,
                                gender text,
                                itemInSession INTEGER,
                                lastName text,
                                length DOUBLE PRECISION ,
                                level text,
                                location text,
                                method text,
                                page text,
                                registration BIGINT,
                                sessionId INTEGER,
                                song text,
                                status INTEGER,
                                ts BIGINT,
                                userAgent text,
                                userId text
                                )
""")

staging_songs_table_create = ("""CREATE TABLE IF NOT EXISTS staging_songs 
                                (artist_id text,
                                artist_latitude text,
                                artist_location text,
                                artist_longitude text,
                                artist_name text,
                                duration DOUBLE PRECISION ,
                                num_songs INTEGER,
                                song_id text,
                                title text,
                                year INTEGER)
""")


songplay_table_create = (""" CREATE TABLE IF NOT EXISTS songplays
                                (songplay_id text,
                                start_time timestamp,
                                user_id text,
                                level text,
                                song_id text,
                                artist_id text, 
                                session_id INTEGER,
                                location text,
                                user_agent text)
""")

user_table_create = (""" CREATE TABLE IF NOT EXISTS users (
                            user_id text,
                            first_name text,
                            last_name text,
                            gender text,
                            level text)
""")

song_table_create = (""" CREATE TABLE IF NOT EXISTS songs (
                        song_id text,
                        title text,
                        artist_id text, 
                        year INTEGER,
                        duration REAL)
""")

artist_table_create = (""" CREATE TABLE IF NOT EXISTS artists (
                            artist_id text,
                            name text,
                            location text,
                            latitude text,
                            longitude text)
""")

time_table_create = (""" CREATE TABLE IF NOT EXISTS time (
                            start_time timestamp,
                            hour INTEGER,
                            day INTEGER,
                            week INTEGER,
                            month INTEGER,
                            year INTEGER,
                            weekday INTEGER)
""")

# STAGING TABLES

staging_events_copy = ("""COPY staging_events 
FROM 's3://udacity-dend/log_data'
iam_role 'arn:aws:iam::823407533684:role/role-redshift-access'
region 'us-west-2'
JSON 's3://udacity-dend/log_json_path.json';
""").format()

staging_songs_copy = ("""COPY staging_songs 
FROM 's3://udacity-dend/song_data'
iam_role 'arn:aws:iam::823407533684:role/role-redshift-access'
region 'us-west-2';
""").format()

# FINAL TABLES

songplay_table_insert = (""" INSERT INTO songplays (start_time, user_id, level, song_id,  artist_id, session_id, location, user_agent)
                            SELECT date_add('ms',log.ts,'1970-01-01') AS start_time,
                            CASE log.userId WHEN null THEN 'NULL' ELSE log.userId END as user_id,
                            log.level as level,
                            song.song_id as song_id,
                            song.artist_id as artist_id,
                            log.sessionId as session_id,
                            log.location as location,
                            log.userAgent as user_agent
                            FROM staging_events as log
                            JOIN staging_songs as song
                            ON log.artist = song.artist_name AND log.song = song.title
""")

user_table_insert = (""" INSERT INTO users (user_id,first_name,last_name,gender,level)
                            SELECT CASE userId WHEN null THEN 'NULL' ELSE userId END as user_id,
                            firstName as first_name,
                            lastName as last_name,
                            gender,
                            level 
                            FROM staging_events
                            GROUP BY user_id, first_name, last_name, gender, level
""")


song_table_insert = ("""INSERT INTO songs (song_id, title, artist_id, year, duration)
                        SELECT song_id, title, artist_id, year, duration FROM staging_songs
                            GROUP BY song_id, title, artist_id, year, duration
""")

artist_table_insert = (""" INSERT INTO artists (artist_id,name, location, latitude, longitude)
                            SELECT artist_id, 
                            artist_name as name,
                            artist_location as location, 
                            artist_latitude as latitude,
                            artist_longitude as longitude
                            FROM staging_songs
                            GROUP BY artist_id, artist_name, artist_location, artist_latitude,
                            artist_longitude
""")


time_table_insert = (""" INSERT INTO time (start_time,hour, day, week, month, year, weekday)
SELECT timestamp AS timestamp, 
extract(hour from timestamp) as hour, 
extract(day from timestamp) as day, 
extract(week from timestamp) as week,
extract(month from timestamp) as month,
extract(year from timestamp) as year,
extract(weekday from timestamp) as weekday
FROM (SELECT DISTINCT date_add('ms',ts,'1970-01-01') AS timestamp FROM staging_events)
""")

# QUERY LISTS

create_table_queries = [# staging_events_table_create, staging_songs_table_create, 
                        songplay_table_create, user_table_create, song_table_create,  artist_table_create, time_table_create]
drop_table_queries = [#staging_events_table_drop, staging_songs_table_drop, 
                      songplay_table_drop, user_table_drop, song_table_drop, artist_table_drop, time_table_drop]
copy_table_queries = [staging_events_copy, staging_songs_copy]
insert_table_queries = [songplay_table_insert, user_table_insert, song_table_insert, artist_table_insert, time_table_insert]
