json.array!(@app_settings) do |app_setting|
  json.extract! app_setting, :id, :key, :value
  json.url app_setting_url(app_setting, format: :json)
end
