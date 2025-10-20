+++
date = '2025-10-04T18:34:18-04:00'
title = 'Why Hugo (and a little shell script to make deploying easier...)'
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

Since I'm managing 2 separate repositories for the source code and deploying the site, I tried my hand at a shell script to automate the process.

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
I'll walk through the script line-by-line, partly to explain for the reader, mostly to check my own understanding of the code.

```
    #!/bin/bash
```

Known as a "shebang" in Unix, this line specifies to the operating system to use the bash shell as the default shell to run the commands that will follow in the script.

```
    set -e
``` 
The `set` command allows for setting or unsetting different shell options/parameters. An example of the variables that can be passed to this command is the `-x` flag (`xtrace`) for debugging. The `-e` flag (`errexit`) makes the script exit immediately if a command fails. In the context of this script, this is good to use so that any failure in pushing my changes doesn't result in a partial deployment. 

```
    mv public/.git /tmp/public-git
```
Here, I copy the .git file from my project directory to a temporary folder. I'll explain further why next.

```
    echo "Building site..."
    hugo --cleanDestinationDir
``` 
After printing an update to the terminal that the site is being built, I build the site with the `hugo --cleanDestinationDir` command. Passing `--cleanDestinationDir` with this command ensures that stale content (old pages or assets like images that are no longer being used) is deleted from the `public/` directory before the new site is built.

However, `--cleanDestinationDir` also deletes hidden files (like `.git`). Losing `.git` means losing the remote connection to `linuxnoob.git`. This is why I copy `.git` over to /tmp/public-git before the entire `public/` directory is deleted and rebuilt.

```
    mv /temp/public-git
    public/.git
```
With the site now rebuilt in `public/`, I can move `.git` back into the `public/` directory. 

```
    echo "Deploying to GitHub pages..."
    cd public
    git add .
    message="Rebuilt site $date"
    if [ -n "$*" ]; then
        message="$*"
    fi
```
An update message prints to signal that the site has been created successfully and that the script is now pushing the changes.

First, the site itself will be pushed to the `linuxnoob.git` repository that hosts `ebribi.github.io/linuxnoob/`. All changes from the current directory are staged for commit with `git add .`, including new and modified files. 

A default message for the commit is stored in the `message` variable. The following conditional statement allows for passing a unique commit message when running the script.

`$*` is a special bash parameter that takes all parameters passed with `./deploy.sh` in the command line and joins them together with spaces. Since the parameter is in quotes (`"$*"`), it produces a single string.

The `-n` parameter right before test that this string is non-zero, or within this use case, if a unique commit message was passed with the script. If a message was, then the commit message gets saved in the `message` variable that originally stored the default commit message.

```
    git commit -m "$message"
    git push origin main
```
The commit is created with the files staged with `git add .` and the message stored in `message`. The comit is pushed to the remote `linuxnoob.git` GitHub repository's main branch.

The `linuxnoob.git` repository now reflects the current state of the site, meaning the hosted site on `ebribi.github.io/linuxnoob/` is also updated. I could be done here, but I'd like for the entire Hugo project source code to be tracked in the `linuxblog.git` repository as well.

```
    cd ... 
    echo "Backing up source..."
    git add .
    git commit -m "$message"
    git push origin main
    
    echo "Complete."
```
The script moves back to the project's root directory, stages all changes, creates a commit with the same message as before, and pushes this to the `linuxblog.git` repository that is the remote repo for the project's source code.

Barring any errors along the way, both repositories have now been updated with the changes to the site and the source code.

*More to come...*
