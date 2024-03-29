# BigG.jl
A minimalistic Static Site Generator in Julia
Inspired by [this post](https://blog.thea.codes/a-small-static-site-generator/).

Demo can be found [here](https://github.com/Moelf/BigG_demo)

Markdown rendering is handled by Julia `stdlib`, docs [here](https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/Markdown.html)
<!-- | **Build Status**                                                                                |
|:-----------------------------------------------------------------------------------------------:|
|[![Build Status](https://travis-ci.org/Moelf/Telegrambot.jl.svg?branch=master)](https://travis-ci.org/Moelf/Telegrambot.jl)| -->

## Installation

The package is not yet registered in `METADATA.jl` and can be installed with `Pkg.add`, or in `REPL` by pressing `]`:
```julia
pkg> add https://github.com/Moelf/BigG.jl
```

## Basic Usage
Make two folders, `source` and `output`, put all `.md` files in `source` then:

```julia
using BigG

render_posts("./source", "./output", "BigG.jl/src/post.hbs", "BigG.jl/src/head_injection.html")
render_index("./source", "./output", "BigG.jl/src/index.hbs")
```
`"BigG.jl/src/post.hbs"` is a provided template, you can change templates as you want, at the moment only `{{{content}}}`
in posts are used. Index render uses `{{#:posts}}` `{{/:posts}}` for loop and in between are `{{bname}}` and `{{title}}` for link
generation.

This will generate an `index.html` where each `.md` will be rendered into a html and
linked in the index page.

## To-Do
- [ ] Allow directory structure (year/month/date/title.html)
- [ ] Generate RSS feed
- [ ] Use a .yaml config files for website meta data (title, base domain, author, etc)
