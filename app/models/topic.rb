class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
    has_many :Players
  
    # function for searching through the roster by index from latest player
    # returns -1 if index is nonexistent, meaning no players in game yet
    def player_last_index(index = 0)
        temp_id = self.last_registered_player_id
        if temp_id == -1 || temp_id == nil
            return -1
        else
          count = 0
          while count < index
              next_id = Player.find(temp_id).prev_player_id
              if next_id == -1
                  break
              end
              temp_id = next_id
              count += 1
          end
          return Player.find(temp_id)
        end
    end
end
