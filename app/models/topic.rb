class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
    has_many :Players
    
    # Check if user is the mod or already in roster 
    # returns true if user already in
    def has_user(user_search)
        if self.user_id == user_search
            puts 'You are the mod!'
            return true
        end
        id_search = self.last_registered_player_id
        if id_search == nil
            puts "temp_id should not be nil"
            return false
        end
        while id_search != -1
            p_search = Player.find(id_search)
            if p_search.user_id == user_search
                return true
            end
            id_search = p_search.prev_player_id
        end
        return false
    end
    
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
