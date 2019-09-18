using LightXML

function gen_rss(Site_title, Site_desc, Site_link)
    xdoc = XMLDocument()
    xroot = create_root(xdoc, "rss")
    set_attribute(xroot, "version", "2.0")
    channel = new_child(xroot, "channel")
    channel_title = new_child(channel, "title")
    add_text(channel_title, Site_title)
    channel_desc = new_child(channel, "description")
    add_text(channel_desc, Site_desc)
    channel_link = new_child(channel, "link")
    add_text(channel_link, Site_link)

    img = new_child(channel, "image")
    img_url = new_child(img, "url")
    add_text(img_url, "img_url")
    img_title = new_child(img, "title")
    add_text(img_title, "img_title")

    channel_lastBuilt = new_child(channel, "lastBuildDate")
    add_text(channel_lastBuilt, "last_date")
    channel_tll = new_child(channel, "tll")
    add_text(channel_tll, "60")

    for i=1:2
        it = gen_item("1", "2", "3", "4", "5" ,"6", "7")
        add_child(channel, it)
    end
    return xdoc
end

function gen_item(Title, Desc, Link, dc_creator, pubDate, media_content, content_encoded)
    xitem = new_element("item")
    title = new_child(xitem, "title")
    add_text(title, Title)
    desc = new_child(xitem, "description")
    add_text(desc, Desc)
    link = new_child(xitem, "link")
    add_text(link, Link)
    creator = new_child(xitem, "dc:creator")
    add_text(creator, dc_creator)
    pubdate = new_child(xitem, "pubDate")
    add_text(pubdate, pubDate)
    mediaontent = new_child(xitem, "media:content")
    add_text(mediaontent, media_content)
    contentencode = new_child(xitem, "content:encode")
    add_text(contentencode, content_encoded)
    return xitem

end

a = gen_rss("title", "desc", "link")
save_file(a, "f1.xml")
gen_item("1", "2", "3", "4", "5" ,"6", "7")
