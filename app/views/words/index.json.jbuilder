json.array!(@words) do |word|
  json.extract! word, :word, :trick, :additional_info
  json.flags word.flags.map { |flag| {:name => flag.name, :value => flag.value} }
end
