class Player < ApplicationRecord
  belongs_to :User
  belongs_to :Player
end
