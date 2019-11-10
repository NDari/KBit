using CSV, DataFrames, DataFramesMeta

df = DataFrame(CSV.read("data/chess.csv"))
keys = Dict{String, Array{String, 1}}()
for i in df.title
    s = replace(i, r" \(.*\)" => "")
    res = @where df occursin.(s, :abstract)
    res2 = @byrow! res :title = replace(:title, r" \(.*\)" => "")
    keys[s] = String.(res2.title)
end

x = let x = Dict{String, String}()
    @byrow! df begin
        x[:title] = :abstract
    end
    x
end
