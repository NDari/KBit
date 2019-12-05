import Fire: @main

function convert(xmlfile::AbstractString, csvfile::AbstractString = "wiki_abstracts.csv")
    out = open(csvfile, "w")
    instream = open(xmlfile, "r")
    write(out, "title,abstract\n")
    while !eof(instream)
        res = get_line(instream)
        if res === ""
            continue
        end
        write(out, res)
    end
    close(out)
    close(instream)
end

function get_line(stream)
    while !eof(stream)
        if readline(stream) === "<doc>"
            break
        end
    end
    if eof(stream)
        return ""
    end
    title = match(r"<title>Wikipedia: (.*)</title>", readline(stream))
    if title == nothing
        return ""
    end
    title = title[1]
    title = replace(title, "\"" => "'")
    abstct = match(r"<abstract>(.*)</abstract>", readline(stream))
    if abstct == nothing
        return ""
    end
    abstct = abstct[1]
    abstct = replace(abstct, "\"" => "'")
    return "\"$title\",\"$abstct\"\n"
end



