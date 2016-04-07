json.data do
  json.array!(@words) do |record|
    json.type record.class.base_class.to_s.downcase.pluralize
    json.partial! 'words/word', record: record
    json.relationships do
      json.flags do
        json.data do
          json.array!(record.flags) do |flag|
            json.type "flags"
            json.id flag.id
          end
        end
      end
    end
  end
end
json.included do
  @words.each do |record|
    json.partial! 'flags/flags', records: record.flags
  end
end
