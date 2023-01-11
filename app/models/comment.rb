class Comment < ApplicationRecord
    validates :body, length: {maximum: 3000, too_long: "3000 characters is the maximum allowed."}
    belongs_to :post
    belongs_to :user
end
