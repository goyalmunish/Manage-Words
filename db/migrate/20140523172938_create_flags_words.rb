class CreateFlagsWords < ActiveRecord::Migration
  def change
    create_table :flags_words, :id => false do |t|
      t.belongs_to :word
      t.belongs_to :flag
    end
    add_index(:flags_words, [:word_id, :flag_id], unique: true)
  end
end
