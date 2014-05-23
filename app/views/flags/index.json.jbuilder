json.array!(@flags) do |flag|
  json.extract! flag, :id, :name, :desc, :user_id
  json.url flag_url(flag, format: :json)
end
