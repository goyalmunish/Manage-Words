json.data do
  json.array!(@dictionaries) do |dictionary|
    json.type "dictionaries"
    json.id dictionary.id
    json.attributes do
      json.extract! dictionary, :name, :url, :separator, :suffix, :additional_info, :created_at, :updated_at
      json.url dictionary_url(dictionary, format: :json)
    end
  end
end
