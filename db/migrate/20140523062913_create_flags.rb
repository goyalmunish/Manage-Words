class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :name, :limit => 25, :null => false
      t.string :desc, :limit => 100, :null => true

      t.timestamps
    end
    add_index(:flags, :name, unique: true)
  end
end
