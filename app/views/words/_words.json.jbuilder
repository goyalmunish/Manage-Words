json.array!(records) do |record|
  json.type records.first.class.base_class.to_s.downcase.pluralize
  json.partial! 'words/word', record: record
end
