#!/usr/bin/env julia

import JuliaDB
import Fire: @main


@main function main(query::AbstractString, database::AbstractString="wiki_abstracts")
  db = JuliaDB.load(ENV["HOME"] * "/.kbit/data/$database.jdb")
  res = filter(i -> occursin(query, i.abstract), db)
  for i in res
    println()
    println(i.abstract)
  end
end

function save_wiki_abstracts_data()
  df = JuliaDB.loadtable(ENV["HOME"] * "/data/extracted_data.csv")
  JuliaDB.save(df, ENV["HOME"] * "/.kbit/data/wiki_abstracts.jdb")
end

function save_wiki_article_sample_data()
  df = JuliaDB.loadtable(ENV["HOME"] * "/Downloads/wiki_articles.json")
  JuliaDB.save(df, ENV["HOME"] * "/.kbit/data/wiki_abstracts.jdb")
end
