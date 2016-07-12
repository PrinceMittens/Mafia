class Topic < ApplicationRecord
    belongs_to :User
    has_many :Posts,  dependent: :destroy
end
