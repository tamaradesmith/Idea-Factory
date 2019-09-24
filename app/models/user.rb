class User < ApplicationRecord
    has_secure_password
    has_many :ideas, dependent: :destroy
    has_many :reviews, dependent: :nullify
    
    has_many :likes, dependent: :destroy
    has_many :liked_ideas, through: :likes, source: :idea

    def full_name
        
        "#{first_name} #{last_name}".strip
    end

end
