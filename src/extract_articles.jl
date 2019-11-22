import TranscodingStreams: TranscodingStream
import CodecBzip2: Bzip2Decompressor
import Mmap: mmap
import ProgressMeter: @showprogress

function extract(file)
    fs = mmap(open(file))
    stream = TranscodingStream(Bzip2Decompressor(), IOBuffer(fs))
    @showprogress for i = 1:1000000
        extract_page(stream)
    end
    close(stream)
end

function extract_page(stream)
    nf = ""
    text_found = false
    text_regex = r"<text xml:space=\"preserve\">"
    title_regex = r"<title>(.*)</title>"
    for line in eachline(stream)
        if !text_found
            if occursin(text_regex, line)
                nf *= replace(line, text_regex => "") * "\n"
                text_found = true
            end
            if occursin(title_regex, line)
                title = match(title_regex, line)[1]
                nf *= "# " * replace(title, r"/| " => "_") * "\n"
            end
            continue
        end
        if occursin(r"</text>", line)
            nf *= replace(line, r"</text>" => "") * "\n"
            break
        end
        nf *= line * "\n"
    end
    return nf
end


# function par_extract_page(mmap_file)
#     chunck_size = length(mmap_file) ÷ nthreads()
#     idx_start = threadid() === 1 ? 1 : chunck_size * (threadid() - 1)
#     idx_end = threadid() === nthreads() ? length(mmap_file) : chunck_size * threadid()
#     stream = TranscodingStream(Bzip2Decompressor(), IOBuffer(fs[idx_start:idx_end]))
#     nf = "<mediawiki>\n"
#     page_found = false
#     title_regex = r"<title>(.*)</title>"
#     title = nothing
#     for line in eachline(stream)
#         if page_found
#             if occursin(title_regex, line)
#                 title = match(title_regex, line)[1]
#             end
#             if occursin(r"</page>", line)
#                 nf *= line * "\n"
#                 break
#             end
#             nf *= line * "\n"
#             continue
#         end
#         if !page_found && occursin(r"<page>", line)
#             nf *= line * "\n"
#             page_found = true
#         end
#     end
#     nf *= "</mediawiki>"
#     f = open("./data/$title.xml", "w")
#     write(f, nf)
#     close(f)
# end



