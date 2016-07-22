class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
    has_many :Players
    
    # takes as parameter a user id (not player id)
    # checks if any of the current list of players
    # associated with the game contains the specified user id
    # return true (player already signed up or is associated with the game)
    # or returns false (player unassociated with game)

    def has_user(user_id)
        if self.user_id == user_id
            puts 'You are the mod!'
            return true
        end
        last_registered_player_id = self.last_registered_player_id
        if last_registered_player_id == -1
            puts "No user are signed up for this game."
            return false
        end
        while last_registered_player_id != -1
            curr_player = Player.find(last_registered_player_id)
            if curr_player.user_id == user_id
                return true
            end
            last_registered_player_id = curr_player.prev_player_id
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
    
    #pass the correct player ID to be delet
    def del_player(player_id_to_del = 0)
        last_id = self.last_registered_player_id
        curr_id = last_id
        while curr_id != -1
            the_player = Player.find(curr_id)
            if curr_id == player_id_to_del
                prev_p_id = the_player.prev_player_id
                next_p_id = the_player.next_player_id
                if prev_p_id == -1 && next_p_id == -1
                    # this is the case when the id is the only one on the list
                    self.player_id = self.last_registered_player_id = -1
                    self.roster_count = 0
                    self.save
                    the_player.destroy
                elsif prev_p_id == -1
                    # if the id is of the first player but there are more than 1 players
                    self.player_id = next_p_id
                    self.roster_count -= 1
                    self.save
                    next_player = Player.find(next_p_id)
                    next_player.prev_player_id = -1
                    the_player.destroy
                    next_player.save
                elsif next_p_id == -1 
                    # if the id is of the last player but there are more than 1 players
                    prev_player = Player.find(prev_p_id)
                    prev_player.next_player_id = -1
                    self.last_registered_player_id = prev_p_id
                    self.roster_count -= 1
                    self.save
                    prev_player.save
                    the_player.destroy
                else
                    #if the id is of a player nested between two other players
                    self.roster_count -= 1
                    prev_player = Player.find(prev_p_id)
                    next_player = Player.find(next_p_id)
                    prev_player.next_player_id = next_player.player_id
                    next_player.prev_player_id = prev_player.player_id
                    the_player.destroy
                    self.save
                    prev_player.save
                    next_player.save
                end
            end
        end
    end


end
