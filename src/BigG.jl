module BigG

using Markdown
using Mustache
using Dates
import YAML

export render_all

function render_all(md_Dir, output_Dir, post_Tpl, index_Tpl; head_path="")
    # atm we're only using these infos
    titles = []
    dates = []
    slugs = []
    experts = []

    htmls = []
    head_injection = try
        read(head_path) |> String
    catch
        ""
    end

    post_tpl = read(post_Tpl) |> String
    index_tpl = read(index_Tpl) |> String

    for md_File in readdir(md_Dir)
        if !endswith(md_File, ".md")
            continue
        end
        front_text, body_text = front_body("$md_Dir/$md_File")
        front_matter = YAML.load(front_text)
        try
            front_matter["draft"] == true && continue
        catch
        end

        html_txt = body_text |> Markdown.parse |> html
        render_dict = merge(front_matter, Dict("content" => html_txt,
                                            "head_injection" => head_injection
                                            )
                            )
        push!(htmls, render(post_tpl, render_dict))

        try
            push!(titles, front_matter["title"])
            push!(slugs, front_matter["slug"])
            push!(dates, front_matter["date_published"])
        catch
        end

    end

    order = sortperm(dates, rev=true)
    for i in order
        pub_day = dates[i]
        Y, M, D = pub_day |> year, pub_day |> month, pub_day |> day
        dest_Dir = output_Dir * "/$Y/$M/$D/"
        ispath(dest_Dir) || mkpath(dest_Dir)
        slugs[i] = dest_Dir * slugs[i]
        open("$(slugs[i]).html", "w") do f
            write(f, htmls[i])
        end
    end

    posts = [Dict("slug" => relpath(slugs[i], output_Dir)*".html", "title" => titles[i]) for i in order]
    open("$output_Dir/index.html", "w") do f
        write(f, render(index_tpl, posts=posts))
    end

end

function front_body(mdpath)
    # split out front matter and body of a .md file
    rawmd = readlines(mdpath)
    return get_front(rawmd), get_body(rawmd)
end

function get_front(rawmd)
    # split out front matter of .md lines
    front_lines = findall(x->x=="---", rawmd)
    front_text = rawmd[front_lines[1]+1:front_lines[2]-1]
    front_text = join(front_text, "\n")
    return front_text
end

function get_body(rawmd)
    # split out body of a .md lines
    front_lines = findall(x->x=="---", rawmd)
    body_text = rawmd[front_lines[2]+1:end]
    body_text = join(body_text, "\n")
    return body_text
end

# module
end
