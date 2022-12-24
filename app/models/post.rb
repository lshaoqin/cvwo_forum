class Post < ApplicationRecord
    belongs_to :author
    has_many :comments, dependent: :destroy
    has_many :tags, dependent: :destroy
end
