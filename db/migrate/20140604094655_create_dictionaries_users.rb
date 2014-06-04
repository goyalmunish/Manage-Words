class CreateDictionariesUsers < ActiveRecord::Migration
  def change
    create_table :dictionaries_users, :id => false do |t|
      t.belongs_to :user
      t.belongs_to :dictionary
    end
    add_index(:dictionaries_users, [:user_id, :dictionary_id], unique: true)
  end
end
