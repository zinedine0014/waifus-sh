#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [-c category] [-n number]"
    echo "  -c category  Specify the category (e.g., waifu, neko, etc.)"
    echo "  -n number    Specify the number of images to download"
    exit 1
}

# Default values
CATEGORY="waifu"
NUM_IMAGES=5


while getopts ":c:n:" opt; do
    case $opt in
        c) CATEGORY=$OPTARG ;;
        n) NUM_IMAGES=$OPTARG ;;
        \?) usage ;;
    esac
done

# Define the API URL and the directory to save images
API_URL="https://api.waifu.pics/sfw/$CATEGORY"
SAVE_DIR="./waifu_pics"

mkdir -p "$SAVE_DIR"

# Loop to download images
for (( i=1; i<=$NUM_IMAGES; i++ ))
do
    echo "Downloading image $i..."

    # Make a request to the API and extract the image URL
    IMAGE_URL=$(curl -s "$API_URL" | jq -r '.url')

    if [ -n "$IMAGE_URL" ]; then
        # Download the image
        curl -s "$IMAGE_URL" -o "$SAVE_DIR/${CATEGORY}_${i}.jpg"
        echo "Image $i downloaded and saved as ${CATEGORY}_${i}.jpg"
    else
        echo "Failed to retrieve image URL for image $i"
    fi
done

echo "Download complete. Saved $NUM_IMAGES images to $SAVE_DIR."
