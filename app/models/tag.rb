class Tag < ApplicationRecord
    validates :name, presence: true
    validates :weight, presence: true
    validates :name, length: {maximum: 16, too_long: "16 characters is the maximum allowed."}
    belongs_to :user
    belongs_to :post
end
