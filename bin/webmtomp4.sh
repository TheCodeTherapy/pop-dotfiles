#!/bin/bash

# ffmpeg -i Tron.webm -crf 21 Tron.mp4 && rm Tron.webm

# convert webm to mp4 with 21 quality/compression level
ffmpeg -i $1.webm -crf $2 $1.mp4

# cut the video to its first 8 seconds
ffmpeg -ss 00:00:00 -i $1.mp4 -c copy -t 00:00:08 out.mp4 && mv out.mp4 $1.mp4

# apply faststart (play before full download) metadata to video file
ffmpeg -i $1.mp4 -c copy -movflags +faststart out.mp4 && mv out.mp4 $1.mp4

