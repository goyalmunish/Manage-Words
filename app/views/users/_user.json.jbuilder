json.id record.id
json.attributes do
  json.extract! record, :first_name, :last_name, :email, :type, :provider, :uid, :additional_info, :authentication_token
  json.extract! record, :created_at, :updated_at
  json.url user_url(record, format: :json)
end
