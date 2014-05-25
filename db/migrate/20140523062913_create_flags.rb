class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :name, :limit => 5, :null => false
      t.integer :value, :null => false
      t.string :desc, :limit => 100

      t.timestamps
    end
    add_index(:flags, [:name, :value], unique: true)
  end
end
