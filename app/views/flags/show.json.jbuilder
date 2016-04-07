json.data do
  record = @flag
  json.type record.class.base_class.to_s.downcase
  json.partial! 'flag', record: record
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
json.included do
  json.partial! 'words/words', records: @flag.words
end
