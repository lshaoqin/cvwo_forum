class TagValidation < ActiveRecord::Migration[7.0]
  def change
    #Prevent all fields from being empty
    change_column_null(:tags, :post_id, false)
    change_column_null(:tags, :user_id, false)
    change_column_null(:tags, :name, false)
    change_column_null(:tags, :weight, false)

    #Limit number of characters in tag
    change_column :tags, :name, :string, limit: 16
  end
end
