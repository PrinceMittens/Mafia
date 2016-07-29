class Topic < ApplicationRecord
    belongs_to :User
    serialize :player_list
    has_many :Posts,  dependent: :destroy
    has_many :Players
    
    
    # Adds a player to the player list of this topic
    # Takes as parameter the user id of the user being added
    # no return value

    def create_player curr_user_id
        curr_user = User.find(curr_user_id)
        new_player = Player.new
        new_player.player_name = curr_user.name
        new_player.user_id = curr_user_id
        new_player.player_email = User.find(new_player.user_id).email
        new_player.prev_player_id = new_player.next_player_id = -1
        new_player.topic_id = self.id
        new_player.is_dead = false
        new_player.save
        #set new player to head if first new player
        if self.last_registered_player_id == -1
          self.player_id = self.last_registered_player_id = new_player.id
        else
          if self.has_user(curr_user_id)
            puts 'error: this function should not even be accessible'
            return
          end
          curr_last = Player.find(self.last_registered_player_id)
          curr_last.next_player_id = new_player.id
          new_player.prev_player_id = curr_last.id
          self.last_registered_player_id = new_player.id
          curr_last.save
        end
        self.roster_count += 1
        self.save
        new_player.save
        return
    end

    # returns player object associated with the given user id
    # returns nil if no player with that user iD
    # only returns non-nil if the user is a player of the game (not mod or anyone else)
    # takes as a parameter user id
    
    def find_player_by_user(user_id)
        if self.user_id == user_id
            # This is the mod
            return nil
        end
        last_registered_player_id = self.last_registered_player_id.to_i
        if last_registered_player_id == -1
            # no users in this game, return as appropriate
            return nil
        end
        while last_registered_player_id != -1
            curr_player = Player.find(last_registered_player_id)
            if curr_player.user_id == user_id
                return curr_player
            end
            last_registered_player_id = curr_player.prev_player_id
        end
        # search failed to find player in the player list
        return nil
    end

    # returns viewing permission based on user_id
    # returns 0 for mafia, 1 for town, 2 for mod
    # add more as necessary
    # returns -1 for everyone else
    # takes user ID as a parameter
    def user_permission(user_id)
        if self.user_id == user_id
            # This is the mod
            return 2
        end
        last_registered_player_id = self.last_registered_player_id.to_i
        if last_registered_player_id == -1
            # no users in this game, return -1 as generic viewership permission
            return -1
        end
        while last_registered_player_id != -1
            curr_player = Player.find(last_registered_player_id)
            if curr_player.user_id == user_id
                if curr_player.affiliation == nil
                    return -1
                elsif curr_player.affiliation == 0
                    return 0
                elsif curr_player.affiliation == 1
                    return 1
                end
            end
            last_registered_player_id = curr_player.prev_player_id
        end
        # search failed to find player in the player list
        return -1
    end
    # takes as parameter a user id (not player id)
    # checks if any of the current list of players
    # associated with the game contains the specified user id
    # return true (player already signed up or is associated with the game)
    # or returns nil (player unassociated with game)

    def has_user(user_id)
        if self.user_id == user_id
            puts 'You are the mod!'
            return false
        end
        last_registered_player_id = self.last_registered_player_id.to_i
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
    # returns the player object
    # returns nil if index is nonexistent, meaning no players in game yet
    # you may get errors if this returns nil, like going to admin page when existing games have no players

    def player_last_index(index = 0)
        temp_id = self.last_registered_player_id
        if temp_id == -1 || temp_id == nil
            #if no one is signed up
            return nil
        elsif index > self.roster_count - 1
            #if trying to find a nonexistent index
            return nil
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
    
    # function for searching through the roster
    # takes a player ID value as a parameter
    # returns the player object
    # returns nil if index is nonexistent, meaning no players in game yet

    def player_search_id(player_id)
        temp_id = self.last_registered_player_id
        while temp_id != player_id && temp_id != -1 && temp_id != nil
            temp_id = Player.find(temp_id).prev_player_id
        end
        if temp_id == player_id
           return Player.find(temp_id)
        end
        return nil
    end
    
    # pass the correct player ID to be deleted
    #return 1 on success, and -1 on fail
    def del_player(player_id_to_del = 0)
        curr_id = self.last_registered_player_id
        if curr_id == nil
            return -2
        end
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
                    return 1
                elsif prev_p_id == -1
                    # if the id is of the first player but there are more than 1 players
                    self.player_id = next_p_id
                    self.roster_count -= 1
                    self.save
                    next_player = Player.find(next_p_id)
                    next_player.prev_player_id = -1
                    the_player.destroy
                    next_player.save
                    return 1
                elsif next_p_id == -1 
                    # if the id is of the last player but there are more than 1 players
                    prev_player = Player.find(prev_p_id)
                    prev_player.next_player_id = -1
                    self.last_registered_player_id = prev_p_id
                    self.roster_count -= 1
                    self.save
                    prev_player.save
                    the_player.destroy
                    return 1
                else
                    #if the id is of a player nested between two other players
                    self.roster_count -= 1
                    prev_player = Player.find(prev_p_id)
                    next_player = Player.find(next_p_id)
                    prev_player.next_player_id = next_p_id
                    next_player.prev_player_id = prev_p_id
                    the_player.destroy
                    self.save
                    prev_player.save
                    next_player.save
                    return 1
                end
            end
            curr_id = the_player.prev_player_id
        end
        return -1
    end

