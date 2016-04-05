json.data do
  json.array!(@words) do |word|
    json.type "words"
    json.id word.id
    json.attributes do
      json.extract! word, :word, :trick, :additional_info, :created_at, :updated_at
      json.url flag_url(word, format: :json)
    end
  end
end
