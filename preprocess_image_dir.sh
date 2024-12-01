#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

for img in "$1"/*.{jpg,jpeg,png}; do
  if [ -f "$img" ]; then
    echo "Processing: $img"
    dimensions=$(magick identify -format "%wx%h" "$img")
    echo "Dimensions: $dimensions"
    width=$(echo "$dimensions" | cut -dx -f1)
    height=$(echo "$dimensions" | cut -dx -f2)

    if [ "$width" -ge "$height" ]; then
      echo "Orientation: Landscape"
      echo "Resizing to 1920x1080"
      magick "$img" -resize 1920x1080\> -strip "${img%.*}.webp"
    else
      echo "Orientation: Portrait"
      echo "Resizing to 1080x1920"
      magick "$img" -resize 1080x1920\> -strip "${img%.*}.webp"
    fi

    if [ $? -eq 0 ]; then
      echo "Successfully processed: $img"
    else
      echo "Error processing: $img"
    fi
  fi
done
