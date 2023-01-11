class Post < ApplicationRecord
    validates :title, presence: true
    validates :title, length: {maximum: 120, too_long: "120 characters is the maximum allowed."}
    validates :body, length: {maximum: 3000, too_long: "3000 characters is the maximum allowed."}
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :tags, dependent: :destroy
end
