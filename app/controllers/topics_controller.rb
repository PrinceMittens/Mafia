class TopicsController < ApplicationController
  
  def create
    new_topic = Topic.new
    new_topic.user_id = current_user.id
    new_topic.title = params[:title]
    new_topic.category = params[:category]
    new_topic.content = params[:content]
    if new_topic.category == 1
      new_topic.roster_count = params[:roster_count]
      new_topic.phase = params[:phase]
      new_topic.num_players_alive = params[:num_players_alive]
      new_topic.num_mafia = params[:num_mafia]
      new_topic.num_town = params[:num_town]
      new_topic.day_timelimit = params[:day_timelimit]
      new_topic.night_timelimit = params[:night_timelimit]
    end
    new_topic.save
    redirect_to root_path
  end
  
  def delete
    
  end
  
  def edit
    
  end
end
