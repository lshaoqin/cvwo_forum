class PostValidation < ActiveRecord::Migration[7.0]
  def change
    #Increase character limit of body to 30000 from 255
    change_column(:posts, :body, :text)
    #Prevent title field from being empty
    change_column_null(:posts, :title, false)
  end
end
