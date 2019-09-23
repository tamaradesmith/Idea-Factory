class Idea < ApplicationRecord
    belongs_to :user
    
    validates(:title, presence: true, uniqueness:{case_sensitive: false})

    validates(:description, presence: true)

end
