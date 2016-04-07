json.data do
  record = @flag
  json.type record.class.base_class.to_s.downcase
  json.partial! 'flag', record: record
end
