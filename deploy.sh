#!/bin/bash

# Exit on error
set -e

# Preserve .git folder temporarily

mv public/.git /tmp/public-git

# Build site
echo "Building site..."
hugo --cleanDestinationDir

# Restore .git

mv /tmp/public-git public/.git

# Deploy to live GitHub pages site
echo "Deploying to GitHub Pages..."
cd public
git add .
message="Rebuilt site $(date)"
if [ -n "$*" ]; then
	message="$*"
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
