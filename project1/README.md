# Project Spartify - ETL

Hi! Welcome to the repositiory of ETL job for Sparkify!

The data model used in this project allows the Analytics Team in Sparkify to understand user activity via simple queries. It laid the ground work for possible analysis from overall ideas like artists popularity to more detailed understanding of user activity in a day/week/season. The team can then develop strategy for user enagement and possible advertising timeslots.

## Data model

The database is designed in a star schema. It consists of one fact table - songplays, and 4 dimension tables - artists, songs, users and time. 
The purpose of database is to store all info for historical events that are relevant to the facts, i.e. each actions of songplay by a user alongs side to each relevant attributes in the dimension tables. This allows easy aggregaton and simple access by simple queries.

### Fact Table

- songplays - records in log data associated with song plays i.e. records with page NextSong
songplay_id, start_time, user_id, level, song_id, artist_id, session_id, location, user_agent

### Dimension Tables

- users - users in the app
user_id, first_name, last_name, gender, level

- songs - songs in music database
song_id, title, artist_id, year, duration

- artists - artists in music database
artist_id, name, location, latitude, longitude

- time - timestamps of records in songplays broken down into specific units
start_time, hour, day, week, month, year, weekday


## ETL Job

An ETL job is defined in *etl.py* which opens each song/log json file, read as a Pandas DataFrame, then parse the relevant columns in each tables.
Data selection of non-duplicated records and non-empty ID values were applied for dimension tables. Transformation of columns into string types were also performed for user_id in the users table. 
The job inserts into each table row by row, which is acceptable for small amount of data, but not for bulky data. 
In summary, this is a job that works fine but not optimized.