# The following are day/night phase timer functions
# Each function takes a day_timelimit or night_timelimit
# argument, which is a variable of a Topic object

    # returns the day_timelimit as a string
    def day_length day_timelimit
        case day_timelimit
        when 1
            return "336 hours (2 weeks)"
        when 2
            return "168 hours (1 week)"
        when 3
            return "120 hours (5 days)"
        when 4
            return "72 hours (3 days)"
        when 5
            return "48 hours (2 days)"
        when 6
            return "24 hours (1 day)"
        when 7
            return "12 hours"
        when 8
            return "6 hours"
        when 9
            return "3 hours"
        when 10
            return "2 hours"
        when 11
            return "1 hour"
        when 12
            return "30 minutes"
        when 13
            return "15 minutes"
        when 14
            return "10 minutes"
        when 15
            return "5 minutes"
        else
            return "Error"
        end
    end
    
    # returns the night_timelimit as a string
    def night_length night_timelimit
        case day_timelimit
        when 1
            return "336 hours (2 weeks)"
        when 2
            return "168 hours (1 week)"
        when 3
            return "120 hours (5 days)"
        when 4
            return "72 hours (3 days)"
        when 5
            return "48 hours (2 days)"
        when 6
            return "24 hours (1 day)"
        when 7
            return "12 hours"
        when 8
            return "6 hours"
        when 9
            return "3 hours"
        when 10
            return "2 hours"
        when 11
            return "1 hour"
        when 12
            return "30 minutes"
        when 13
            return "15 minutes"
        when 14
            return "10 minutes"
        when 15
            return "5 minutes"
        else
            return "Error"
        end
    end

    # returns the day time limit in seconds
    def day_in_secs day_timelimit
        case day_timelimit
        when 1
            return 1209600
        when 2
            return 604800
        when 3
            return 432000
        when 4
            return 259200
        when 5
            return 172800
        when 6
            return 86400
        when 7
            return 43200
        when 8
            return 21600
        when 9
            return 10800
        when 10
            return 7200
        when 11
            return 3600
        when 12
            return 1800
        when 13
            return 900
        when 14
            return 600
        when 15
            return 300
        else
            return -1
        end
    end

    #returns the night time limit in seconds
    def night_in_secs night_timelimit
        case night_timelimit
        when 1
            return 1209600
        when 2
            return 604800
        when 3
            return 432000
        when 4
            return 259200
        when 5
            return 172800
        when 6
            return 86400
        when 7
            return 43200
        when 8
            return 21600
        when 9
            return 10800
        when 10
            return 7200
        when 11
            return 3600
        when 12
            return 1800
        when 13
            return 900
        when 14
            return 600
        when 15
            return 300
        else
            return -1
        end
    end
end
