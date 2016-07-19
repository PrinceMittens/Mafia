class TopicsController < ApplicationController

  def create
    @topic = Topic.new
    @topic.user_id = current_user.id
    @topic.player_id = -1
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
  
  def signup
<<<<<<< HEAD
    temp_int = params[:id]
    @topic = Topic.find(temp_int)
    @topic.roster_count = @topic.roster_count + 1
    @topic.save
    player = Player.new
    player.user_id = current_user.id
    player.topic_id = temp_int
    player.is_dead = false
    player.save
    if @topic.player_id == -1
      # @topic.player_id =
    else
      tmp_p_id = @topic.player_id
      while tmp_p_id != -1
        tmp_p_id = Player.find(tmp_p_id).id
      end
      tmp_p = Player.find(tmp_p_id)
      # tmp_p.next_player_id = 
    end
=======
    @topic = Topic.find(params[:id])
    @topic.roster_count += 1
    @topic.save
>>>>>>> 04f5b6b861bd6f81d7b39a7b02c055437951629d
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
