class UserBlankCheck < ActiveRecord::Migration[7.0]
  def change
    validates :users, :name, presence: true
  end
end
