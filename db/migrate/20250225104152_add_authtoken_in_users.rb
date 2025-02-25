class AddAuthtokenInUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :authtoken, :string
    add_index :users, :authtoken, unique: true
  end
end
