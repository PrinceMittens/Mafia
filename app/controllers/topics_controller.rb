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
    redirect_to '/game/' + this_topic_id
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
    redirect_to root_path
  end
  
  
  
  def delete
    
  end
  
  def edit
    
  end
end
