json.data do
  json.array!(@users) do |record|
    json.type record.class.base_class.to_s.downcase.pluralize
    json.id record.id
    json.attributes do
      json.extract! record, :first_name, :last_name, :email, :type, :provider, :uid, :additional_info, :authentication_token
      json.extract! record, :created_at, :updated_at
      json.url user_url(record, format: :json)
    end
    json.relationships do
      json.words do
        json.data do
          json.array!(record.words) do |word|
            json.type "words"
            json.id word.id
          end
        end
      end
    end
  end
end
json.included do
  @users.each do |user|
    json.partial! 'words/words', records: user.words
  end
end
