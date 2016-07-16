class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
end
