# Initial Spotify Analysis


# Dependency to Install SpotifyR -------------------------------------------

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)

# spotify api 2
library(Rspotify)



# Spotify Credentials -----------------------------------------------------

id <- 'd651a403a9b44284a0401d3c1e371166'
secret <- '1a058575501947818f5c0035fc365892'
app_id <- "my_music_analysis"
user_id <- "zwixom"

# Authentication ----------------------------------------------------------

# my_oauth <- spotifyOAuth(app_id="xxxx",client_id="yyyy",client_secret="zzzz")
my_oauth <- spotifyOAuth(app_id, id, secret)

# Save authentication
save(my_oauth, file="my_oauth")

# to load authentication
load("my_oauth")


# Access User -------------------------------------------------------------

user <- getUser(user_id=user_id,token=my_oauth)

user$display_name
user$id
user$followers


# Get User Playlists ------------------------------------------------------

# All playlists user follows
playlists <- getPlaylists(user_id, offset = 0, my_oauth)

# Filter for users own curator playlist
my_playlists <- playlists %>% 
  filter(ownerid == user_id)

# getPlaylistSongs only grabs up to 100 of songs so you offset = 100 to get songs after 100
beat_s_100 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 100, token = my_oauth)

beat_s_1 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 0, token = my_oauth)

# join together larger playlist
beat_s <- rbind(beat_s_1, beat_s_100)

# Other large playlists made by user
game_beats <- getPlaylistSongs(user_id, playlist_id = "7qDHu25bjzPesmyFjNZCO5", offset = 0, token = my_oauth)
toon_beats <- getPlaylistSongs(user_id, playlist_id = "2ZspCM7ulRvd2lt6vhbjbo", offset = 0, token = my_oauth)





