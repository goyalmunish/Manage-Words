class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :word
      t.string :trick
      t.string :additional_info

      t.timestamps
    end
  end
end
