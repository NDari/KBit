import TranscodingStreams: TranscodingStream
import CodecBzip2: Bzip2Decompressor
import Mmap: mmap

function extract(file)
    fs = mmap(open(file))
    stream = TranscodingStream(Bzip2Decompressor(), IOBuffer(fs))
    nf = extract_page(stream)
    println(nf)
    close(stream)
end

function extract_page(stream)
    nf = "<mediawiki>\n"
    page_found = false
    title_regex = r"<title>(.*)</title>"
    title = nothing
    for line in eachline(stream)
        if page_found
            if occursin(title_regex, line)
                title = match(title_regex, line)[1]
            end
            if occursin(r"</page>", line)
                nf *= line * "\n"
                break
            end
            nf *= line * "\n"
            continue
        end
        if !page_found && occursin(r"<page>", line)
            nf *= line * "\n"
            page_found = true
        end
    end
    nf *= "</mediawiki>"
    f = open("./data/$title.xml", "w")
    write(f, nf)
    close(f)
end




