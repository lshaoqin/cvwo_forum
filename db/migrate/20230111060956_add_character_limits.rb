class AddCharacterLimits < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :body, :text, limit: 3000
    change_column :posts, :title, :string, limit: 120
    change_column :comments, :body, :text, limit: 3000
    change_column :users, :name, :string, limit: 16
  end
end
