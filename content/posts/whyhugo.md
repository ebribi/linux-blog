+++
date = '2025-10-04T18:34:18-04:00'
title = 'Why Hugo (and a little bash script to make deploying easier...)'
+++

I wanted a fast, simple way to get this blog up and running. I also wanted to learn how I can host a site on GitHub since I 1) knew it was possible and 2) had never gotten the chance to do it.

## Hugo vs. Jekyll and GitHub Pages

From what I read, Jeykll is the native, go-to option for hosting static sites on GitHub Pages. I opted for Hugo instead because it would be less automated and force me to get familiar with using git locally.

I created 2 repositories in my GitHub: [one](https://github.com/ebribi/linux-blog) to store my source code, and [the other](https://github.com/ebribi/linuxnoob) to deploy the site.

### Lesson #1 - You only get 1 .github.io

And it must be your username. For me, this is `ebribi.github.io`. I restarted this project 3-4 times because I named the repository `linuxnoob.github.io` thinking that I could `.github.io` to my heart's desire. Sadly, you can't. So instead, the base URL is `ebribi.github.io/linuxnoob`. Any other sites I host with GitHub Pages that isn't `ebribi.github.io` will have a base URL of `ebribi.github.io/[repo-name]`. 

## Setting Up

I decided to use the [Xmin](https://xmin.yihui.org/) theme. Clean, simple. Good documentation, especially in the creator's [blogdown book](https://bookdown.org/yihui/blogdown/hugo.html). I cloned the repo (https://github.com/yihui/hugo-xmin.git) to my /themes folder and added `theme="Xmin"` to hugo.toml. At this point, I could run hugo serve to generate the site on a localhost and make sure everything was running fine.

*A more detailed step-by-step to come...*

## Extra: Shell Script for Deployment

Since I've managing 2 separate repositories for the source code and deploying the site, I tried my hand at a shell script to automate the process.

```
    #!/bin/bash
    
    # Exit on error
    
    set -e

    # Preserve .git folder in /public temporarily
    
    mv public/.git /tmp/public-git

    # Built site
    
    echo "Building site..."
    hugo --cleanDestinationDir
    
    # Restore .git
    mv /tmp/public-git
    public/.git

    # Deploy to live GitHub pages site
    
    echo "Deplying to GitHub Pages..."
    cd public
    git add .
    message="Rebuilt site $(date)" # defualt if no commit message passed
    if [ -n "$*"]; then
        message="$*"
    fi
    git commit -m "$message"
    git push origin main
    cd ..

    # Backup source to linux-blog repo
    
    echo "Backing up source..."
    git add .
    git commit -m "$message"
    git push origin main

    echo "Complete."

```

*More explanation of script to come...*
