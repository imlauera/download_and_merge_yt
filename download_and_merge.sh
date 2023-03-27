#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Error: You need to pass me the playlist url of the video." >&2
  exit 1
fi

## Pick one video of a playlist and do -F on the one video using yt-dlp
yt-dlp -F --playlist-end 1 $1
echo "#############"
read -p "Enter the id format code (e.g., 18,22,140): " video_format
echo "#############"

# transform yt-dlp video format code to an extention 
extension=$(yt-dlp --list-formats --playlist-end 1 $1 | grep "$video_format" | awk '{print $2}')


yt-dlp -f $video_format $1 -o '%(autonumber)s%(id)s.%(ext)s' 

if [ -f "mylist.txt" ]; then
  rm -rf mylist.txt
fi
if [ -f "output.$extension" ]; then
  rm -rf "output.$extension"
fi

touch mylist.txt && for file in *.$extension ; do echo "file '$file'" >> mylist.txt ; done &&
ffmpeg -f concat -safe 0 -i mylist.txt -c copy "output.$extension"
