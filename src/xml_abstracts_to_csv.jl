import Fire: @main

function convert(xmlfile::AbstractString, csvfile::AbstractString = "wiki_abstracts.csv")
    out = open(csvfile, "w")
    instream = open(xmlfile, "r")
    write(out, "title,abstract")
    for i = 1:1000
        write(out, get_pair(instream))
    end
    close(out)
    close(instream)
end

function get_pair(stream)
    while !eof(stream)
        if readline(stream) === "<doc>"
            break
        end
    end
    title = match(r"<title>(.*)</title>", readline(stream))[1]
    abstct = match(r"<abstract>(.*)</abstract>", readline(stream))[1]
    return "$title,$abstract"
end



