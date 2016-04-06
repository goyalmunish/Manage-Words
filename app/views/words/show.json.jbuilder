json.data do
  record = @word
  json.type record.class.base_class.to_s.downcase
  json.partial! 'word', record: record
end
