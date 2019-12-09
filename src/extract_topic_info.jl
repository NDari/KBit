import DataFrames: DataFrame
import CSV
import Fire: @main
import DataFramesMeta: @where, @byrow!, @newcol
import Languages


@main function exec(raw_csv::AbstractString)
  df = DataFrame(CSV.read(raw_csv))
  res = @where df topic_data.(:abstract)
  CSV.write("data/cancer.csv", res)
end

function topic_data(x)
    typeof(x) == String ? occursin(r" [Cc]ancer[\s\.]", x) : false
end

function remove_stop_words(abstrct, stop_words)
    # df.stop_words_removed = join.(filter.(w -> !(lowercase.(w) in stop_words), split.(df.abstract)), " ")
    join(filter(w -> ∉(w, stop_words), split(abstrct)), " ")
end


