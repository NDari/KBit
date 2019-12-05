import DataFrames: DataFrame
import CSV
import Fire: @main
import DataFramesMeta: @where


@main function exec(raw_csv::AbstractString)
  df = DataFrame(CSV.read(raw_csv))
  res = @where df chess_data.(:abstract)
  CSV.write("data/chess.csv", res)
end

function chess_data(x)
    typeof(x) == String ? occursin(r" [Cc]hess[\s\.]", x) : false
end

