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
all_playlists <- getPlaylists(user_id, offset = 0, my_oauth) %>% 
  rename(playlist_id = id, playlist_name = name, num_tracks = tracks)

# Filter for users own curator playlists
my_playlists <- all_playlists %>% 
  filter(ownerid == user_id)

# Vecotr of playlist_ids
playlists <- as.vector(my_playlists$playlist_id)

# empty data frame for loop
playlist_data <- data.frame(track=character(),
                            id=character(), 
                            popularity=numeric(), 
                            artist=character(),
                            artist_full=character(),
                            artist_id=character(),
                            album=character(),
                            album_id=character(),
                            playlist_index=numeric(),
                            stringsAsFactors=FALSE)

# loop to collect data about artists in the playlist
for (i in seq(playlists)) {
  # getPlaylistsongs
  x <- getPlaylistSongs(user_id, playlists[i], offset = 0, token = my_oauth)
  # Add index column to x
  x$playlist_index <- i
  # Add index column to playlist_data
  playlist_data$playlist_index <- i
  # Rbind x and playlist_data
  playlist_data <- rbind(playlist_data, x)
}

# getPlaylistSongs only grabs up to 100 of songs so you offset = 100 to get songs after 100
beat_s_100 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 100, token = my_oauth)

beat_s_100$playlist_index <- i + 1

playlist_data <- rbind(playlist_data, beat_s_100)

playlist_data %>% 
  rename(track_id = id)

# practice playlist stuff -------------------------------------------------



# beat_s_1 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 0, token = my_oauth)

# join together larger playlist
# beat_s <- rbind(beat_s_1, beat_s_100)

# Other large playlists made by user
# game_beats <- getPlaylistSongs(user_id, playlist_id = "7qDHu25bjzPesmyFjNZCO5", offset = 0, token = my_oauth)
# toon_beats <- getPlaylistSongs(user_id, playlist_id = "2ZspCM7ulRvd2lt6vhbjbo", offset = 0, token = my_oauth)




# Artist Analysis ---------------------------------------------------------

# select artist vars
beat_s_artists <- beat_s %>% 
  select(artist, artist_full, artist_id)

# create vecotr for for loop of artists ids
artists <- as.vector(beat_s_artists$artist_id)

# Check to make sure the artist Ids can be found
for(i in seq(artists)) {
  x <- getArtist(artists[i], token = my_oauth)
  if(nrow(x) < 1){
    print(i)
  }
}

# empty dataframe for loop
artist_data <- data.frame(artist=character(),
                          id=character(), 
                          popularity=numeric(), 
                          followers=numeric(),
                          genres=character(),
                          stringsAsFactors=FALSE)

# loop to collect data about artists in the playlist
for (i in seq(artists)) {
  x <- getArtist(artists[i],token = my_oauth)
  
  artist_data <- rbind(artist_data, x)
}


artist_data


# practice artist stuff ---------------------------------------------------



# searchArtist("j'san",token = my_oauth) %>% 
#   filter(artist == "j'san")
# 
# searchArtist(artists[114],token = my_oauth) %>% 
#   filter(artist == artists[114])
#   
# getArtist("4owATw6JCMuUxeWdh3eiyg", token = my_oauth)
# 
# getArtist(artists[3], token = my_oauth)

