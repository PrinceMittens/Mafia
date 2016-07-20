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
    temp_int = params[:id]
    @topic = Topic.find(temp_int)
    @topic.roster_count += 1
    new_player = Player.new
    new_player.user_id = current_user.id.to_i
    new_player.player_email = User.find(new_player.user_id).email
    new_player.prev_player_id = new_player.next_player_id = -1
    new_player.topic_id = temp_int
    new_player.is_dead = false
    #set new player to head (@topic.player_id) if first new player
    if @topic.last_registered_player_id == -1
      @topic.player_id = @topic.last_registered_player_id = new_player.user_id
    else
      curr_last = Player.find(@topic.last_registered_player_id)
      curr_last.next_player_id = new_player.user_id
      new_player.prev_player_id = curr_last.user_id
      @topic.last_registered_player_id = new_player.user_id
      curr_last.save
    end
    @topic.save
    new_player.save
    redirect_to root_path
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
  end
  
  
  
  def delete
    
  end
  
  def edit
    
  end
end
