class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
    has_many :Players
  
    # function for searching through the roster by index from latest player
    def player_last_index(index = 0)
        count = 0
        tmp_id = self.last_registered_player_id
        while count < index
            next_id = Player.find(tmp_id).prev_player_id
            if next_id == -1
                break
            end
            tmp_id = next_id
            count += 1
        end
        return Player.find(tmp_id)
    end
end
