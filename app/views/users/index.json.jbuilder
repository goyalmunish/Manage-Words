json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :type, :provider, :uid, :additional_info
  json.url user_url(user, format: :json)
end
