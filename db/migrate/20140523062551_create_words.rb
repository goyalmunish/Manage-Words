class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :word, :limit => 25, :null => false, :unique => true
      t.string :trick, :limit => 100, :null => true
      t.string :additional_info, :limit => 2048, :null => true

      t.timestamps
    end
    add_index(:words, :word, unique: true)
  end
end
