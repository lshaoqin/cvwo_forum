class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :name
      t.integer :weight

      t.timestamps
    end
  end
end
