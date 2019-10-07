#!/usr/bin/env julia

import DataFrames: DataFrame
import CSV
import Fire: @main
using DataFramesMeta


@main function exec(raw_csv::AbstractString)
  df = DataFrame(CSV.read(raw_csv))
  res = @where df chess_data.(:abstract)
  fixed = @byrow! res :title = replace(:title, "Wikipedia: " => "")
  CSV.write("../data/chess.csv", fixed)
end

function chess_data(x)
  typeof(x) == String ? occursin(r" (C|c)hess(\s|\.)", x) : false
end

