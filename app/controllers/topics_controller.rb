class TopicsController < ApplicationController

  def create
    new_topic = Topic.new
    new_topic.user_id = current_user.id
    new_topic.title = params[:title]
    new_topic.category = params[:category]
    new_topic.content = params[:content]
    new_topic.roster_count = params[:roster_count]
    new_topic.phase = -1
    new_topic.num_players_alive = params[:num_players_alive]
    new_topic.num_mafia = params[:num_mafia]
    @towncount = new_topic.num_town = params[:num_town]
    new_topic.day_timelimit = params[:day_timelimit]
    new_topic.night_timelimit = params[:night_timelimit]
    new_topic.time_left = 0
    new_topic.gameover = false
    new_topic.who_won = -1
    new_topic.save
    redirect_to root_path
  end
  
  
  def signup
    new_topic.player_list = 4
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
