class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :limit => 15, :null => false
      t.string :last_name, :limit => 15, :null => false
      t.string :type
      t.string :provider
      t.string :uid
      t.string :additional_info, :limit => 100, :null => true

      t.timestamps
    end
  end
end
