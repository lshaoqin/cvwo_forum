class CommentValidation < ActiveRecord::Migration[7.0]
  def change
    #Increase character limit of body to 30000 from 255
    change_column(:comments, :body, :text)
    #Prevent body from being empty
    change_column_null(:comments, :body, false)
  end
end
