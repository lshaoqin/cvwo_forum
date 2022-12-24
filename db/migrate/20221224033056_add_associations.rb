class AddAssociations < ActiveRecord::Migration[7.0]
  #add associations and delete original columns which were meant to link one table to another
  def change
    #post > user
    remove_column :posts, :user_id, type: :integer
    add_reference :posts, :user, foreign_key: true

    #comment > post
    remove_column :comments, :post_id, type: :integer
    add_reference :comments, :post, foreign_key: true

    #comment > user
    remove_column :comments, :user_id, type: :integer
    add_reference :comments, :user, foreign_key: true

    #tag > post
    remove_column :tags, :post_id, type: :integer
    add_reference :tags, :post, foreign_key: true

    #tag > user
    remove_column :tags, :user_id, type: :integer
    add_reference :tags, :user, foreign_key: true

    
  end
end
