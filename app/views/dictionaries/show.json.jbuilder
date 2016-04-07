json.data do
  record = @dictionary
  json.type record.class.base_class.to_s.downcase
  json.partial! 'dictionary', record: record
end
