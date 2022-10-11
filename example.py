import os
import spotipy
from spotipy.oauth2 import SpotifyOAuth


'''
export SPOTIPY_CLIENT_ID='d651a403a9b44284a0401d3c1e371166'
export SPOTIPY_CLIENT_SECRET='5baf5035fe5f44a2886737349b978d13'
export SPOTIPY_REDIRECT_URI='http://localhost:1410/'  
'''

scope = "user-library-read"

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope=scope))

results = sp.current_user_saved_tracks()
for idx, item in enumerate(results['items']):
    track = item['track']
    print(idx, track['artists'][0]['name'], " – ", track['name'])



from spotipy.oauth2 import SpotifyClientCredentials

auth_manager = SpotifyClientCredentials()
sp = spotipy.Spotify(auth_manager=auth_manager)

playlists = sp.user_playlists('spotify')
while playlists:
    for i, playlist in enumerate(playlists['items']):
        print("%4d %s %s" % (i + 1 + playlists['offset'], playlist['uri'],  playlist['name']))
    if playlists['next']:
        playlists = sp.next(playlists)
    else:
        playlists = None