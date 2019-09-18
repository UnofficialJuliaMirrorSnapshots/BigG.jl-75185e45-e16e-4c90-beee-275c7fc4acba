module BigG

using Markdown
using Mustache
using Dates
import YAML

export render_posts, render_index

function front_body(mdpath)
    # split out front matter and body of a .md file
    rawmd = readlines(mdpath)
    front_lines = findall(x->x=="---", rawmd)
    if length(front_lines) >= 2
        front_text = rawmd[front_lines[1]+1:front_lines[2]-1]
        front_text = join(front_text, "\n")
        body_text = rawmd[front_lines[2]+1:end]
        body_text = join(body_text, "\n")
    else
        # in case there is not front matter
        body_text = join(rawmd, "\n")
    end
    return front_text, body_text
end

function md2html(mdpath, tplpath, head_injection="")
    # render a .md file to .html using template, fill in the {{{content}}}
    front_text, body_text = front_body(mdpath)
    meta_data = YAML.load(front_text)
    html_txt = body_text |> Markdown.parse |> html

    render_data = merge(meta_data, Dict("content" => html_txt,
                                        "head_injection" => head_injection
                                        )
                        )
    tpl = read(tplpath) |> String
    return render(tpl, render_data)
end

# renders all .md files using a template from tpl path to output directory
function render_posts(md_folder, output_folder, tplpath, head_path="")
    head_injection = ""
    if head_path!=""
        head_injection = read(head_path) |> String
    end
    for md_fname in readdir(md_folder)
        if occursin(".md", md_fname)
            out_fname = replace(md_fname, "md" => "html")
            open("$output_folder/$out_fname", "w") do f
                write(f, md2html("$md_folder/$md_fname",
                                tplpath,
                                head_injection
                                )
                      )
            end
        end
    end
end

function render_index(md_folder, output_folder, tplpath)
    dates = []
    bnames = []
    titles = []
    for md_fname in readdir(md_folder)
        if md_fname == "index.html" || !occursin(".md", md_fname)
            continue
        end
        front_text, _ = front_body("$md_folder/$md_fname")
        front_matter = YAML.load(front_text)
        date, title = front_matter["date"], front_matter["title"]
        push!(dates, date)
        push!(titles, title)
        push!(bnames, replace(md_fname, ".md" => ".html"))
    end
    order = sortperm(dates, rev=true)
    posts = [Dict("bname" => bnames[i], "title" => titles[i]) for i in order]
    tpl = read(tplpath) |> String
    open("$output_folder/index.html", "w") do f
        write(f, render(tpl, posts=posts))
    end
end
end # module
