import requests
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import pandas as pd



scope = "user-top-read"

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope = scope))

top_tracks_short = sp.current_user_top_tracks(limit=10, offset=0, time_range="short_term")

def get_track_ids(time_frame):
    track_ids = []
    for song in time_frame['items']:
        track_ids.append(song['id'])
    return track_ids
