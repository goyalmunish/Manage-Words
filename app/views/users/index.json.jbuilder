json.data do
  json.array!(@users) do |user|
    json.type "users"
    json.id user.id
    json.attributes do
      json.extract! user, :first_name, :last_name, :email, :type, :provider, :uid, :additional_info, :authentication_token, :created_at, :updated_at
      json.url user_url(user, format: :json)
    end
  end
end
