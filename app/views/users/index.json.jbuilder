json.data do
  json.array!(@users) do |record|
    json.type record.class.base_class.to_s.downcase.pluralize
    json.partial! 'user', record: record
    json.relationships do
      json.words do
        json.data do
          json.array!(record.words) do |word|
            json.type "words"
            json.id word.id
          end
        end
      end
      json.dictionaries do
        json.data do
          json.array!(record.dictionaries) do |dictionary|
            json.type "dictionaries"
            json.id dictionary.id
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
  @users.each do |user|
    json.partial! 'dictionaries/dictionaries', records: user.dictionaries
  end
end
