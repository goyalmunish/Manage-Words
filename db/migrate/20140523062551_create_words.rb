class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :word, :limit => 25, :null => false, :unique => true
      t.string :trick, :limit => 100
      t.references :user, index: true
      t.string :additional_info, :limit => 2048

      t.timestamps
    end
    add_index(:words, [:user_id, :word], unique: true)
  end
end
