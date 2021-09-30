# DROP TABLES

songplay_table_drop = ""
user_table_drop = ""
song_table_drop = ""
artist_table_drop = ""
time_table_drop = ""

# CREATE TABLES

songplay_table_create = (""" CREATE TABLE IF NOT EXISTS songplays
                                (songplay_id int,
                                start_time datetime,
                                userid uuid,
                                level int,
                                song_id int,
                                artist_id int, 
                                session_id int,
                                location text,
                                user_agent text,
                                PRIMARY KEY (session_id, start_time))
""")

user_table_create = (""" CREATE TABLE IF NOT EXISTS users (
                            user_id int,
                            first_name text,
                            last_name text,
                            gender text,
                            level int,
                            PRIMARY KEY (user_id)})
""")

song_table_create = (""" CREATE TABLE IF NOT EXISTS songs (
                        song_id int,
                        title text,
                        artist_id int, 
                        year datetime,
                        duration int,
                        PRIMARY KEY (song_id))
""")

artist_table_create = (""" CREATE TABLE IF NOT EXISTS artists (
                            artist_id int,
                            name text,
                            location text,
                            latitude numeric,
                            longitude numeric,
                            PRIMARY KEY (artist_id
                            ))
""")

time_table_create = (""" CREATE TABLE IF NOT EXISTS time (
                            start_time datetime,
                            hour int,
                            day int,
                            week int,
                            month int,
                            year int,
                            weekday int,
                        PRIMARY KEY (start_time))
""")

# INSERT RECORDS

songplay_table_insert = (""" DROP TABLE IF EXISTS songplays
""")

user_table_insert = (""" DROP TABLE IF EXISTS users
""")

song_table_insert = (""" DROP TABLE IF EXISTS songs
""")

artist_table_insert = (""" DROP TABLE IF EXISTS artists
""")


time_table_insert = (""" DROP TABLE IF EXISTS time
""")

# FIND SONGS

song_select = (""" SELECT * FROM songs WHERE song_id = {song_id}
""")

# QUERY LISTS

create_table_queries = [songplay_table_create, user_table_create, song_table_create, artist_table_create, time_table_create]
drop_table_queries = [songplay_table_drop, user_table_drop, song_table_drop, artist_table_drop, time_table_drop]