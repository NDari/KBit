module KBit

import JuliaDB


function main(query::String)
	# db = JuliaDB.loadtable("data/wikipedia_extracted_abstracts_700000.csv")
  #= df = DataFrame(CSV.read("/Users/naseerdari/Projects/Julia/KBit/data/wikipedia_extracted_abstracts_700000.csv")) =#
  db = JuliaDB.load("/Users/naseerdari/Projects/Julia/KBit/data/wiki.db")
  res = filter(i -> occursin(query, i.abstract), db)
  for i in res
    println()
    println(i.abstract)
  end
end

function save_wiki_data()
  df = JuliaDB.loadtable("/Users/naseerdari/Projects/Julia/KBit/data/wikipedia_extracted_abstracts_700000.csv")
  JuliaDB.save(df, "/Users/naseerdari/Projects/Julia/KBit/data/wiki.db")
end

end # module
