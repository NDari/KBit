import Lazy: @>
import Fire: @main
import Mmap
import DataFrames: DataFrame!

function extract(file::AbstractString)
    fs = open(file)
    stream = IOBuffer(Mmap.mmap(fs))
    df = DataFrame!(title = String[], text = String[])
    counter = 1
    while !eof(stream)
        title, text = extract_text(stream)
        if topic_data(title)
            push!(df, (title, clean_text(text)))
            counter += 1
            if counter % 10 == 0
                println(counter)
            end
        end
    end
    close(stream)
    df
end

function extract_text(stream)::Tuple{String, String}
    nf = ""
    title = ""
    title_regex = r"<title>(.*)</title>"
    while !eof(stream)
        line = readline(stream)
        if occursin(title_regex, line)
            title = match(title_regex, line)[1]
            break
        end
    end
    text_regex = r"<text(.*)xml:space=\"preserve\">"
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
                nf *= replace(line, r"</text>" => "")
                break
            end
            nf *= line * '\n'
        end
    end
    return title, nf
end

function clean_text(nf)
    @> nf begin
        replace(r"(\*)?(\s*)?{{(.*?)}}\n?" => "")
        replace(r"\[\[(.*?):(.*?)\]\]\n?" => "")
        replace(r"\[\[(.*?)(\|.*?)?\]\]" => s"\1")
        replace(r"'''(.*?)'''" => s"\1")
        replace(r"''(.*?)''" => s"\1")
        replace(r"&quot;" => "\"")
        replace(r"&lt;" => "<")
        replace(r"&gt;" => ">")
        replace(r"&amp;" => "&")
        replace(r"&nbsp;" => " ")
        replace(r"\n+" => "\n")
        replace(r"\"" => "'")
        replace(r"<!--(.*)-->" => "\n")
    end
end

function topic_data(x)
    typeof(x) == String ? occursin(r" [Cc]hess[\s\.]", x) : false
end



