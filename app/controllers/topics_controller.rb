class TopicsController < ApplicationController
  
  def create
    new_topic = Topic.new
    new_topic.user_id = current_user.id
    new_topic.title = params[:title]
    new_topic.category = params[:category]
    new_topic.content = params[:content]
    new_topic.save
    redirect_to root_path
  end
  
  def delete
    
  end
  
  def edit
    
  end
end
