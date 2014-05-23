class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
