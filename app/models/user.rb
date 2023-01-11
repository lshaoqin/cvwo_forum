class User < ApplicationRecord
    has_secure_password
    validates :name, presence: true
    validates :password_digest, presence: true
    validates :name, length: {maximum: 16, too_long: "16 characters is the maximum allowed."}
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
end
