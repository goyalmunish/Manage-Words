class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :type
      t.string :provider
      t.string :uid
      t.string :additional_info

      t.timestamps
    end
  end
end
