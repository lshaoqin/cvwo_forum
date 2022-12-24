class UserValidation < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :name, unique: true
    change_column_null(:users, :name, false)
  end
end
