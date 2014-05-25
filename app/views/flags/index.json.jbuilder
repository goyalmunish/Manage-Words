json.array!(@flags) do |flag|
  json.extract! flag, :id, :name, :value, :desc
  json.url flag_url(flag, format: :json)
end
