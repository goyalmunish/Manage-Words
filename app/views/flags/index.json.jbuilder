json.data do
  json.array!(@flags) do |flag|
    json.type "flags"
    json.id flag.id
    json.attributes do
      json.extract! flag, :name, :value, :desc, :created_at, :updated_at
      json.url flag_url(flag, format: :json)
    end
  end
end
