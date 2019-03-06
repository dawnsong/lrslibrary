
# https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video
ffmpeg -y -i ../dataset/highway.avi -filter:v "setpts=2*PTS"  -c:v libx264 highway.mp4
