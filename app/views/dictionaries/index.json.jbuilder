json.array!(@dictionaries) do |dictionary|
  json.extract! dictionary, :id, :name, :url, :separator, :suffix, :additional_info
  json.url dictionary_url(dictionary, format: :json)
end
