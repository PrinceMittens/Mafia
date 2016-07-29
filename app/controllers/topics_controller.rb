class TopicsController < ApplicationController

  def create
    @topic = Topic.new
    @topic.user_id = current_user.id
    @topic.last_registered_player_id = @topic.player_id = -1
    @topic.title = params[:title]
    @topic.category = params[:category]
    @topic.content = params[:content]
    @topic.roster_count = 0
    @topic.phase = -1
    @topic.num_players_alive = params[:num_players_alive]
    @topic.num_mafia = params[:num_mafia]
    @towncount = @topic.num_town = params[:num_town]
    @topic.day_timelimit = params[:day_timelimit]
    @topic.night_timelimit = params[:night_timelimit]
    @topic.time_left = 0
    @topic.gameover = false
    @topic.who_won = -1
    @topic.save
    redirect_to root_path
  end
  
  def new
    @topic = Topic.new
  end
  
  # Creates player, initializes the player's values, 
  # then inserts the player onto the end of the list
  def signup
    this_topic_id = params[:id]
    this_user_id = params[:user_id]
    topic = Topic.find(this_topic_id)
    topic.create_player(this_user_id)
    redirect_to '/t/' + this_topic_id
  end
  
  # deletes player from a game, must be passed a player id
  def leave_game
    topic_id = params[:id]
    curr_topic = Topic.find(topic_id)
    curr_id = curr_topic.last_registered_player_id
    while curr_id != -1
      curr_player = Player.find(curr_id)
      if (curr_player.user_id == current_user.id)
        curr_topic.del_player(curr_player.id)
      end
      curr_id = curr_player.prev_player_id
    end
    curr_topic.save
    redirect_to '/t/' + topic_id
  end
  

  # change the phase from day to night and vice verse
  # update the phase timer
  # check if game is over
  def update_phase
    new_topic.num_players_alive = num_mafia + num_town
    if phase == 1 || phase == -1
      phase = 0
      time_left = day_timelimit
    elsif phase == 0
      phase = 1
      time_left = night_timelimit
    end
    if new_topic.num_mafia >= new_topic.num_town
      gameover = true
      who_won = 0
    elsif num_mafia == 0
      gameover = true
      who_won = 1
    # else if other win condition 
    end
    redirect_to root_path
  end
  
  
  
  def delete
    
  end
  
  def edit
    
  end

  def start_game
    topic = Topic.find(params[:id])
    topic.category = 2
    topic.phase = 1
    topic.num_players_alive = topic.num_mafia + topic.num_town
    topic.save
    
    players = Player.where(:topic_id => topic.id).shuffle
    
    mafia_count = topic.num_mafia
    
    players.each do |x|
      x.is_dead = false
      x.vote_count = 0
      x.vote_target_player_id = -1
      if mafia_count > 0
        x.affiliation = 0
        mafia_count -= 1
      else
        x.affiliation = 1
      end
      x.save
    end
      
      
    redirect_to '/t/' + params[:id]
  end
  
  
  
  ## general functions for game flow
  
  # to update player table when someone votes
  def update_vote_general player_id, topic_id, vote_target_player_id
      voting_player = Player.find(player_id)
      player_voted = Player.find(vote_target_player_id)
      topic = Topic.find(topic_id)
      
      #if vote was already cast on the target, do nothing
      if voting_player.vote_target_player_id == player_voted.id
        return
      #if vote not cast before
      elsif voting_player.vote_target_player_id == -1
        voting_player.vote_target_player_id = vote_target_player_id
        player_voted.vote_count += 1
      #if vote has already been cast on someone else
      elsif voting_player.vote_target_player_id != -1
        curr_voted = Player.find(voting_player.vote_target_player_id)
        curr_voted.vote_count -= 1
        player_voted.vote_count += 1
        voting_player.vote_target_player_id = vote_target_player_id
        curr_voted.save
      end
      player_voted.save
      voting_player.save

      phase = topic.phase
      majority = 0
      if phase == 0
          majority = topic.num_players_alive.to_i / 2 + 1
      elsif phase == 1
          majority = topic.num_mafia / 2 + 1
      end
      if voting_player.affiliation == 0
        if phase == 0
          content = voting_player.player_name + " has voted for " + player_voted.player_name
        elsif phase == 1
          content = "Mafia has selected a target"
        end
      elsif voting_player.affiliation == 1
        if phase == 0
          content = voting_player.player_name + " has voted for " + player_voted.player_name
        elsif phase == 1
          #change content based on player role here
        end
      end
      
      post_system_general(topic_id, content)
      
      if player_voted.vote_count >= majority
          content = "Majority reached"
          post_system_general(topic_id, content)
          next_phase_general(topic_id, player_voted.id)
      end
  end
  
  # to move to the next phase
  def next_phase_general topic_id, vote_result
      game = Topic.find(topic_id)
      game.phase = (game.phase + 1) % 2       # change phase 0->1 or 1->0

      dead_player = Player.find(vote_result)
      dead_player.is_dead = true
      dead_player.save
      
      game.num_players_alive = game.num_players_alive - 1               # keep track of number of remaining players

      if dead_player.affiliation == 0          # going to day phase
          game.num_mafia = game.num_mafia - 1   # one town killed
      elsif dead_player.affiliation == 1        # going to night phase 
          game.num_town = game.num_town - 1
      end
      game.save
      
      
      content = "Player " + User.find(dead_player.user_id).name + " died. End of phase, changed to " + game.phase.to_s + ". Number of mafia: " + game.num_mafia.to_s + ". Number of town: " + game.num_town.to_s + "."
      post_system_general(topic_id, content)
      
      game_players = Player.where(:topic_id => topic_id, :is_dead => false)
      game_players.each do |player|
           player.vote_count = 0
           player.vote_target_player_id = -1
           player.save
      end
      
      if game.num_town <= game.num_mafia
          game_end_general(topic_id, 0)
      elsif game.num_mafia == 0
          game_end_general(topic_id, 1)
      end
      
      
  end
  
  def game_end_general topic_id, who_won
      topic = Topic.find(topic_id)
      topic.who_won = who_won
      topic.category = 3
      topic.save
      if who_won == 1
          content = "The game has ended! Town won"
      elsif who_won == 0
          content = "The game has ended! Mafia won"
      end
      post_system_general(topic_id, content)
      
  end
  
  def post_system_general topic_id, content
    topic = Topic.find(topic_id)
    user_id = topic.user_id
    new_post = Post.create_post(topic_id, content, user_id)
    if new_post.content != nil
      new_post.save
    end
  end
  
      
  # call from view
  def create_player
      addplayer_general(params[:topic_id], params[:user_id])
      redirect_to admin_path
  end
  
  def delete_player
      player_id = params[:id]
      player_to_del = Player.find(player_id)
      topic = Topic.find(player_to_del.topic_id)
      if topic.del_player(player_to_del.id) == -1
        ERROR GARBAGE STUFF
      end
      redirect_to admin_path
  end
  
  def vote
      update_vote_general(params[:player_id], params[:topic_id], params[:vote_target_player_id])
      redirect_to '/t/' + params[:topic_id]
  end
end