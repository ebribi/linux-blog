#!/bin/bash

# Exit on error
set -e

# Build site
echo "Building site..."
hugo --cleanDestinationDir


# Deploy to live GitHub pages site
echo "Deploying to GitHub Pages..."
cd public
git add .
message = "Rebuilt site $(date)"
if [ -n "$*" ]; then
	message = "$*"
fi
git commit -m "$msg"
git push origin main
cd ..

# Backup source to linux-blog repo
echo "Backing up source..."
git add .
git commit -m "$msg"
git push origin main

echo "Complete."
