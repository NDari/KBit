import TranscodingStreams: TranscodingStream
import CodecBzip2: Bzip2Decompressor
import Mmap: mmap
import ProgressMeter: @showprogress
import Lazy: @>

function extract(file)
    fs = mmap(open(file))
    stream = TranscodingStream(Bzip2Decompressor(), IOBuffer(fs))
    @showprogress for i = 1:1000000
        extract_page(stream)
    end
    close(stream)
end

function extract_text(stream)
    nf = ""
    title = ""
    title_regex = r"<title>(.*)</title>"
    while !eof(stream)
        line = readline(stream)
        if !occursin(title_regex, line)
            continue
        else
            title = match(title_regex, line)[1]
            nf *= "# " * replace(title, r"/| " => "_") * "\n"
            break
        end
    end
    text_regex = r"<text xml:space=\"preserve\">"
    text_found = false
    page_end = r"</page>"
    while !eof(stream)
        line = readline(stream)
        if occursin(page_end, line)
            return "", ""
        end
        if !text_found
            if !occursin(text_regex, line)
            else
                text_found = true
            end
            continue
        else
            if occursin(r"</text>", line)
                nf *= replace(line, r"</text>" => "") * "\n"
                break
            end
            nf *= line * "\n"
        end
    end
    while !eof(stream)
        line = readline(stream)
        if occursin(page_end, line)
            break
        end
    end
    return title, nf
end

function clean_text(nf)
    @> nf begin
        replace(r"{{(.*)}}" => "")
        replace(r"\[\[(.*):(.*)\]\]" => "")
        replace(r"'''(.*?)'''" => s"**\1**")
        replace(r"''(.*?)''" => s"*\1*")
        replace(r"\n====\s?(.*)====\n" => s"\n#### \1\n")
        replace(r"\n===\s?(.*)===\n" => s"\n### \1\n")
        replace(r"\n==\s?(.*)==\n" => s"\n## \1\n")
    end
end




