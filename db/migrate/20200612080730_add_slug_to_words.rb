class AddSlugToWords < ActiveRecord::Migration
  def change
    add_column :words, :slug, :string
    add_index :words, :slug, unique: true
  end
end
