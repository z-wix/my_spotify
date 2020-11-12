# Initial Spotify Analysis

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
# spotify api
library(Rspotify)



# Spotify Credentials -----------------------------------------------------

# "Load my_oath if saved already"

# id <- 'Id'
# secret <- 'ClientSecret'
# app_id <- "my_music_analysis"

user_id <- "zwixom"

# Authentication ----------------------------------------------------------

# # my_oauth <- spotifyOAuth(app_id="xxxx",client_id="yyyy",client_secret="zzzz")
# my_oauth <- spotifyOAuth(app_id, id, secret)
# 
# # Save authentication
# save(my_oauth, file="my_oauth")

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
playlists <- as.vector(all_playlists$playlist_id)

# Empty vector for playlists with over 100 songs
over_100 <- vector("character")

# Loop to collect playlists with over 100 songs
for(i in seq(playlists)) {
  x <- getPlaylistSongs(user_id, playlists[i], offset = 0, token = my_oauth)
  if(nrow(x) < 100){
    print(i)
  }else{
  over_100 <- c(over_100, playlists[i])
  print(playlists[i])
  }
}

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

# loop to collect data about songs in the playlist
for (i in seq(playlists)) {
  # getPlaylistsongs
  x <- getPlaylistSongs(user_id, playlists[i], offset = 0, token = my_oauth)
  # Add index column to x
  x$playlist_index <- i
  # Rbind x and playlist_data
  playlist_data <- rbind(playlist_data, x)
}

# Loop to gather artist over 100 in playlists
for (i in seq(over_100)) {
  # Not sure why these playlist IDs i couldn't grab the data after 100 songs
  if (i %in% c(1,12,16,19)) {
    print(i)
  }else{
    # getPlaylistsongs
    x <- getPlaylistSongs(user_id, over_100[i], offset = 100, token = my_oauth)
    # Add index column to x
    x$playlist_index <- i
    # Rbind x and playlist_data
    playlist_data <- rbind(playlist_data, x)
    # print i for progress
    print(i)
  }
}

# Rename some variables
playlist_data <- playlist_data %>% 
  rename(track_id = id, track_pop = popularity)


# practice code -----------------------------------------------------------


# getPlaylistSongs only grabs up to 100 of songs so you offset = 100 to get songs after 100
# beat_s_100 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 100, token = my_oauth)

# beat_s_100$playlist_index <- i + 1

# playlist_data <- rbind(playlist_data, beat_s_100)


# Get User Artist ---------------------------------------------------------

# select artist vars
my_artists <- playlist_data %>% 
  select(artist, artist_full, artist_id)

# create vecotr for for loop of artists ids
artists <- as.vector(unique(my_artists$artist_id))

# Check to make sure the artist Ids can be found
for(i in seq(artists)) {
  x <- getArtist(artists[i], token = my_oauth)
  if(nrow(x) < 1){
    print(i)
  }else{
    print("success")
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
  # Rbind x and playlist_data
  artist_data <- rbind(artist_data, x)
}


# only could do the first 127 artists so I will do it again
# repeat{
  if(nrow(artist_data) == n_distinct(artists)){
    print("finished")
    # break
  }else{
    artists2 <- as.vector((nrow(artist_data)+1):1453)
    for (i in artists2) {
      x <- getArtist(artists[i],token = my_oauth)
      # Rbind x and playlist_data
      artist_data <- rbind(artist_data, x)
    }
  }
# }



artist_data <- artist_data %>% 
  rename(artist_id = id, artist_name = name, artist_pop = popularity, artist_followers = followers)



# Join Playlists and Artist  ----------------------------------------------

my_music <- inner_join(playlist_data, artist_data)

write.csv(my_music, "my_music.csv")


# practice playlist stuff -------------------------------------------------

# beat_s_1 <- getPlaylistSongs(user_id, playlist_id = "4rExKM3K6d0PEORWwrIdnx", offset = 0, token = my_oauth)

# join together larger playlist
# beat_s <- rbind(beat_s_1, beat_s_100)

# Other large playlists made by user
# game_beats <- getPlaylistSongs(user_id, playlist_id = "7qDHu25bjzPesmyFjNZCO5", offset = 0, token = my_oauth)
# toon_beats <- getPlaylistSongs(user_id, playlist_id = "2ZspCM7ulRvd2lt6vhbjbo", offset = 0, token = my_oauth)





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

