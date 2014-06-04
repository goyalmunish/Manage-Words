class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :name, :limit => 25, :null => false, :unique => true
      t.string :url, :limit => 150, :null => false
      t.string :separator, :limit => 5, :null => false
      t.string :suffix, :limit => 25
      t.string :additional_info, :limit => 250

      t.timestamps
    end
    add_index(:dictionaries, :name, unique: true)
  end
end
