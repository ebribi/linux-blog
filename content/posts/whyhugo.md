+++
date = '2025-10-04T18:34:18-04:00'
title = 'Why Hugo (and a little bash script to make deploying easier...)'
+++

I wanted a fast, simple way to get this blog up and running. I also wanted to learn how I can host a site on GitHub since I 1) knew it was possible and 2) had never gotten the chance to do it.

## Hugo vs. Jekyll and GitHub Pages

From what I read, Jeykll is the native, go-to option for hosting static sites on GitHub Pages. I opted for Hugo instead because it would be less automated and force me to get familiar with using git locally.

I created 2 repositories in my GitHub: [one](https://github.com/ebribi/linux-blog) to store my source code, and [the other](https://github.com/ebribi/linuxnoob) to deploy the site.

### Lesson #1 - You only get 1 .github.io

And it must be your username. For me, this is ebribi.github.io. I restarted this project 3-4 times because I named the repository linuxnoob.github.io thinking that I could .github.io to my heart's desire. Sadly, you can't. So instead, the base URL is ebribi.github.io/linuxnoob. Any other sites I host with GitHub Pages that isn't ebribi.github.io will have a base URL of ebribi.github.io/[repo-name]. 

## Setting Up

I decided to use the [Xmin](https://xmin.yihui.org/) theme. Clean, simple. Good documentation, especially in the creator's [blogdown book](https://bookdown.org/yihui/blogdown/hugo.html).

*More to come...*
