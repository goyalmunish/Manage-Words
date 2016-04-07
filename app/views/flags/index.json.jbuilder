json.data do
  json.array!(@flags) do |record|
    json.type record.class.base_class.to_s.downcase.pluralize
    json.partial! 'flags/flag', record: record
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
  @flags.each do |record|
    json.partial! 'words/words', records: record.words
  end
end
