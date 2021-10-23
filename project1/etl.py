import os
import glob
import psycopg2
import pandas as pd
from sql_queries import *


def process_song_file(cur, filepath):
    
    """ This function parse the relevant fields and fills the songs and artists tables.
        Input: 
            cur- the cursor object of the db connector
            filepath - a string of full path to access the song file
    """
   
    # open song file
    df = pd.read_json(filepath, lines=True)
    df = df.where(pd.notnull(df), None)

    # insert song record
    columns = ['song_id', 'title', 'artist_id', 'year', 'duration']
    song_data = df[columns]
    for idx, row in song_data.iterrows():
        cur.execute(song_table_insert, tuple(row[columns]))

    # insert artist record
    columns = ['artist_id','artist_name', 'artist_location', 'artist_latitude', 'artist_longitude']
    artist_data = df[columns]
    for idx, row in artist_data.iterrows():
        cur.execute(artist_table_insert, tuple(row[columns]))

def process_log_file(cur, filepath):
    
    """ This function parse the relevant fields and fills the time, user and songplay tables.
        Input: 
            cur- the cursor object of the db connector
            filepath - a string of full path to access the log file
    """
    # open log file
    df = pd.read_json(filepath, lines=True)

    # filter by NextSong action
    df = df.query("page=='NextSong'")

    # convert timestamp column to datetime
    t = pd.to_datetime(df['ts'], unit='ms')
    
    # insert time data records
    time_data = (t, t.dt.hour, t.dt.day, t.dt.week, t.dt.month, t.dt.year, t.dt.weekday)
    column_labels = ('start_time', 'hour','day','week','month','year','weekday')
    time_df = pd.DataFrame({col: time_data[idx] for idx, col in enumerate(column_labels)})

    for i, row in time_df.iterrows():
        cur.execute(time_table_insert, list(row))

    # load user table
    df.loc[:,'userId'] = df['userId'].astype(str)
    user_df = df.loc[(df['userId']!=''),
                 ['userId','firstName','lastName','gender','level']].drop_duplicates()

    # insert user records
    for i, row in user_df.iterrows():
        cur.execute(user_table_insert, row)

    df.loc[:,'ts'] = pd.to_datetime(df['ts'], unit='ms')
    # insert songplay records
    for index, row in df.iterrows():
        
        # get songid and artistid from song and artist tables
        cur.execute(song_select, (row.song, row.artist, row.length))
        results = cur.fetchone()
        
        if results:
            songid, artistid = results
        else:
            songid, artistid = None, None

        # insert songplay record
        songplay_data = (row.ts, row.userId, row.level, songid, artistid, row.sessionId, row.location, row.userAgent)
        cur.execute(songplay_table_insert, songplay_data)


def process_data(cur, conn, filepath, func):
    """ This function identifies the full paths of all JSON files in a directory, 
        and applies the processing function to the paths.
        Input: 
            cur- the cursor object of the db connector
            conn- the db connector
            filepath - a string of full path to access the song file
            func - processing function
    """
    # get all files matching extension from directory
    all_files = []
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root,'*.json'))
        for f in files :
            all_files.append(os.path.abspath(f))

    # get total number of files found
    num_files = len(all_files)
    print('{} files found in {}'.format(num_files, filepath))

    # iterate over files and process
    for i, datafile in enumerate(all_files, 1):
        func(cur, datafile)
        print('{}/{} files processed.'.format(i, num_files))


def main():
    
    """ The main function to connect to the db and call the process_data() with the path and appropriate processing function"""
    
    conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=student password=student")
    cur = conn.cursor()

    process_data(cur, conn, filepath='data/song_data', func=process_song_file)
    process_data(cur, conn, filepath='data/log_data', func=process_log_file)
    
    conn.commit()
    conn.close()


if __name__ == "__main__":
    main()