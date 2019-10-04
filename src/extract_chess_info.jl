#!/usr/bin/env julia

import DataFrames: DataFrame
import CSV
import Fire: @main
using DataFramesMeta


@main function exec(raw_csv::AbstractString)
  df = DataFrame(CSV.read(raw_csv))
  res = filter(i -> chess_data(i), df)
  fixed = @byrow! res :title = replace(:title, "Wikipedia: " => "")
  fixed2 = @byrow! fixed :title = replace(:title, r" \((.*)\)" => "")
  CSV.write("../data/chess.csv", fixed2)
end

function chess_data(x)
  typeof(x.abstract) == String ? occursin(r" (C|c)hess(\s|\.)", x.abstract) : false
end

