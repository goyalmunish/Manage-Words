class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.string :key, :null => false, :unique => true
      t.string :value, :limit => 1024, :null => false

      t.timestamps
    end
    add_index(:app_settings, :key, unique: true)
  end
end
