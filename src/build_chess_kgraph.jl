using CSV, DataFrames, DataFramesMeta

df = DataFrame(CSV.read("data/chess.csv"))

x = let x = Dict{String, String}()
  @byrow! df begin
    x[:title] = :abstract
  end
  x
end
